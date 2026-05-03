{ config, pkgs, lib, ... }:
let
  agentWorkspaceBase = config.agents.workspaceBase;
  sharedWorkspace = "${agentWorkspaceBase}/shared";
  allowedDomains = config.agents.firewall.llmDomains
    ++ config.agents.firewall.privateDomains;
  agentGroup = config.agents.commonGroup;
  # Build a regex for matching
  domainRegex = builtins.concatStringsSep "|"
    (map (d: builtins.replaceStrings [ "." ] [ "\\." ] d) allowedDomains);
  proxyUrl = "http://127.0.0.1:${toString config.agents.proxy.port}";
  claudeCode = config.agents.claudeCode;
  codex = config.agents.codex;
  gemini = config.agents.gemini;
  pi = config.agents.pi;
  hermesPc = config.agents.hermesPc;
  hermesWork = config.agents.hermesWork;
  hermesPersonal = config.agents.hermesPersonal;
  mkAgentUser = { agent }: {
    name = agent.name;
    uid = agent.uid;
    group = agent.name;
    home = agent.home;
    description = agent.description;
    shell = agent.shell;
    isNormalUser = true;
    createHome = true;
    extraGroups = [ agentGroup ];
  };
  freeClaudeCodePath =
    lib.optionalString (claudeCode.enable && claudeCode.freeClaudeCode.enable)
    claudeCode.freeClaudeCode.path;
  systemdFreeClaudeCode = lib.optionalString
    (claudeCode.enable && claudeCode.freeClaudeCode.enable) ''
      --setenv=ANTHROPIC_BASE_URL="http://${claudeCode.freeClaudeCode.host}:${
        toString claudeCode.freeClaudeCode.port
      }" \
      --setenv=ANTHROPIC_AUTH_TOKEN="${claudeCode.freeClaudeCode.anthropicAuthToken}"
    '';

  # ──────────────────────────────────────────────
  # Wrapper to launch each agent in a sandboxed systemd-run
  # ──────────────────────────────────────────────
  mkAgentCommand = { agent }:
    let
      executor = pkgs.writeShellScriptBin "_${agent.name}-run" ''
        exec ${pkgs.systemd}/bin/systemd-run \
          --pty \
          --collect \
          --uid=${agent.name} \
          --gid=${agentGroup} \
          --unit="${agent.name}-$(date +%s)" \
          --working-directory="${agent.home}" \
          --setenv=HOME="${agent.home}" \
          --setenv=PATH="${agent.home}/.local/bin:${sharedWorkspace}/.npm-packages/bin:${pkgs.coreutils}/bin:${pkgs.nix}/bin:${pkgs.git}/bin:/run/current-system/sw/bin" \
          --setenv=XDG_CONFIG_HOME="${agent.home}/.config" \
          --setenv=XDG_CACHE_HOME="${agent.home}/.cache" \
          --setenv=NIX_CONF_DIR="/etc/nix" \
          --setenv=HTTP_PROXY="${proxyUrl}" \
          --setenv=HTTPS_PROXY="${proxyUrl}" \
          --setenv=http_proxy="${proxyUrl}" \
          --setenv=https_proxy="${proxyUrl}" \
          --setenv=NO_PROXY="localhost,127.0.0.1" \
          --setenv=BROWSER="${agentBrowserProxy}/bin/agent-browser" \
          ${systemdFreeClaudeCode} \
          ${
            lib.concatMapStringsSep " " (f: "--property=EnvironmentFile=${f}")
            agent.environmentFiles
          } \
          --property=ProtectHome=${if agent.protectHome then "yes" else "no"} \
          --property=ProtectSystem=${agent.protectSystem} \
          ${
            lib.concatMapStringsSep " " (p: "--property=ReadWritePaths=${p}")
            agent.readWritePaths
          } \
          ${
            lib.concatMapStringsSep " " (p: "--property=ReadOnlyPaths=${p}")
            agent.readOnlyPaths
          } \
          --property=PrivateTmp=${if agent.privateTmp then "yes" else "no"} \
          --property=NoNewPrivileges=${
            if agent.noNewPrivileges then "yes" else "no"
          } \
          --property=CapabilityBoundingSet=${agent.capabilityBoundingSet} \
          --property=MemoryMax=${agent.memoryMax} \
          --property=CPUQuota=${agent.cpuQuota} \
          --property=TasksMax=${toString agent.tasksMax} \
          --property=RestrictAddressFamilies="${
            lib.concatStringsSep " " agent.restrictAddressFamilies
          }" \
          -- \
          ${agent.command} "$@"
      '';
      wrapper = pkgs.writeShellScriptBin "${agent.name}" ''
        DIR="${agent.home}"
        if [[ -d "''${1:-}" ]]; then
          DIR="$DIR/$1"
          shift
        fi
        cd "$DIR" 2>/dev/null || true
        sudo chgrp -R ${agentGroup} $DIR
        sudo setfacl -R -m g::rwx $DIR
        sudo setfacl -R -m d:g::rwx $DIR
        exec sudo ${executor}/bin/_${agent.name}-run ${
          if agent.skipApprovals then agent.skipApprovalsFlag else ""
        } "$@"
      '';
    in {
      packages = [ executor wrapper ] ++ agent.packages;
      sudoCommand = "${executor}/bin/_${agent.name}-run";
    };

  enabledAgents = lib.optional claudeCode.enable claudeCode
    ++ lib.optional codex.enable codex ++ lib.optional gemini.enable gemini
    ++ lib.optional pi.enable pi ++ lib.optional hermesPc.enable hermesPc
    ++ lib.optional hermesWork.enable hermesWork
    ++ lib.optional hermesPersonal.enable hermesPersonal;

  enabledAgentsCmd =
    lib.optional claudeCode.enable (mkAgentCommand { agent = claudeCode; })
    ++ lib.optional codex.enable (mkAgentCommand { agent = codex; })
    ++ lib.optional gemini.enable (mkAgentCommand { agent = gemini; })
    ++ lib.optional pi.enable (mkAgentCommand { agent = pi; })
    ++ lib.optional hermesPc.enable (mkAgentCommand { agent = hermesPc; })
    ++ lib.optional hermesWork.enable (mkAgentCommand { agent = hermesWork; })
    ++ lib.optional hermesPersonal.enable
    (mkAgentCommand { agent = hermesPersonal; });

  mkAgentRules = agent: ''
    iptables -t nat -A OUTPUT -m owner --uid-owner ${agent.name} -j AGENT_PROXY
  '';

  mkAgentAllowRules = agent: ''
    iptables -A OUTPUT -m owner --uid-owner ${agent.name} -o lo -j ACCEPT
    iptables -A OUTPUT -m owner --uid-owner ${agent.name} -p udp --dport 53 -j ACCEPT
    iptables -A OUTPUT -m owner --uid-owner ${agent.name} -m state --state ESTABLISHED,RELATED -j ACCEPT
    iptables -A OUTPUT -m owner --uid-owner ${agent.name} -p tcp --dport 443 -j ACCEPT
    iptables -A OUTPUT -m owner --uid-owner ${agent.name} -p tcp --dport 80 -j ACCEPT
    iptables -A OUTPUT -m owner --uid-owner ${agent.name} -p tcp --dport 22 -j ACCEPT
    iptables -A OUTPUT -m owner --uid-owner ${agent.name} -j REJECT
  '';

  # ──────────────────────────────────────────────
  # The proxy script that agents use instead of xdg-open
  # ──────────────────────────────────────────────
  agentBrowserProxy = pkgs.writeShellScriptBin "agent-browser" ''
    set -euo pipefail

    URL="''${1:?Usage: agent-browser <url>}"

    # ── 1. Parse and validate the domain ──
    # Strip protocol, path, query, fragment
    domain=$(echo "$URL" | ${pkgs.coreutils}/bin/sed -E '
      s|^https?://||
      s|/.*||
      s|:.*||
    ')

    # Check against whitelist
    if ! echo "$domain" | ${pkgs.gnugrep}/bin/grep -qxE "(.*\\.)?(${domainRegex})"; then
      echo "BLOCKED: domain '$domain' is not in the whitelist" >&2
      echo "" >&2
      echo "Allowed domains:" >&2
      ${
        builtins.concatStringsSep "\n"
        (map (d: ''echo "  - ${d}" >&2'') allowedDomains)
      }
      exit 1
    fi

    # ── 2. Enforce HTTPS ──
    if echo "$URL" | ${pkgs.gnugrep}/bin/grep -qE "^http://"; then
      URL=$(echo "$URL" | ${pkgs.coreutils}/bin/sed 's|^http://|https://|')
      echo "Upgraded to HTTPS: $URL" >&2
    fi

    # ── 3. Fetch and render as text (default mode) ──
    # Most agents just need the content, not a visual browser
    echo "--- Fetching: $URL ---" >&2

    ${pkgs.curl}/bin/curl -fsSL \
      --max-time 30 \
      --max-filesize 5242880 \
      --user-agent "AgentBrowser/1.0" \
      "$URL" \
    | ${pkgs.html-tidy}/bin/tidy -q -asxhtml 2>/dev/null \
    | ${pkgs.pandoc}/bin/pandoc -f html -t plain --wrap=auto \
    || {
      echo "Failed to fetch or render $URL" >&2
      exit 1
    }
  '';

  # ──────────────────────────────────────────────
  # Visual browser mode (opens in isolated Chromium)
  # Only when the agent truly needs to render JS
  # ──────────────────────────────────────────────
  agentVisualBrowser = pkgs.writeShellScriptBin "agent-browser-visual" ''
    set -euo pipefail

    URL="''${1:?Usage: agent-browser-visual <url>}"

    # Same domain check
    domain=$(echo "$URL" | ${pkgs.coreutils}/bin/sed -E '
      s|^https?://||
      s|/.*||
      s|:.*||
    ')

    if ! echo "$domain" | ${pkgs.gnugrep}/bin/grep -qxE "(.*\\.)?(${domainRegex})"; then
      echo "BLOCKED: domain '$domain' is not in the whitelist" >&2
      exit 1
    fi

    # Launch headless Chromium, screenshot or dump DOM
    exec ${pkgs.chromium}/bin/chromium \
      --headless=new \
      --disable-gpu \
      --no-sandbox \
      --disable-extensions \
      --disable-plugins \
      --disable-sync \
      --disable-translate \
      --disable-background-networking \
      --disable-default-apps \
      --no-first-run \
      --user-data-dir="$(mktemp -d)" \
      --host-resolver-rules="MAP * ~NOTFOUND, EXCLUDE ${
        builtins.concatStringsSep ", EXCLUDE " allowedDomains
      }" \
      --dump-dom \
      "$URL" 2>/dev/null \
    | ${pkgs.pandoc}/bin/pandoc -f html -t plain --wrap=auto
  '';

  # ──────────────────────────────────────────────
  # Squid proxy config for network-level enforcement
  # (belt AND suspenders)
  # ──────────────────────────────────────────────
  squidAllowList = pkgs.writeText "agent-domains.txt"
    (builtins.concatStringsSep "\n" (map (d: ".${d}") allowedDomains));

  # Restricted git wrapper for agents
  restrictedGit = pkgs.writeShellScriptBin "git" ''
    set -euo pipefail

    REAL_GIT="${pkgs.git}/bin/git"

    # Get the subcommand (first non-flag argument)
    CMD=""
    ARGS=()
    for arg in "$@"; do
      if [[ -z "$CMD" && ! "$arg" =~ ^- ]]; then
        CMD="$arg"
      else
        ARGS+=("$arg")
      fi
    done

    blocked() {
      echo "BLOCKED: 'git $CMD' is not allowed in agent sandbox" >&2
      echo "This command could access files outside your sparse checkout." >&2
      exit 1
    }

    # ── Completely blocked commands ──
    case "$CMD" in
      # Direct object access - can read any file
      cat-file|show|ls-tree|archive|bundle)
        blocked
        ;;

      # Can extract/checkout arbitrary files
      restore|checkout-index)
        blocked
        ;;

      # Low-level commands that bypass checkout
      read-tree|write-tree|unpack-objects|unpack-file)
        blocked
        ;;

      # Dangerous plumbing
      update-ref|symbolic-ref|update-index)
        blocked
        ;;

      # Submodule operations could pull in more code
      submodule)
        blocked
        ;;

      # Worktree manipulation
      worktree)
        blocked
        ;;

      # Hooks could be used to escape
      hook)
        blocked
        ;;
    esac

    # ── Commands with restricted flags ──
    case "$CMD" in
      sparse-checkout)
        # Only allow 'list' - no init, set, disable, add, reapply
        SUBCMD="''${ARGS[0]:-}"
        case "$SUBCMD" in
          list)
            exec "$REAL_GIT" "$@"
            ;;
          *)
            echo "BLOCKED: 'git sparse-checkout $SUBCMD' is not allowed" >&2
            echo "Only 'git sparse-checkout list' is permitted." >&2
            exit 1
            ;;
        esac
        ;;

      log)
        # Block -p/--patch/--diff which show file contents
        for arg in "''${ARGS[@]}"; do
          case "$arg" in
            -p|--patch|-u|--diff|--cc|--combined|--stat-diff)
              echo "BLOCKED: 'git log' with diff output is not allowed" >&2
              echo "Use 'git log --oneline' or 'git log --stat' instead." >&2
              exit 1
              ;;
          esac
        done
        exec "$REAL_GIT" "$@"
        ;;

      diff)
        # Allow diff but only for files in the worktree (sparse checkout enforces this)
        # Block --no-index which compares arbitrary files
        for arg in "''${ARGS[@]}"; do
          case "$arg" in
            --no-index|--cached|--staged)
              # --cached/--staged could diff against index for files not checked out
              # Actually --cached is useful, let's allow it
              ;;
            --no-index)
              echo "BLOCKED: 'git diff --no-index' is not allowed" >&2
              exit 1
              ;;
          esac
        done
        exec "$REAL_GIT" "$@"
        ;;

      checkout)
        # Allow branch switching, block file checkout
        # 'git checkout <branch>' is ok
        # 'git checkout -- <file>' or 'git checkout <ref> -- <file>' is blocked
        for arg in "''${ARGS[@]}"; do
          if [[ "$arg" == "--" ]]; then
            echo "BLOCKED: 'git checkout -- <path>' is not allowed" >&2
            echo "Use 'git restore' for your sparse-checkout files instead." >&2
            exit 1
          fi
        done
        exec "$REAL_GIT" "$@"
        ;;

      clean)
        # Block -x/-X which could remove untracked files
        for arg in "''${ARGS[@]}"; do
          case "$arg" in
            -x|-X|--force)
              echo "BLOCKED: 'git clean -x/-X' is not allowed" >&2
              exit 1
              ;;
          esac
        done
        exec "$REAL_GIT" "$@"
        ;;

      ls-files)
        # Only allow listing tracked files in sparse checkout
        # Block --deleted, --others which could reveal structure
        for arg in "''${ARGS[@]}"; do
          case "$arg" in
            --deleted|--others|--ignored|--exclude-standard)
              echo "BLOCKED: 'git ls-files' with that flag is not allowed" >&2
              exit 1
              ;;
          esac
        done
        exec "$REAL_GIT" "$@"
        ;;

      config)
        # Block config changes that could weaken security
        for arg in "''${ARGS[@]}"; do
          case "$arg" in
            core.sparseCheckout*|core.bare|safe.*)
              echo "BLOCKED: cannot modify '$arg'" >&2
              exit 1
              ;;
          esac
        done
        exec "$REAL_GIT" "$@"
        ;;

      remote)
        # Block adding/modifying remotes
        SUBCMD="''${ARGS[0]:-}"
        case "$SUBCMD" in
          show|-v|--verbose)
            exec "$REAL_GIT" "$@"
            ;;
          *)
            echo "BLOCKED: 'git remote $SUBCMD' is not allowed" >&2
            echo "Only 'git remote show' and 'git remote -v' are permitted." >&2
            exit 1
            ;;
        esac
        ;;

      push)
        # Allow push but only to agent-namespaced branches
        # Check if there's a refspec that doesn't start with agent/
        # This is tricky, so for now just allow push
        # The server-side hooks should enforce branch protection
        exec "$REAL_GIT" "$@"
        ;;
    esac

    # ── Allow all other commands ──
    # add, commit, status, branch, fetch, pull, merge, rebase, stash,
    # tag (read-only), blame, grep (only searches sparse files), etc.
    exec "$REAL_GIT" "$@"
  '';

  agentSystemdFiles = { agent }: [
    # Per-agent bin directory with our override
    "d ${agent.home} 0775 ${agent.name} ${agentGroup} - -"
    "f ${agent.home}/.npmrc 0664 ${agent.name} ${agentGroup} - prefix=${sharedWorkspace}/.npm-packages"
    "d ${agent.home}/.local/bin 0770 ${agent.name} ${agentGroup} - -"
    "L+ ${agent.home}/.local/bin/xdg-open - ${agent.name} ${agentGroup} - ${agentBrowserProxy}/bin/agent-browser"
    "L+ ${agent.home}/.local/bin/open      - ${agent.name} ${agentGroup} - ${agentBrowserProxy}/bin/agent-browser"
    "L+ ${agent.home}/.local/bin/sensible-browser - ${agent.name} ${agentGroup} - ${agentBrowserProxy}/bin/agent-browser"
    "L+ ${agent.home}/.local/bin/git - ${agent.name} ${agentGroup} - ${restrictedGit}/bin/git"
  ];

in {

  users.groups = {
    ${agentGroup} = { };
  } // lib.listToAttrs
    (map (agent: lib.nameValuePair agent.name { }) enabledAgents);

  users.users = lib.listToAttrs
    (map (agent: lib.nameValuePair agent.name (mkAgentUser { agent = agent; }))
      enabledAgents);

  # ════════════════════════════════════════════════
  # INSTALL THE PROXY COMMANDS
  # ════════════════════════════════════════════════

  environment.systemPackages = with pkgs;
    [
      agentBrowserProxy
      agentVisualBrowser
      (writeShellScriptBin "antigravity-agents" ''
        # 1. Set umask so new files are group-writable (rw-rw-r--)
        umask 002
        # 2. Use 'sg' to run the IDE with '${agentGroup}' as the primary effective group
        exec sg ${agentGroup} -c " NIXPKGS_ALLOW_UNFREE=1 nix-shell -p antigravity --run antigravity \"$@\""
      '')
      (writeShellScriptBin "code-agents" ''
        # 1. Set umask so new files are group-writable (rw-rw-r--)
        umask 002
        # 2. Use 'sg' to run the IDE with '${agentGroup}' as the primary effective group
        exec sg ${agentGroup} -c "${vscode}/bin/code \"$@\""
      '')
      graalvmPackages.graalvm-ce
      (writeShellScriptBin "idea-ultimate-agents" ''
        # 1. Set umask so new files are group-writable (rw-rw-r--)
        umask 002
        # 2. Use 'sg' to run the IDE with '${agentGroup}' as the primary effective group
        exec sg ${agentGroup} -c "${jetbrains.idea-ultimate}/bin/idea-ultimate \"$@\""
      '')
      jdk
      maven
      pandoc
    ] ++ lib.concatMap (a: a.packages) enabledAgentsCmd;

  security.sudo.extraRules = [{
    users = [ "chous" ];
    commands = map (a: {
      command = a.sudoCommand;
      options = [ "NOPASSWD" ];
    }) enabledAgentsCmd;
  }];

  # ════════════════════════════════════════════════
  # OVERRIDE xdg-open FOR AGENT USERS
  #    So when any tool calls xdg-open, it hits
  #    our proxy instead of the real browser
  # ════════════════════════════════════════════════

  systemd.tmpfiles.rules =
    [ "d ${sharedWorkspace} 2750 root ${agentGroup} - -" ]
    ++ lib.concatMap (agent: agentSystemdFiles { inherit agent; })
    enabledAgents;

  fileSystems = lib.listToAttrs (map (agent:
    lib.nameValuePair "${agent.home}/.m2/repository" {
      device = "${sharedWorkspace}/.m2/repository";
      fsType = "none";
      options = [ "bind" "rw" ];
    }) enabledAgents);

  # ── Decrypt secrets into agent homes ──
  sops = rec {
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets = {
      "free-claude-code-env" = (lib.mkIf claudeCode.enable
        (lib.mkIf claudeCode.freeClaudeCode.enable {
          path = "${freeClaudeCodePath}/.env.new";
          sopsFile = ../private/secrets/free-claude-code.env;
          format = "dotenv";
          mode = "0400";
          owner = claudeCode.name;
          group = agentGroup;
        }));
    };
  };

  # ════════════════════════════════════════════════
  # NETWORK-LEVEL ENFORCEMENT WITH SQUID
  #    Even if they bypass the script, they can't
  #    reach non-whitelisted domains
  # ════════════════════════════════════════════════

  services.squid = {
    enable = true;
    configText = ''
      # ACLs
      acl localnet src 10.0.0.0/8
      acl localnet src 172.16.0.0/12
      acl localnet src 192.168.0.0/16
      acl SSL_ports port 443
      acl Safe_ports port 80
      acl Safe_ports port 443
      acl Safe_ports port 1025-65535
      acl CONNECT method CONNECT

      # Basic safety
      http_access deny !Safe_ports
      http_access deny CONNECT !SSL_ports

      # Cache manager
      http_access allow localhost manager
      http_access deny manager

      # Domain whitelist
      acl allowed_domains dstdomain "${squidAllowList}"

      # Allow CONNECT (HTTPS) to whitelisted domains
      http_access allow CONNECT allowed_domains

      # Allow HTTP to whitelisted domains
      http_access allow allowed_domains

      # Allow localhost
      http_access allow localhost

      # Block everything else
      http_access deny all

      # Listen on localhost only
      http_port 127.0.0.1:3128

      # Logging
      cache_log       stdio:/var/log/squid/cache.log
      access_log      stdio:/var/log/squid/access.log
      cache_store_log stdio:/var/log/squid/store.log

      pid_filename    /run/squid.pid
      cache_effective_user squid squid
      coredump_dir /var/cache/squid

      refresh_pattern ^ftp:           1440    20%     10080
      refresh_pattern -i (/cgi-bin/|\?) 0     0%      0
      refresh_pattern .               0       20%     4320
    '';
  };

  # ════════════════════════════════════════════════
  # IPTABLES: FORCE ALL AGENT TRAFFIC THROUGH SQUID
  # ════════════════════════════════════════════════

  networking.firewall.extraCommands = ''
    iptables -t nat -F AGENT_PROXY 2>/dev/null || true
    iptables -t nat -X AGENT_PROXY 2>/dev/null || true
    iptables -t nat -N AGENT_PROXY

    iptables -t nat -A AGENT_PROXY -p tcp --dport 80 -j REDIRECT --to-port 3128
    iptables -t nat -A AGENT_PROXY -p tcp --dport 443 -j REDIRECT --to-port 3128

    ${lib.concatMapStringsSep "\n" mkAgentRules enabledAgents}
    ${lib.concatMapStringsSep "\n" mkAgentAllowRules enabledAgents}
  '';

}

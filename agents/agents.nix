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

  # Direct TCP destinations agents may reach WITHOUT the Squid proxy.
  # Squid only carries HTTP/HTTPS; MongoDB, SSH, etc. speak their own wire
  # protocol and would otherwise hit the per-uid iptables REJECT below.
  # Keep this list narrow: one host + one port per entry.
  directTcpAllow = [{
    host = "85.10.206.214";
    port = 23;
    comment = "Gitlab SSH";
  }];
  noProxyHosts = lib.concatStringsSep "," ([ "localhost" "127.0.0.1" ]
    ++ map (r: r.host)
    (lib.filter (r: builtins.elem r.port [ 80 443 ]) directTcpAllow));

  claudeCode = config.agents.claudeCode;
  codex = config.agents.codex;
  pi = config.agents.pi;
  hermesPc = config.agents.hermesPc;
  hermesWork = config.agents.hermesWork;
  hermesPersonal = config.agents.hermesPersonal;
  deepseek = config.agents.deepseek;
  jules = config.agents.jules;
  grok = config.agents.grok;
  gitclaw = config.agents.gitclaw;
  kimiCode = config.agents.kimiCode;
  minimaxCode = config.agents.minimaxCode;
  opencode2 = config.agents.opencode2;
  qwenCode = config.agents.qwenCode;
  museCode = config.agents.museCode;
  zcode = config.agents.zcode;
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
  freeClaudeCode = config.agents.freeClaudeCode;

  # ──────────────────────────────────────────────
  # Wrapper to launch each agent in a sandboxed systemd-run
  # ──────────────────────────────────────────────
  mkAgentCommand = { agent }:
    let
      executor = pkgs.writeShellScriptBin "_${agent.name}-run" ''
        DIR=$1
        shift
        cd "$DIR" 2>/dev/null || echo "Cannot use folder $DIR"
        exec ${pkgs.systemd}/bin/systemd-run \
          --pty \
          --collect \
          --uid=${agent.name} \
          --gid=${agentGroup} \
          --unit="${agent.name}-$(date +%s)" \
          --working-directory="$DIR" \
          --setenv=HOME="${agent.home}" \
          --setenv=PATH="${pkgs.openjdk11}/bin:${agent.home}/.local/bin:${sharedWorkspace}/.npm-packages/bin:${sharedWorkspace}/.pnpm:${pkgs.coreutils}/bin:${pkgs.nix}/bin:${pkgs.git}/bin:${agentVisualBrowser}/bin:/run/current-system/sw/bin" \
          --setenv=PNPM_HOME="${sharedWorkspace}/.pnpm" \
          --setenv=XDG_CONFIG_HOME="${agent.home}/.config" \
          --setenv=XDG_CACHE_HOME="${agent.home}/.cache" \
          --setenv=NIX_CONF_DIR="/etc/nix" \
          --setenv=DBUS_SESSION_BUS_ADDRESS="/dev/null" \
          --setenv=DISPLAY="" \
          --setenv=WAYLAND_DISPLAY="" \
          --setenv=GIT_CONFIG_GLOBAL="${agentGitConfig}" \
          --setenv=PUPPETEER_EXECUTABLE_PATH="${agentVisualBrowser}/bin/chromium" \
          --setenv=PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH="${agentVisualBrowser}/bin/chromium" \
          --setenv=HTTP_PROXY="${proxyUrl}" \
          --setenv=HTTPS_PROXY="${proxyUrl}" \
          --setenv=http_proxy="${proxyUrl}" \
          --setenv=https_proxy="${proxyUrl}" \
          --setenv=JAVA_HOME="${pkgs.openjdk11}/lib/openjdk" \
          --setenv=JAVA_TOOL_OPTIONS="-Dhttp.proxyHost=127.0.0.1 -Dhttp.proxyPort=${
            toString config.agents.proxy.port
          } -Dhttps.proxyHost=127.0.0.1 -Dhttps.proxyPort=${
            toString config.agents.proxy.port
          }" \
          --setenv=NO_PROXY="${noProxyHosts}" \
          --setenv=no_proxy="${noProxyHosts}" \
          ${
            if agent.useFreeClaudeCode then ''
              --setenv=ANTHROPIC_BASE_URL="http://${freeClaudeCode.host}:${
                toString freeClaudeCode.port
              }" \
                --setenv=ANTHROPIC_AUTH_TOKEN="${freeClaudeCode.anthropicAuthToken}" \
            '' else
              ""
          }   --setenv=BROWSER="${agentBrowserProxy}/bin/agent-browser" \
          ${
            lib.concatMapStringsSep " " (f: "--property=EnvironmentFile=${f}")
            agent.environmentFiles
          } \
          --property=EnvironmentFile=-${agent.home}/.mcp-env \
          --property=WorkingDirectory=$DIR \
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
          ${agent.command} \
          -- \
          ${if agent.skipApprovals then agent.skipApprovalsFlag else ""} \
          ${
            if agent.customChangeDirFlag != "" then
              "${agent.customChangeDirFlag} $DIR"
            else
              ""
          } \
          "$@"
      '';
      wrapper = pkgs.writeShellScriptBin "${agent.name}" ''
        if [[ -d "''${1:-}" ]]; then
          DIR="$1"
          shift
          echo "DIR set to $DIR"
        else
          DIR="${agent.home}"
          echo "DIR set to agent home"
        fi
        sudo chgrp -R ${agentGroup} $DIR
        sudo setfacl -R -m g::rwx $DIR
        sudo setfacl -R -m d:g::rwx $DIR
        exec sudo ${executor}/bin/_${agent.name}-run $DIR "$@"
      '';
    in {
      packages = [ executor wrapper agentVisualBrowser ] ++ agent.packages;
      sudoCommand = "${executor}/bin/_${agent.name}-run";
    };

  enabledAgents = lib.optional claudeCode.enable claudeCode
    ++ lib.optional codex.enable codex ++ lib.optional pi.enable pi
    ++ lib.optional hermesPc.enable hermesPc
    ++ lib.optional hermesWork.enable hermesWork
    ++ lib.optional hermesPersonal.enable hermesPersonal
    ++ lib.optional deepseek.enable deepseek ++ lib.optional jules.enable jules
    ++ lib.optional grok.enable grok ++ lib.optional gitclaw.enable gitclaw
    ++ lib.optional kimiCode.enable kimiCode
    ++ lib.optional minimaxCode.enable minimaxCode
    ++ lib.optional opencode2.enable opencode2
    ++ lib.optional qwenCode.enable qwenCode
    ++ lib.optional museCode.enable museCode ++ lib.optional zcode.enable zcode;

  enabledAgentsCmd =
    lib.optional claudeCode.enable (mkAgentCommand { agent = claudeCode; })
    ++ lib.optional codex.enable (mkAgentCommand { agent = codex; })
    ++ lib.optional pi.enable (mkAgentCommand { agent = pi; })
    ++ lib.optional hermesPc.enable (mkAgentCommand { agent = hermesPc; })
    ++ lib.optional hermesWork.enable (mkAgentCommand { agent = hermesWork; })
    ++ lib.optional hermesPersonal.enable
    (mkAgentCommand { agent = hermesPersonal; })
    ++ lib.optional deepseek.enable (mkAgentCommand { agent = deepseek; })
    ++ lib.optional jules.enable (mkAgentCommand { agent = jules; })
    ++ lib.optional grok.enable (mkAgentCommand { agent = grok; })
    ++ lib.optional gitclaw.enable (mkAgentCommand { agent = gitclaw; })
    ++ lib.optional kimiCode.enable (mkAgentCommand { agent = kimiCode; })
    ++ lib.optional minimaxCode.enable (mkAgentCommand { agent = minimaxCode; })
    ++ lib.optional opencode2.enable (mkAgentCommand { agent = opencode2; })
    ++ lib.optional museCode.enable (mkAgentCommand { agent = museCode; })
    ++ lib.optional qwenCode.enable (mkAgentCommand { agent = qwenCode; })
    ++ lib.optional zcode.enable (mkAgentCommand { agent = zcode; });

  mkAgentAllowRules = agent: ''
    # Allow loopback to communicate with the Squid proxy
    iptables -I OUTPUT -m owner --uid-owner ${agent.name} -o lo -j ACCEPT

    # Allow external DNS lookups
    iptables -I OUTPUT -m owner --uid-owner ${agent.name} -p udp --dport 53 -j ACCEPT
    iptables -I OUTPUT -m owner --uid-owner ${agent.name} -p tcp --dport 53 -j ACCEPT

    # Allow established connections to persist
    iptables -I OUTPUT -m owner --uid-owner ${agent.name} -m state --state ESTABLISHED,RELATED -j ACCEPT

    # Explicit non-HTTP destinations (see directTcpAllow)
    ${lib.concatMapStringsSep "\n" (r: ''
      # ${r.comment}
      iptables -I OUTPUT -m owner --uid-owner ${agent.name} -d ${r.host} -p tcp --dport ${
        toString r.port
      } -j ACCEPT
    '') directTcpAllow}

    # Drop everything else. Direct outbound connections on 80/443 are strictly prohibited.
    iptables -A OUTPUT -m owner --uid-owner ${agent.name} -j REJECT

    # Same policy for IPv6. Without this, any global IPv6 address on the host
    # lets the agent bypass the proxy entirely.
    ip6tables -I OUTPUT -m owner --uid-owner ${agent.name} -o lo -j ACCEPT
    ip6tables -I OUTPUT -m owner --uid-owner ${agent.name} -p udp --dport 53 -j ACCEPT
    ip6tables -I OUTPUT -m owner --uid-owner ${agent.name} -p tcp --dport 53 -j ACCEPT
    ip6tables -I OUTPUT -m owner --uid-owner ${agent.name} -m state --state ESTABLISHED,RELATED -j ACCEPT
    ip6tables -A OUTPUT -m owner --uid-owner ${agent.name} -j REJECT
  '';

  agentGitConfig = pkgs.writeText "agent-gitconfig" ''
    [safe]
    directory = *

    [alias]
    git = !git
    wta = "!f() { ROOT=$(git rev-parse --show-toplevel); REPO=$(basename \"$ROOT\"); BASE=$(dirname $(dirname \"$ROOT\")); DEST=\"$BASE/$1/$REPO\"; if git show-ref --verify --quiet \"refs/heads/$1\"; then git worktree add \"$DEST\" \"$1\"; else git worktree add -b \"$1\" \"$DEST\"; fi; cd \"$DEST\"; }; f"
    wtr = "!f() { ROOT=$(git rev-parse --show-toplevel); REPO=$(basename \"$ROOT\"); BASE=$(dirname $(dirname \"$ROOT\")); git worktree remove \"$BASE/$1/$REPO\"; }; f"
    wtl = worktree list
  '';

  # ──────────────────────────────────────────────
  # The proxy script that agents use instead of xdg-open
  # ──────────────────────────────────────────────
  agentBrowserProxy = pkgs.writeShellScriptBin "agent-browser" ''
    set -euo pipefail

    URL="''${1:?Usage: agent-browser <url>}"

    # ── 1. Parse and validate the domain ──
    # Strip protocol, path, query, fragment
    domain=$(echo "$URL" | ${pkgs.gnused}/bin/sed -E '
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
      URL=$(echo "$URL" | ${pkgs.gnused}/bin/sed 's|^http://|https://|')
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
  agentVisualBrowser = pkgs.writeShellScriptBin "chromium" ''
    set -euo pipefail

    URL="''${1:?Usage: chromium <url>}"

    # Same domain check
    domain=$(echo "$URL" | ${pkgs.gnused}/bin/sed -E '
      s|^https?://||
      s|/.*||
      s|:.*||
    ')

    if ! echo "$domain" | ${pkgs.gnugrep}/bin/grep -qxE "(.*\\.)?(${domainRegex})"; then
      echo "BLOCKED: domain '$domain' is not in the whitelist" >&2
      exit 1
    fi

    export DBUS_SESSION_BUS_ADDRESS="/dev/null"
    export DISPLAY=""
    export WAYLAND_DISPLAY=""

    # Launch headless Chromium, screenshot or dump DOM
    exec ${pkgs.chromium}/bin/chromium \
      --headless=new \
      --ozone-platform=headless \
      --disable-gpu \
      --disable-software-rasterizer \
      --disable-dev-shm-usage \
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
    WORKSPACE="${sharedWorkspace}"

    blocked() { echo "BLOCKED: $1" >&2; exit 1; }

    # Config keys that run programs, redefine commands, or widen what git may touch.
    # Refused on -c, --config-env and 'git config'. Section and key names are lowercased by git.
    deny_key() {
      case "''${1,,}" in
        alias.*|include.*|includeif.*|safe.*|core.sparsecheckout*|core.bare|core.hookspath|\
        core.sshcommand|core.gitproxy|core.pager|core.editor|core.askpass|core.fsmonitor|\
        core.alternaterefscommand|credential.*|diff.external|diff.*.command|diff.*.textconv|\
        difftool.*|mergetool.*|merge.*.driver|filter.*|gpg.*|sequence.editor|uploadpack.*|\
        receive.*|url.*|http.*|remote.*.proxy|remote.*.uploadpack|remote.*.receivepack|protocol.*)
          return 0 ;;
      esac
      return 1
    }

    # A worktree path must resolve inside the workspace and outside the canonical clones.
    check_path() {
      local p="$1" abs
      case "$p" in /*) abs="$(realpath -m -- "$p")" ;; *) abs="$(realpath -m -- "''${CDIR:-.}/$p")" ;; esac
      case "$abs" in
        "$WORKSPACE"/.canonical/*) blocked "worktrees may not be created inside .canonical ($abs)" ;;
        "$WORKSPACE"/*) ;;
        *) blocked "worktree path outside the workspace: $abs" ;;
      esac
    }

    # Environment that would bypass the rules below; the ssh config in ~/.ssh covers GIT_SSH_COMMAND.
    unset GIT_DIR GIT_WORK_TREE GIT_EXEC_PATH GIT_SSH GIT_SSH_COMMAND GIT_EDITOR GIT_SEQUENCE_EDITOR \
          GIT_PAGER GIT_ASKPASS GIT_CONFIG_SYSTEM GIT_CONFIG_NOSYSTEM GIT_ALTERNATE_OBJECT_DIRECTORIES \
          GIT_OBJECT_DIRECTORY GIT_NAMESPACE GIT_PROXY_COMMAND GIT_EXTERNAL_DIFF GIT_CONFIG_COUNT
    for v in "''${!GIT_CONFIG_@}"; do unset "$v"; done
    export GIT_CONFIG_GLOBAL="${agentGitConfig}"

    # ── Global options, parsed as git parses them ──
    CDIR=""; CMD=""; GLOBAL=(); ARGS=()
    while [ $# -gt 0 ]; do
      case "$1" in
        -C)
          [ $# -ge 2 ] || blocked "'-C' needs a path"
          CDIR="$2"; GLOBAL+=("$1" "$2"); shift 2 ;;
        -c|--config-env)
          [ $# -ge 2 ] || blocked "'$1' needs an argument"
          key="''${2%%=*}"
          deny_key "$key" && blocked "'$1 $key' is not allowed"
          GLOBAL+=("$1" "$2"); shift 2 ;;
        --config-env=*)
          key="''${1#--config-env=}"; key="''${key%%=*}"
          deny_key "$key" && blocked "'--config-env=$key' is not allowed"
          GLOBAL+=("$1"); shift ;;
        --exec-path|--exec-path=*|--git-dir|--git-dir=*|--work-tree|--work-tree=*|--bare|\
        --namespace|--namespace=*|--super-prefix=*|--attr-source=*)
          blocked "'$1' is not allowed in the agent sandbox" ;;
        --version|--help|-h|--html-path|--man-path|--info-path|--list-cmds=*)
          exec "$REAL_GIT" "$@" ;;
        -p|--paginate|-P|--no-pager|--no-replace-objects|--no-lazy-fetch|--no-optional-locks|\
        --no-advice|--literal-pathspecs|--glob-pathspecs|--noglob-pathspecs|--icase-pathspecs)
          GLOBAL+=("$1"); shift ;;
        -*) blocked "unknown global option '$1'" ;;
        *)  CMD="$1"; shift; ARGS=("$@"); break ;;
      esac
    done
    [ -n "$CMD" ] || exec "$REAL_GIT" "''${GLOBAL[@]}"

    # ── Subcommands ──
    case "$CMD" in
      cat-file|show|ls-tree|archive|bundle|restore|checkout-index|read-tree|write-tree|\
      unpack-objects|unpack-file|update-ref|symbolic-ref|update-index|submodule|hook|replace|\
      filter-branch|fast-import)
        blocked "'git $CMD' is not allowed in the agent sandbox" ;;

      worktree)
        SUB="''${ARGS[0]:-}"
        POS=()
        i=1
        while [ $i -lt "''${#ARGS[@]}" ]; do
          a="''${ARGS[$i]}"
          case "$a" in
            -b|-B|--reason) i=$((i + 2)); continue ;;
            --) i=$((i + 1)); POS+=("''${ARGS[@]:$i}"); break ;;
            -*) i=$((i + 1)); continue ;;
          esac
          POS+=("$a"); i=$((i + 1))
        done
        case "$SUB" in
          list|prune|lock|unlock) ;;
          add)    [ "''${#POS[@]}" -ge 1 ] && check_path "''${POS[0]}" ;;
          remove) [ "''${#POS[@]}" -ge 1 ] && case "''${POS[0]}" in */*) check_path "''${POS[0]}" ;; esac ;;
          move)   [ "''${#POS[@]}" -ge 1 ] && case "''${POS[0]}" in */*) check_path "''${POS[0]}" ;; esac
                  [ "''${#POS[@]}" -ge 2 ] && check_path "''${POS[1]}" ;;
          *) blocked "'git worktree $SUB' is not allowed" ;;
        esac ;;

      sparse-checkout)
        [ "''${ARGS[0]:-}" = list ] || blocked "only 'git sparse-checkout list' is permitted" ;;

      config)
        for a in "''${ARGS[@]}"; do
          case "$a" in
            --get|--get-all|--get-regexp|--list|-l|--show-origin|--show-scope) exec "$REAL_GIT" "''${GLOBAL[@]}" "$CMD" "''${ARGS[@]}" ;;
            --file|-f|--file=*|--system|--blob|--blob=*|--edit|-e)
              blocked "'git config $a' is not allowed" ;;
            -*) continue ;;
          esac
          deny_key "$a" && blocked "cannot touch '$a'"
        done ;;

      log)
        for a in "''${ARGS[@]}"; do
          case "$a" in -p|--patch|-u|--diff|--cc|--combined)
            blocked "'git log' with diff output is not allowed; use --oneline or --stat" ;;
          esac
        done ;;

      diff)
        for a in "''${ARGS[@]}"; do
          [ "$a" = --no-index ] && blocked "'git diff --no-index' is not allowed"
        done ;;

      checkout)
        for a in "''${ARGS[@]}"; do
          [ "$a" = -- ] && blocked "'git checkout -- <path>' is not allowed; use 'git restore'"
        done ;;

      clean)
        for a in "''${ARGS[@]}"; do
          case "$a" in -x|-X|--force) blocked "'git clean $a' is not allowed" ;; esac
        done ;;

      ls-files)
        for a in "''${ARGS[@]}"; do
          case "$a" in --deleted|--others|--ignored|--exclude-standard)
            blocked "'git ls-files $a' is not allowed" ;;
          esac
        done ;;

      remote)
        case "''${ARGS[0]:-}" in show|-v|--verbose|"") ;; *)
          blocked "only 'git remote show' and 'git remote -v' are permitted" ;;
        esac ;;
    esac

    exec "$REAL_GIT" "''${GLOBAL[@]}" "$CMD" "''${ARGS[@]}"
  '';

  agentKnownHosts = agent:
    pkgs.writeText "${agent.name}-known_hosts" ''
      [gitlab.colordigital.cloud]:23 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILbVrmNfDCevnlVtvi1VDDc43w8rRjlr5rAUvz+KCjT6
      [gitlab.colordigital.cloud]:23 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFzol/JHRCYxyPoZ1WFTXJOwsovDFoLko6ODcYugJIjFiDlI3Egdc2VYOkuWZNWheMoNEU3UF2/x/TSrxTHmuL4=
    '';

  agentSshConfig = agent:
    pkgs.writeText "${agent.name}-ssh_config" ''
      UserKnownHostsFile ${agentKnownHosts agent}
      StrictHostKeyChecking yes
      ForwardX11 no

      Host gitlab.colordigital.cloud
        Port 23
        User git
        IdentityFile ${agent.home}/.ssh/id_ed25519
        IdentitiesOnly yes
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
    "d  ${agent.home}/.ssh 0700 ${agent.name} ${agentGroup} - -"
    "L+ ${agent.home}/.ssh/config - ${agent.name} ${agentGroup} - ${
      agentSshConfig agent
    }"
  ];

in {

  users.groups = {
    ${agentGroup} = { };
  } // lib.listToAttrs
    (map (agent: lib.nameValuePair agent.name { }) enabledAgents);

  users.users = lib.listToAttrs (map (agent:
    lib.nameValuePair agent.name (
      # Merge the result of mkAgentUser with the mandatory groups
      lib.recursiveUpdate (mkAgentUser { inherit agent; }) {
        extraGroups = [ agentGroup ];
      })) enabledAgents);

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
      openjdk11
      graalvmPackages.graalvm-ce
      (writeShellScriptBin "idea-agents" ''
        # 1. Set umask so new files are group-writable (rw-rw-r--)
        umask 002
        # 2. Use 'sg' to run the IDE with '${agentGroup}' as the primary effective group
        cd ${sharedWorkspace}
        exec sg ${agentGroup} -c "${jetbrains.idea}/bin/idea \"$@\""
      '')
      maven
      pandoc
      pnpm
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

  systemd.tmpfiles.rules = [
    "d ${sharedWorkspace} 2750 root ${agentGroup} - -"
    # pnpm global bin dir (PNPM_HOME), shared like .npm-packages
    "d ${sharedWorkspace}/.pnpm 2775 root ${agentGroup} - -"
  ] ++ lib.concatMap (agent: agentSystemdFiles { inherit agent; })
    enabledAgents;

  fileSystems = lib.listToAttrs (lib.flatten (map (agent: [
    # 1. The Maven repository mount
    (lib.nameValuePair "${agent.home}/.m2" {
      device = "${sharedWorkspace}/.m2";
      fsType = "none";
      options = [ "bind" "rw" ];
    })

    # 2. The shared node_modules mount
    (lib.nameValuePair "${agent.home}/.node-modules" {
      device = "${sharedWorkspace}/.node-modules";
      fsType = "none";
      options = [ "bind" "rw" ];
    })
  ]) enabledAgents));

  system.activationScripts = {
    # Crucial for file bind-mounts: the target file must physically exist first
    ensureAgentMountTargets = {
      text = lib.concatMapStringsSep "\n" (agent: ''
        mkdir -p "${agent.home}/.m2"
        touch "${agent.home}/.bashrc"
        # Ensure ownership matches the agent user if necessary
        chown -R ${agent.name} "${agent.home}" 2>/dev/null || true
      '') enabledAgents;
      deps = [ "users" ];
    };

    linkAgentBashrc = {
      text = lib.concatMapStringsSep "\n" (agent: ''
        mkdir -p "${agent.home}"

        cat << 'EOF' > "${agent.home}/.bashrc"
        # 1. Force Java 11 into the front of the PATH for this agent
        export JAVA_HOME="${pkgs.openjdk11}/lib/openjdk"
        export PATH="$JAVA_HOME/bin:$PATH"

        # 2. Source the shared base configuration
        if [ -f "${sharedWorkspace}/.bashrc" ]; then
            source "${sharedWorkspace}/.bashrc"
        fi

        # 3. Per-agent secrets for MCP servers (KEY="value" lines, no 'export').
        #    systemd-run also loads this file via EnvironmentFile, so the agent
        #    process and its MCP children see the same variables.
        if [ -f "$HOME/.mcp-env" ]; then
            set -a; . "$HOME/.mcp-env"; set +a
        fi
        EOF

        chown ${agent.name} "${agent.home}/.bashrc"
      '') enabledAgents;
      deps = [ "users" ];
    };
    agentSshKeys = {
      text = lib.concatMapStringsSep "\n" (agent: ''
        install -d -m 0700 -o ${agent.name} -g ${agentGroup} "${agent.home}/.ssh"
        if [ ! -f "${agent.home}/.ssh/id_ed25519" ]; then
          ${pkgs.openssh}/bin/ssh-keygen -q -t ed25519 -N "" \
            -C "${agent.name}@$(hostname)" -f "${agent.home}/.ssh/id_ed25519"
          chown ${agent.name}:${agentGroup} "${agent.home}/.ssh/id_ed25519"*
          chmod 0600 "${agent.home}/.ssh/id_ed25519"
        fi
      '') enabledAgents;
      deps = [ "users" ];
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

      # NOTE: do NOT add "http_access allow localhost" here. Every agent
      # request arrives from 127.0.0.1, so that line would match them all
      # and silently disable the whitelist above.

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
    ${lib.concatMapStringsSep "\n" mkAgentAllowRules enabledAgents}
  '';
}

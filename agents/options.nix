# agents/options.nix
{ pkgs, lib, config, ... }:
let cfg = config.agents;
    mkClaudeCodeOptions = {
      instanceName,
        defaultUserName ? instanceName,
        defaultDescription ? "Claude Code agent (${instanceName})",
        defaultHome ? "${cfg.workspaceBase}/${instanceName}",
        defaultUid,
        defaultEnvironmentFiles ? [  ],
    }: {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the Claude Code ${instanceName} agent";
      };
      name = lib.mkOption {
        type = lib.types.str;
        description = "The name of the ${instanceName} user";
        default = defaultUserName;
      };
      description = lib.mkOption {
        type = lib.types.str;
        description = "The description of the ${instanceName} user";
        default = defaultDescription;
      };
      version = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description =
          "Version/commit of Claude Code (e.g. '2.1.120' or '002de6e')";
        example = "2.1.120";
      };
      home = lib.mkOption {
        type = lib.types.path;
        description = "The home folder of the ${instanceName} user";
        default = defaultHome;
      };
      uid = lib.mkOption {
        type = lib.types.int;
        description = "The UID of the ${instanceName} user";
        default = defaultUid;
      };
      shell = lib.mkOption {
        type = lib.types.attrs;
        description = "The shell of the ${instanceName} user";
        default = pkgs.bash;
      };
      command = lib.mkOption {
        type = lib.types.str;
        description = "The command to run ${instanceName}";
        default = let
          instanceCfg = cfg.${instanceName};
          ref = lib.optionalString (instanceCfg.version != null)
            "/${instanceCfg.version}";
        in "${pkgs.nix}/bin/nix --extra-experimental-features 'nix-command flakes' run --refresh github:sadjow/claude-code-nix${ref} --";
      };
      environmentFiles = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        description = "Environment files for ${instanceName}";
        default = defaultEnvironmentFiles;
      };
      protectHome = lib.mkOption {
        type = lib.types.bool;
        description = "Whether to protect the home folder of ${instanceName}";
        default = true;
      };
      protectSystem = lib.mkOption {
        type = lib.types.str;
        description = "System protection strategy of ${instanceName}";
        default = "strict";
      };
      readWritePaths = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Paths with read and write permissions for ${instanceName}";
        default = [
          defaultHome
          "/nix/var/nix"
          "${cfg.workspaceBase}/shared"
        ];
      };
      readOnlyPaths = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Paths with read-only permissions for ${instanceName}";
        default = [ "/nix/store" ];
      };
      privateTmp = lib.mkOption {
        type = lib.types.bool;
        description = "Whether TMP is private for ${instanceName}";
        default = true;
      };
      noNewPrivileges = lib.mkOption {
        type = lib.types.bool;
        description = "Prevent new privileges for ${instanceName}";
        default = false;
      };
      capabilityBoundingSet = lib.mkOption {
        type = lib.types.str;
        description = "The capability bounding set for ${instanceName}";
        default = "";
      };
      memoryMax = lib.mkOption {
        type = lib.types.str;
        description = "The max memory for ${instanceName}";
        default = "1G";
      };
      cpuQuota = lib.mkOption {
        type = lib.types.str;
        description = "The CPU quota for ${instanceName}";
        default = "200%";
      };
      tasksMax = lib.mkOption {
        type = lib.types.int;
        description = "The maximum number of tasks for ${instanceName}";
        default = 100;
      };
      restrictAddressFamilies = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "The address families to restrict for ${instanceName}";
        default = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
      };
      packages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        description = "Additional packages for ${instanceName}";
        default = with pkgs; [ nix ];
      };
    };

    mkCodexOptions = {
      instanceName,
        defaultUserName ? instanceName,
        defaultDescription ? "Codex agent (${instanceName})",
        defaultHome ? "${cfg.workspaceBase}/${instanceName}",
        defaultUid,
        defaultEnvironmentFiles ? [  ],
    }: {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the Codex ${instanceName} agent";
      };
      name = lib.mkOption {
        type = lib.types.str;
        description = "The name of the Codex ${instanceName} user";
        default = defaultUserName;
      };
      description = lib.mkOption {
        type = lib.types.str;
        description = "The description of the Codex ${instanceName} agent";
        default = defaultDescription;
      };
      version = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Version/commit of Codex (e.g. '0.125.0' or 'fc382be')";
        example = "0.125.0";
      };
      home = lib.mkOption {
        type = lib.types.path;
        description = "The home folder of the Codex ${instanceName} user";
        default = defaultHome;
      };
      uid = lib.mkOption {
        type = lib.types.int;
        description = "The UID of the Codex ${instanceName} user";
        default = defaultUid;
      };
      shell = lib.mkOption {
        type = lib.types.attrs;
        description = "The shell of the Codex ${instanceName} user";
        default = pkgs.bash;
      };
      command = lib.mkOption {
        type = lib.types.str;
        description = "The command to run Codex ${instanceName} ";
        default = let
          instanceCfg = cfg.${instanceName};
          ref = lib.optionalString (instanceCfg.version != null)
            "/${instanceCfg.version}";
        in "${pkgs.nix}/bin/nix --extra-experimental-features 'nix-command flakes' run --refresh github:sadjow/codex-cli-nix${ref} --";
      };
      environmentFiles = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        description = "Environment files for ${instanceName}";
        default = defaultEnvironmentFiles;
      };
      protectHome = lib.mkOption {
        type = lib.types.bool;
        description = "Whether to protect the home folder of ${instanceName}";
        default = true;
      };
      protectSystem = lib.mkOption {
        type = lib.types.str;
        description = "System protection strategy for ${instanceName}";
        default = "strict";
      };
      readWritePaths = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Paths with read and write permissions for ${instanceName}";
        default = [
          defaultHome
          "/nix/var/nix"
          "${cfg.workspaceBase}/shared"
        ];
      };
      readOnlyPaths = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Paths with read-only permissions for ${instanceName}";
        default = [ "/nix/store" ];
      };
      privateTmp = lib.mkOption {
        type = lib.types.bool;
        description = "Whether TMP is private for ${instanceName}";
        default = true;
      };
      noNewPrivileges = lib.mkOption {
        type = lib.types.bool;
        description = "Prevent new privileges for ${instanceName}";
        default = false;
      };
      capabilityBoundingSet = lib.mkOption {
        type = lib.types.str;
        description = "The capability bounding set for ${instanceName}";
        default = "";
      };
      memoryMax = lib.mkOption {
        type = lib.types.str;
        description = "The max memory for ${instanceName}";
        default = "1G";
      };
      cpuQuota = lib.mkOption {
        type = lib.types.str;
        description = "The CPU quota for ${instanceName}";
        default = "200%";
      };
      tasksMax = lib.mkOption {
        type = lib.types.int;
        description = "The maximum number of tasks for ${instanceName}";
        default = 100;
      };
      restrictAddressFamilies = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "The address families to restrict for ${instanceName}";
        default = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
      };
      packages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        description = "Additional packages for ${instanceName}";
        default = with pkgs; [ nix ];
      };
    };

    mkGeminiOptions = {
      instanceName,
        defaultUserName ? instanceName,
        defaultDescription ? "Gemini agent (${instanceName})",
        defaultHome ? "${cfg.workspaceBase}/${instanceName}",
        defaultUid,
        defaultEnvironmentFiles ? [  ],
    }: {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the Gemini ${instanceName} agent";
      };
      name = lib.mkOption {
        type = lib.types.str;
        description = "The name of the Gemini ${instanceName} user";
        default = defaultUserName;
      };
      description = lib.mkOption {
        type = lib.types.str;
        description = "The description of the Gemini ${instanceName} agent";
        default = defaultDescription;
      };
      home = lib.mkOption {
        type = lib.types.path;
        description = "The home folder of the Gemini ${instanceName} user";
        default = defaultHome;
      };
      uid = lib.mkOption {
        type = lib.types.int;
        description = "The UID  of the Gemini ${instanceName} user";
        default = defaultUid;
      };
      shell = lib.mkOption {
        type = lib.types.attrs;
        description = "The shell of the Gemini ${instanceName} user";
        default = pkgs.bash;
      };
      command = lib.mkOption {
        type = lib.types.str;
        description = "The command to run Gemini ${instanceName}";
        default = "${pkgs.gemini-cli}/bin/gemini --";
      };
      environmentFiles = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        description = "Environment files for ${instanceName}";
        default = defaultEnvironmentFiles;
      };
      protectHome = lib.mkOption {
        type = lib.types.bool;
        description = "Whether to protect the home folder of ${instanceName}";
        default = true;
      };
      protectSystem = lib.mkOption {
        type = lib.types.str;
        description = "System protection strategy for ${instanceName}";
        default = "strict";
      };
      readWritePaths = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Paths with read and write permissions for ${instanceName} ";
        default = [
          defaultHome
          "/nix/var/nix"
          "${cfg.workspaceBase}/shared"
        ];
      };
      readOnlyPaths = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Paths with read-only permissions for ${instanceName}";
        default = [ "/nix/store" ];
      };
      privateTmp = lib.mkOption {
        type = lib.types.bool;
        description = "Whether TMP is private for ${instanceName}";
        default = true;
      };
      noNewPrivileges = lib.mkOption {
        type = lib.types.bool;
        description = "Prevent new privileges for ${instanceName}";
        default = false;
      };
      capabilityBoundingSet = lib.mkOption {
        type = lib.types.str;
        description = "The capability bounding set for ${instanceName}";
        default = "";
      };
      memoryMax = lib.mkOption {
        type = lib.types.str;
        description = "The max memory for ${instanceName}";
        default = "1G";
      };
      cpuQuota = lib.mkOption {
        type = lib.types.str;
        description = "The CPU quota for ${instanceName}";
        default = "200%";
      };
      tasksMax = lib.mkOption {
        type = lib.types.int;
        description = "The maximum number of tasks for ${instanceName}";
        default = 100;
      };
      restrictAddressFamilies = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "The address families to restrict for ${instanceName}";
        default = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
      };
      packages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        description = "Additional packages for ${instanceName}";
        default = with pkgs; [ gemini-cli nix ];
      };
    };

    mkPiOptions = {
      instanceName,
        defaultUserName ? instanceName,
        defaultDescription ? "Pi agent (${instanceName})",
        defaultHome ? "${cfg.workspaceBase}/${instanceName}",
        defaultUid,
        defaultEnvironmentFiles ? [  ],
    }: {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the Pi ${instanceName} agent";
      };
      name = lib.mkOption {
        type = lib.types.str;
        description = "The name of the Pi ${instanceName} user";
        default = defaultUserName;
      };
      description = lib.mkOption {
        type = lib.types.str;
        description = "The description of the Pi ${instanceName} agent";
        default = defaultDescription;
      };
      version = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Version/commit of PI (e.g. '0.70.2' or '422d139')";
        example = "0.70.2";
      };
      home = lib.mkOption {
        type = lib.types.path;
        description = "The home folder of the Pi ${instanceName} user";
        default = defaultHome;
      };
      uid = lib.mkOption {
        type = lib.types.int;
        description = "The UID of the Pi ${instanceName} user";
        default = defaultUid;
      };
      shell = lib.mkOption {
        type = lib.types.attrs;
        description = "The shell of the Pi ${instanceName} user";
        default = pkgs.bash;
      };
      command = lib.mkOption {
        type = lib.types.str;
        description = "The command to run Pi ${instanceName} ";
        default = let
          instanceCfg = cfg.${instanceName};
          ref = lib.optionalString (instanceCfg.version != null)
            "/${instanceCfg.version}";
        in "${pkgs.nix}/bin/nix --extra-experimental-features 'nix-command flakes' run --refresh github:lukasl-dev/pi-mono.nix${ref} --";
      };
      environmentFiles = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        description = "Environment files for ${instanceName}";
        default = defaultEnvironmentFiles;
      };
      protectHome = lib.mkOption {
        type = lib.types.bool;
        description = "Whether to protect the home folder of ${instanceName}";
        default = true;
      };
      protectSystem = lib.mkOption {
        type = lib.types.str;
        description = "System protection strategy for ${instanceName}";
        default = "strict";
      };
      readWritePaths = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Paths with read and write permissions of ${instanceName}";
        default = [
          defaultHome
          "/nix/var/nix"
          "${cfg.workspaceBase}/shared"
        ];
      };
      readOnlyPaths = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Paths with read-only permissions for ${instanceName}";
        default = [ "/nix/store" ];
      };
      privateTmp = lib.mkOption {
        type = lib.types.bool;
        description = "Whether TMP is private for ${instanceName}";
        default = true;
      };
      noNewPrivileges = lib.mkOption {
        type = lib.types.bool;
        description = "Prevent new privileges for ${instanceName}";
        default = false;
      };
      capabilityBoundingSet = lib.mkOption {
        type = lib.types.str;
        description = "The capability bounding set for ${instanceName}";
        default = "";
      };
      memoryMax = lib.mkOption {
        type = lib.types.str;
        description = "The max memory for ${instanceName}";
        default = "1G";
      };
      cpuQuota = lib.mkOption {
        type = lib.types.str;
        description = "The CPU quota for ${instanceName}";
        default = "200%";
      };
      tasksMax = lib.mkOption {
        type = lib.types.int;
        description = "The maximum number of tasks for ${instanceName}";
        default = 100;
      };
      restrictAddressFamilies = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "The address families to restrict for ${instanceName}";
        default = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
      };
      packages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        description = "Additional packages for ${instanceName}";
        default = with pkgs; [ nix ];
      };
    };

    mkHermesOptions = {
      instanceName,       # e.g. "hermes-pc", "hermes-personal"
        defaultUserName ? instanceName,
        defaultDescription ? "Hermes agent (${instanceName})",
        defaultHome ? "${cfg.workspaceBase}/${instanceName}",
        defaultUid,
        defaultEnvironmentFiles ? [  ],
    }: {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the ${instanceName} agent";
      };
      name = lib.mkOption {
        type = lib.types.str;
        description = "The name of the ${instanceName} user";
        default = defaultUserName;
      };
      description = lib.mkOption {
        type = lib.types.str;
        description = "The description of the ${instanceName} agent";
        default = defaultDescription;
      };
      version = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description =
          "Version/commit of hermes-agent to use for ${instanceName} (e.g. 'hermes/hermes-46839e2f' or 'v2026.4.23')";
        example = "v2026.4.23";
      };
      home = lib.mkOption {
        type = lib.types.path;
        description = "The home folder of the ${instanceName} user";
        default = defaultHome;
      };
      uid = lib.mkOption {
        type = lib.types.int;
        description = "The UID of the ${instanceName} user";
        default = defaultUid;
      };
      shell = lib.mkOption {
        type = lib.types.attrs;
        description = "The shell of the ${instanceName} user";
        default = pkgs.bash;
      };
      command = lib.mkOption {
        type = lib.types.str;
        description = "The command to run ${instanceName}";
        default = let
          instanceCfg = cfg.${instanceName};
          ref = lib.optionalString (instanceCfg.version != null)
            "/${instanceCfg.version}";
        in "${pkgs.nix}/bin/nix --extra-experimental-features 'nix-command flakes' run --refresh github:NousResearch/hermes-agent${ref} --";
      };
      environmentFiles = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        description = "Environment files for ${instanceName}";
        default = defaultEnvironmentFiles;
      };
      protectHome = lib.mkOption {
        type = lib.types.bool;
        description = "Whether to protect the home folder for ${instanceName}";
        default = true;
      };
      protectSystem = lib.mkOption {
        type = lib.types.str;
        description = "System protection strategy for ${instanceName}";
        default = "strict";
      };
      readWritePaths = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Paths with read and write permissions for ${instanceName}";
        default = [
          defaultHome
          "/nix/var/nix"
          "${cfg.workspaceBase}/shared"
        ];
      };
      readOnlyPaths = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Paths with read-only permissions for ${instanceName}";
        default = [ "/nix/store" ];
      };
      privateTmp = lib.mkOption {
        type = lib.types.bool;
        description = "Whether TMP is private for ${instanceName}";
        default = true;
      };
      noNewPrivileges = lib.mkOption {
        type = lib.types.bool;
        description = "Prevent new privileges for ${instanceName}";
        default = false;
      };
      capabilityBoundingSet = lib.mkOption {
        type = lib.types.str;
        description = "The capability bounding set for ${instanceName}";
        default = "";
      };
      memoryMax = lib.mkOption {
        type = lib.types.str;
        description = "The max memory for ${instanceName}";
        default = "1G";
      };
      cpuQuota = lib.mkOption {
        type = lib.types.str;
        description = "The CPU quota for ${instanceName}";
        default = "200%";
      };
      tasksMax = lib.mkOption {
        type = lib.types.int;
        description = "The maximum number of tasks for ${instanceName}";
        default = 100;
      };
      restrictAddressFamilies = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "The address families to restrict for ${instanceName}";
        default = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
      };
      packages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        description = "Additional packages for ${instanceName}";
        default = with pkgs; [ himalaya nix ];
      };
    };
in rec {
  options.agents = {

    workspaceBase = lib.mkOption {
      type = lib.types.path;
      default = "/srv/agent-workspaces";
      description = "Base directory for agent workspaces";
    };

    commonGroup = lib.mkOption {
      type = lib.types.str;
      default = "agents";
      description = "Base group for agents";
    };

    claudeCode = mkClaudeCodeOptions {
      instanceName = "claudeCode";
      defaultUserName = "claudeCode";
      defaultUid = 5001;
    };

    codex = mkCodexOptions {
      instanceName = "codex";
      defaultUserName = "codex";
      defaultUid = 5002;
    };

    gemini = mkGeminiOptions {
      instanceName = "gemini";
      defaultUserName = "gemini";
      defaultUid = 5003;
    };

    piWork = mkPiOptions {
      instanceName = "piWork";
      defaultUserName = "piWork";
      defaultUid = 5004;
    };

    piDryWit = mkPiOptions {
      instanceName = "piDryWit";
      defaultUserName = "piDryWit";
      defaultUid = 5006;
    };

    piPythonEda = mkPiOptions {
      instanceName = "piPythonEda";
      defaultUserName = "piPythonEda";
      defaultUid = 5009;
    };

    piJavaEda = mkPiOptions {
      instanceName = "piJavaEda";
      defaultUserName = "piJavaEda";
      defaultUid = 5007;
    };

    hermesPc = mkHermesOptions {
      instanceName = "hermesPc";
      defaultUserName = "hermes-pc";
      defaultHome = "${cfg.workspaceBase}/hermes-pc";
      defaultUid = 5005;
    };

    hermesPersonal = mkHermesOptions {
      instanceName = "hermesPersonal";
      defaultUserName = "hermes-personal";
      defaultHome = "${cfg.workspaceBase}/hermes-personal";
      defaultUid = 5008;
    };

    freeClaudeCode = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the Free Claude Code";
      };
      port = lib.mkOption {
        type = lib.types.port;
        default = 7070;
        description = "Port for free-claude-code proxy";
      };

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "Host for free-claude-code proxy";
      };

      path = lib.mkOption {
        type = lib.types.path;
        default = "${cfg.workspaceBase}/claude/free-claude-code";
        description = "free-claude-code path";
      };

      uvCachePath = lib.mkOption {
        type = lib.types.path;
        default = "${cfg.workspaceBase}/claude/.cache/uv";
        description = "UV cache dir";
      };

      anthropicAuthToken = lib.mkOption {
        type = lib.types.str;
        default =
          "8SU/Y90FgCJ/uKqZv3yG01mCr8e0WsSqWRPwBsDN/k3b/525YdM/yvhc8BtP";
        description =
          "Custom auth token for Anthropic (to make free-claude-code private)";
      };
    };

    proxy = {
      port = lib.mkOption {
        type = lib.types.port;
        default = 3128;
        description = "Squid proxy port";
      };
    };

    firewall = {
      llmDomains = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          # ── Claude Code (Anthropic) ──
          "api.anthropic.com"
          "statsig.anthropic.com"
          "sentry.io"

          # ── OpenRouter ──
          "openrouter.ai"
          "api.openrouter.ai"

          # ── OpenAI / ChatGPT / Codex ──
          "api.openai.com"
          "cdn.openai.com"
          "chatgpt.com"
          "ab.chatgpt.com"
          "files.oaiusercontent.com"
          "openaipublic.blob.core.windows.net"
          "developers.openai.com"

          # ── npm (needed for codex/node tools) ──
          "registry.npmjs.org"

          # ── GitHub (git + API + downloads) ──
          "github.com"
          "api.github.com"
          "raw.githubusercontent.com"
          "objects.githubusercontent.com"
          "codeload.github.com"

          # ── Gemini / Google AI ──
          "generativelanguage.googleapis.com" # Gemini API
          "aiplatform.googleapis.com" # Vertex AI
          "oauth2.googleapis.com" # auth
          "accounts.google.com" # auth
          "www.googleapis.com" # general Google API
          "storage.googleapis.com" # model artifacts
          "aistudio.google.com" # AI Studio web

          # ── Common dependencies ──
          "github.com" # git operations
          "api.github.com" # GitHub API
          "raw.githubusercontent.com" # raw file fetches
          "objects.githubusercontent.com" # git LFS / releases
          "nixos.org" # nix run needs this
          "cache.nixos.org" # nix binary cache
          "channels.nixos.org"

          # -- TTS --
          "speech.platform.bing.com"
        ];
        description = "API backends (always allowed, needed for LLM calls)";
      };

      privateDomains = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "localhost"
          "maven.colordigital.cloud"
          "artifacts.colordigital.cloud"
          "nexus-docker.colordigital.cloud"
          "gitlab.colordigital.cloud"
          "dev.dmix.cloud"
          "auth-dev.dmix.cloud"
          "dev2.dmix.cloud"
          "auth2-dev.dmix.cloud"
          "int.dmix.cloud"
          "auth-int.dmix.cloud"
          "docs.rs"
          "doc.rust-lang.org"
          "developer.mozilla.org"
          "github.com"
          "stackoverflow.com"
          "nixos.org"
          "wiki.nixos.org"
          "man7.org"
        ];
        description = "Private domains";
      };
    };
  };
}

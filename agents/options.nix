# agents/options.nix
{ pkgs, lib, config, ... }:
let cfg = config.agents;
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

    claude = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the Claude agent";
      };
      name = lib.mkOption {
        type = lib.types.str;
        description = "The name of the Claude user";
        default = "claude";
      };
      description = lib.mkOption {
        type = lib.types.str;
        description = "The description of the Claude user";
        default = "Claude Code agent";
      };
      home = lib.mkOption {
        type = lib.types.path;
        description = "The home folder of the Claude user";
        default = "${cfg.workspaceBase}/claude";
      };
      uid = lib.mkOption {
        type = lib.types.int;
        description = "The UID of the Claude user";
        default = 5001;
      };
      shell = lib.mkOption {
        type = lib.types.attrs;
        description = "The shell of the Claude user";
        default = pkgs.bash;
      };
      command = lib.mkOption {
        type = lib.types.str;
        description = "The command to run Claude Code";
        default =
          "${pkgs.nix}/bin/nix --extra-experimental-features 'nix-command flakes' run --refresh github:sadjow/claude-code-nix --";
      };
      environmentFiles = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        description = "Environment files";
        default = [ ];
      };
      protectHome = lib.mkOption {
        type = lib.types.bool;
        description = "Whether to protect the home folder";
        default = true;
      };
      protectSystem = lib.mkOption {
        type = lib.types.str;
        description = "System protection strategy";
        default = "strict";
      };
      readWritePaths = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Paths with read and write permissions";
        default = [
          "${cfg.workspaceBase}/claude"
          "/nix/var/nix"
          "${cfg.workspaceBase}/shared"
        ];
      };
      readOnlyPaths = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Paths with read-only permissions";
        default = [ "/nix/store" ];
      };
      privateTmp = lib.mkOption {
        type = lib.types.bool;
        description = "Whether TMP is private";
        default = true;
      };
      noNewPrivileges = lib.mkOption {
        type = lib.types.bool;
        description = "Prevent new privileges";
        default = false;
      };
      capabilityBoundingSet = lib.mkOption {
        type = lib.types.str;
        description = "The capability bounding set";
        default = "";
      };
      memoryMax = lib.mkOption {
        type = lib.types.str;
        description = "The max memory";
        default = "1G";
      };
      cpuQuota = lib.mkOption {
        type = lib.types.str;
        description = "The CPU quota";
        default = "200%";
      };
      tasksMax = lib.mkOption {
        type = lib.types.int;
        description = "The maximum number of tasks";
        default = 100;
      };
      restrictAddressFamilies = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "The address families to restrict";
        default = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
      };
      packages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        description = "Additional packages";
        default = with pkgs; [ nix ];
      };
    };

    codex = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the Codex agent";
      };
      name = lib.mkOption {
        type = lib.types.str;
        description = "The name of the Codex user";
        default = "codex";
      };
      description = lib.mkOption {
        type = lib.types.str;
        description = "The description of the Codex agent";
        default = "Codex agent";
      };
      home = lib.mkOption {
        type = lib.types.path;
        description = "The home folder of the Codex user";
        default = "${cfg.workspaceBase}/codex";
      };
      uid = lib.mkOption {
        type = lib.types.int;
        description = "The UID of the Codex user";
        default = 5002;
      };
      shell = lib.mkOption {
        type = lib.types.attrs;
        description = "The shell of the Codex user";
        default = pkgs.bash;
      };
      command = lib.mkOption {
        type = lib.types.str;
        description = "The command to run Codex";
        default =
          "${pkgs.nix}/bin/nix --extra-experimental-features 'nix-command flakes' run --refresh github:sadjow/codex-cli-nix --";
      };
      environmentFiles = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        description = "Environment files";
        default = [ ];
      };
      protectHome = lib.mkOption {
        type = lib.types.bool;
        description = "Whether to protect the home folder";
        default = true;
      };
      protectSystem = lib.mkOption {
        type = lib.types.str;
        description = "System protection strategy";
        default = "strict";
      };
      readWritePaths = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Paths with read and write permissions";
        default = [
          "${cfg.workspaceBase}/codex"
          "/nix/var/nix"
          "${cfg.workspaceBase}/shared"
        ];
      };
      readOnlyPaths = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Paths with read-only permissions";
        default = [ "/nix/store" ];
      };
      privateTmp = lib.mkOption {
        type = lib.types.bool;
        description = "Whether TMP is private";
        default = true;
      };
      noNewPrivileges = lib.mkOption {
        type = lib.types.bool;
        description = "Prevent new privileges";
        default = false;
      };
      capabilityBoundingSet = lib.mkOption {
        type = lib.types.str;
        description = "The capability bounding set";
        default = "";
      };
      memoryMax = lib.mkOption {
        type = lib.types.str;
        description = "The max memory";
        default = "1G";
      };
      cpuQuota = lib.mkOption {
        type = lib.types.str;
        description = "The CPU quota";
        default = "200%";
      };
      tasksMax = lib.mkOption {
        type = lib.types.int;
        description = "The maximum number of tasks";
        default = 100;
      };
      restrictAddressFamilies = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "The address families to restrict";
        default = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
      };
      packages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        description = "Additional packages";
        default = with pkgs; [ nix ];
      };
    };

    gemini = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the Gemini agent";
      };
      name = lib.mkOption {
        type = lib.types.str;
        description = "The name of the Gemini user";
        default = "gemini";
      };
      description = lib.mkOption {
        type = lib.types.str;
        description = "The description of the Gemini agent";
        default = "Gemini agent";
      };
      home = lib.mkOption {
        type = lib.types.path;
        description = "The home folder of the Gemini user";
        default = "${cfg.workspaceBase}/gemini";
      };
      uid = lib.mkOption {
        type = lib.types.int;
        description = "The UID  of the Gemini user";
        default = 5003;
      };
      shell = lib.mkOption {
        type = lib.types.attrs;
        description = "The shell of the Gemini user";
        default = pkgs.bash;
      };
      command = lib.mkOption {
        type = lib.types.str;
        description = "The command to run Gemini";
        default = "${pkgs.gemini-cli}/bin/gemini-cli --";
      };
      environmentFiles = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        description = "Environment files";
        default = [ ];
      };
      protectHome = lib.mkOption {
        type = lib.types.bool;
        description = "Whether to protect the home folder";
        default = true;
      };
      protectSystem = lib.mkOption {
        type = lib.types.str;
        description = "System protection strategy";
        default = "strict";
      };
      readWritePaths = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Paths with read and write permissions";
        default = [
          "${cfg.workspaceBase}/gemini"
          "/nix/var/nix"
          "${cfg.workspaceBase}/shared"
        ];
      };
      readOnlyPaths = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Paths with read-only permissions";
        default = [ "/nix/store" ];
      };
      privateTmp = lib.mkOption {
        type = lib.types.bool;
        description = "Whether TMP is private";
        default = true;
      };
      noNewPrivileges = lib.mkOption {
        type = lib.types.bool;
        description = "Prevent new privileges";
        default = false;
      };
      capabilityBoundingSet = lib.mkOption {
        type = lib.types.str;
        description = "The capability bounding set";
        default = "";
      };
      memoryMax = lib.mkOption {
        type = lib.types.str;
        description = "The max memory";
        default = "1G";
      };
      cpuQuota = lib.mkOption {
        type = lib.types.str;
        description = "The CPU quota";
        default = "200%";
      };
      tasksMax = lib.mkOption {
        type = lib.types.int;
        description = "The maximum number of tasks";
        default = 100;
      };
      restrictAddressFamilies = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "The address families to restrict";
        default = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
      };
      packages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        description = "Additional packages";
        default = with pkgs; [ gemini-cli nix ];
      };
    };

    pi = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the Pi agent";
      };
      name = lib.mkOption {
        type = lib.types.str;
        description = "The name of the Pi user";
        default = "pi";
      };
      description = lib.mkOption {
        type = lib.types.str;
        description = "The description of the Pi agent";
        default = "Pi agent";
      };
      home = lib.mkOption {
        type = lib.types.path;
        description = "The home folder of the Pi user";
        default = "${cfg.workspaceBase}/pi";
      };
      uid = lib.mkOption {
        type = lib.types.int;
        description = "The UID of the Pi user";
        default = 5004;
      };
      shell = lib.mkOption {
        type = lib.types.attrs;
        description = "The shell of the Pi user";
        default = pkgs.bash;
      };
      command = lib.mkOption {
        type = lib.types.str;
        description = "The command to run Pi";
        default =
          "${pkgs.nix}/bin/nix --extra-experimental-features 'nix-command flakes' run --refresh github:lukasl-dev/pi-mono.nix --";
      };
      environmentFiles = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        description = "Environment files";
        default = [ ];
      };
      protectHome = lib.mkOption {
        type = lib.types.bool;
        description = "Whether to protect the home folder";
        default = true;
      };
      protectSystem = lib.mkOption {
        type = lib.types.str;
        description = "System protection strategy";
        default = "strict";
      };
      readWritePaths = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Paths with read and write permissions";
        default = [
          "${cfg.workspaceBase}/pi"
          "/nix/var/nix"
          "${cfg.workspaceBase}/shared"
        ];
      };
      readOnlyPaths = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Paths with read-only permissions";
        default = [ "/nix/store" ];
      };
      privateTmp = lib.mkOption {
        type = lib.types.bool;
        description = "Whether TMP is private";
        default = true;
      };
      noNewPrivileges = lib.mkOption {
        type = lib.types.bool;
        description = "Prevent new privileges";
        default = false;
      };
      capabilityBoundingSet = lib.mkOption {
        type = lib.types.str;
        description = "The capability bounding set";
        default = "";
      };
      memoryMax = lib.mkOption {
        type = lib.types.str;
        description = "The max memory";
        default = "1G";
      };
      cpuQuota = lib.mkOption {
        type = lib.types.str;
        description = "The CPU quota";
        default = "200%";
      };
      tasksMax = lib.mkOption {
        type = lib.types.int;
        description = "The maximum number of tasks";
        default = 100;
      };
      restrictAddressFamilies = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "The address families to restrict";
        default = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
      };
      packages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        description = "Additional packages";
        default = with pkgs; [ nix ];
      };
    };

    hermes = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the Hermes agent";
      };
      name = lib.mkOption {
        type = lib.types.str;
        description = "The name of the Hermes user";
        default = "hermes";
      };
      description = lib.mkOption {
        type = lib.types.str;
        description = "The description of the Hermes agent";
        default = "Hermes agent";
      };
      home = lib.mkOption {
        type = lib.types.path;
        description = "The home folder of the Hermes user";
        default = "${cfg.workspaceBase}/hermes";
      };
      uid = lib.mkOption {
        type = lib.types.int;
        description = "The UID of the Hermes user";
        default = 5005;
      };
      shell = lib.mkOption {
        type = lib.types.attrs;
        description = "The shell of the Hermes user";
        default = pkgs.bash;
      };
      command = lib.mkOption {
        type = lib.types.str;
        description = "The command to run Hermes";
        default =
          "${pkgs.nix}/bin/nix --extra-experimental-features 'nix-command flakes' run --refresh github:NousResearch/hermes-agent --";
      };
      environmentFiles = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        description = "Environment files";
        default = [ ];
      };
      protectHome = lib.mkOption {
        type = lib.types.bool;
        description = "Whether to protect the home folder";
        default = true;
      };
      protectSystem = lib.mkOption {
        type = lib.types.str;
        description = "System protection strategy";
        default = "strict";
      };
      readWritePaths = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Paths with read and write permissions";
        default = [
          "${cfg.workspaceBase}/hermes"
          "/nix/var/nix"
          "${cfg.workspaceBase}/shared"
        ];
      };
      readOnlyPaths = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Paths with read-only permissions";
        default = [ "/nix/store" ];
      };
      privateTmp = lib.mkOption {
        type = lib.types.bool;
        description = "Whether TMP is private";
        default = true;
      };
      noNewPrivileges = lib.mkOption {
        type = lib.types.bool;
        description = "Prevent new privileges";
        default = false;
      };
      capabilityBoundingSet = lib.mkOption {
        type = lib.types.str;
        description = "The capability bounding set";
        default = "";
      };
      memoryMax = lib.mkOption {
        type = lib.types.str;
        description = "The max memory";
        default = "1G";
      };
      cpuQuota = lib.mkOption {
        type = lib.types.str;
        description = "The CPU quota";
        default = "200%";
      };
      tasksMax = lib.mkOption {
        type = lib.types.int;
        description = "The maximum number of tasks";
        default = 100;
      };
      restrictAddressFamilies = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "The address families to restrict";
        default = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
      };
      packages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        description = "Additional packages";
        default = with pkgs; [ himalaya nix ];
      };
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

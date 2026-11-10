# agents/options.nix
{ pkgs, lib, config, ... }:
let
  cfg = config.agents;
  mkClaudeCodeOptions = { instanceName, userName ? instanceName
    , description ? "Claude Code agent (${instanceName})"
    , home ? "${cfg.workspaceBase}/${instanceName}", uid, environmentFiles ? [ ]
    , }: {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the Claude Code ${instanceName} agent";
      };
      name = lib.mkOption {
        type = lib.types.str;
        description = "The name of the ${instanceName} user";
        default = userName;
      };
      description = lib.mkOption {
        type = lib.types.str;
        description = "The description of the ${instanceName} user";
        default = description;
      };
      version = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description =
          "Version/commit of Claude Code (e.g. '2.1.120' or '002de6e')";
        example = "2.1.120";
      };
      skipApprovals = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to skip approvals";
      };
      skipApprovalsFlag = lib.mkOption {
        type = lib.types.str;
        default = "--dangerously-skip-permissions";
        description = "CLI Flag to skip approvals";
      };
      useFreeClaudeCode = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to use the free-claude-code proxy";
      };
      customChangeDirFlag = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "CLI flag to start in a different directory";
      };
      home = lib.mkOption {
        type = lib.types.path;
        description = "The home folder of the ${instanceName} user";
        default = home;
      };
      uid = lib.mkOption {
        type = lib.types.int;
        description = "The UID of the ${instanceName} user";
        default = uid;
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
        in "${pkgs.nix}/bin/nix --extra-experimental-features 'nix-command flakes' run github:sadjow/claude-code-nix${ref}";
      };
      environmentFiles = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        description = "Environment files for ${instanceName}";
        default = environmentFiles;
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
        description =
          "Paths with read and write permissions for ${instanceName}";
        default = [ home "/nix/var/nix" "${cfg.workspaceBase}/shared" ];
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
        default = "4G";
      };
      cpuQuota = lib.mkOption {
        type = lib.types.str;
        description = "The CPU quota for ${instanceName}";
        default = "200%";
      };
      tasksMax = lib.mkOption {
        type = lib.types.int;
        description = "The maximum number of tasks for ${instanceName}";
        default = 1000;
      };
      restrictAddressFamilies = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "The address families to restrict for ${instanceName}";
        default = [ "AF_INET" "AF_INET6" "AF_UNIX" "AF_NETLINK" ];
      };
      packages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        description = "Additional packages for ${instanceName}";
        default = with pkgs; [ nix ];
      };
    };

  mkCodexOptions = { instanceName, userName ? instanceName
    , description ? "Codex agent (${instanceName})"
    , home ? "${cfg.workspaceBase}/${instanceName}", uid, environmentFiles ? [ ]
    , }: {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the Codex ${instanceName} agent";
      };
      name = lib.mkOption {
        type = lib.types.str;
        description = "The name of the Codex ${instanceName} user";
        default = userName;
      };
      description = lib.mkOption {
        type = lib.types.str;
        description = "The description of the Codex ${instanceName} agent";
        default = description;
      };
      version = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Version/commit of Codex (e.g. '0.125.0' or 'fc382be')";
        example = "0.125.0";
      };
      skipApprovals = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to skip approvals";
      };
      skipApprovalsFlag = lib.mkOption {
        type = lib.types.str;
        default = "--dangerously-bypass-approvals-and-sandbox";
        description = "CLI Flag to skip approvals";
      };
      useFreeClaudeCode = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to use free-claude-code";
      };
      customChangeDirFlag = lib.mkOption {
        type = lib.types.str;
        default = "--cd";
        description = "CLI flag to start in a different directory";
      };
      home = lib.mkOption {
        type = lib.types.path;
        description = "The home folder of the Codex ${instanceName} user";
        default = home;
      };
      uid = lib.mkOption {
        type = lib.types.int;
        description = "The UID of the Codex ${instanceName} user";
        default = uid;
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
        in "${pkgs.nix}/bin/nix --extra-experimental-features 'nix-command flakes' run github:sadjow/codex-cli-nix${ref}";
      };
      environmentFiles = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        description = "Environment files for ${instanceName}";
        default = environmentFiles;
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
        description =
          "Paths with read and write permissions for ${instanceName}";
        default = [ home "/nix/var/nix" "${cfg.workspaceBase}/shared" ];
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
        default = "4G";
      };
      cpuQuota = lib.mkOption {
        type = lib.types.str;
        description = "The CPU quota for ${instanceName}";
        default = "200%";
      };
      tasksMax = lib.mkOption {
        type = lib.types.int;
        description = "The maximum number of tasks for ${instanceName}";
        default = 1000;
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

  mkPiOptions = { instanceName, userName ? instanceName
    , description ? "Pi agent (${instanceName})"
    , home ? "${cfg.workspaceBase}/${instanceName}", uid, environmentFiles ? [ ]
    , }: {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the Pi ${instanceName} agent";
      };
      name = lib.mkOption {
        type = lib.types.str;
        description = "The name of the Pi ${instanceName} user";
        default = userName;
      };
      description = lib.mkOption {
        type = lib.types.str;
        description = "The description of the Pi ${instanceName} agent";
        default = description;
      };
      version = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Version/commit of PI (e.g. '0.70.2' or '422d139')";
        example = "0.70.2";
      };
      skipApprovals = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to skip approvals";
      };
      skipApprovalsFlag = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "CLI Flag to skip approvals (non-existing)";
      };
      useFreeClaudeCode = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to use the free-claude-code proxy";
      };
      customChangeDirFlag = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "CLI flag to start in a different directory";
      };
      home = lib.mkOption {
        type = lib.types.path;
        description = "The home folder of the Pi ${instanceName} user";
        default = home;
      };
      uid = lib.mkOption {
        type = lib.types.int;
        description = "The UID of the Pi ${instanceName} user";
        default = uid;
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
        in "${pkgs.nix}/bin/nix --extra-experimental-features 'nix-command flakes' run github:lukasl-dev/pi-mono.nix${ref}";
      };
      environmentFiles = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        description = "Environment files for ${instanceName}";
        default = environmentFiles;
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
        description =
          "Paths with read and write permissions of ${instanceName}";
        default = [ home "/nix/var/nix" "${cfg.workspaceBase}/shared" ];
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
        default = "4G";
      };
      cpuQuota = lib.mkOption {
        type = lib.types.str;
        description = "The CPU quota for ${instanceName}";
        default = "200%";
      };
      tasksMax = lib.mkOption {
        type = lib.types.int;
        description = "The maximum number of tasks for ${instanceName}";
        default = 1000;
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

  mkHermesOptions = { instanceName, # e.g. "hermes-pc", "hermes-personal"
    userName ? instanceName, description ? "Hermes agent (${instanceName})"
    , home ? "${cfg.workspaceBase}/${instanceName}", uid, environmentFiles ? [ ]
    , }: {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the ${instanceName} agent";
      };
      name = lib.mkOption {
        type = lib.types.str;
        description = "The name of the ${instanceName} user";
        default = userName;
      };
      description = lib.mkOption {
        type = lib.types.str;
        description = "The description of the ${instanceName} agent";
        default = description;
      };
      version = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description =
          "Version/commit of hermes-agent to use for ${instanceName} (e.g. 'hermes/hermes-46839e2f' or 'v2026.4.23')";
        example = "v2026.4.23";
      };
      skipApprovals = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to skip approvals";
      };
      skipApprovalsFlag = lib.mkOption {
        type = lib.types.str;
        default = "--yolo";
        description = "CLI Flag to skip approvals";
      };
      useFreeClaudeCode = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to use the free-claude-code proxy";
      };
      customChangeDirFlag = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "CLI flag to start in a different directory";
      };
      home = lib.mkOption {
        type = lib.types.path;
        description = "The home folder of the ${instanceName} user";
        default = home;
      };
      uid = lib.mkOption {
        type = lib.types.int;
        description = "The UID of the ${instanceName} user";
        default = uid;
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
        in "${pkgs.nix}/bin/nix --extra-experimental-features 'nix-command flakes' run github:NousResearch/hermes-agent${ref}";
      };
      environmentFiles = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        description = "Environment files for ${instanceName}";
        default = environmentFiles;
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
        description =
          "Paths with read and write permissions for ${instanceName}";
        default = [ home "/nix/var/nix" "${cfg.workspaceBase}/shared" ];
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
        default = "4G";
      };
      cpuQuota = lib.mkOption {
        type = lib.types.str;
        description = "The CPU quota for ${instanceName}";
        default = "200%";
      };
      tasksMax = lib.mkOption {
        type = lib.types.int;
        description = "The maximum number of tasks for ${instanceName}";
        default = 1000;
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

  mkDeepseekOptions = { instanceName, userName ? instanceName
    , description ? "Deepseek (${instanceName})"
    , home ? "${cfg.workspaceBase}/${instanceName}", uid, environmentFiles ? [ ]
    , }: {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the ${instanceName} agent";
      };
      name = lib.mkOption {
        type = lib.types.str;
        description = "The name of the ${instanceName} user";
        default = userName;
      };
      description = lib.mkOption {
        type = lib.types.str;
        description = "The description of the ${instanceName} agent";
        default = description;
      };
      version = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description =
          "Version/commit of deepseek harness to use for ${instanceName}";
        example = "0.1.0-rc.7";
      };
      skipApprovals = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to skip approvals";
      };
      skipApprovalsFlag = lib.mkOption {
        type = lib.types.str;
        default = "--yolo";
        description = "CLI Flag to skip approvals";
      };
      useFreeClaudeCode = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to use the free-claude-code proxy";
      };
      customChangeDirFlag = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "CLI flag to start in a different directory";
      };
      home = lib.mkOption {
        type = lib.types.path;
        description = "The home folder of the ${instanceName} user";
        default = home;
      };
      uid = lib.mkOption {
        type = lib.types.int;
        description = "The UID of the ${instanceName} user";
        default = uid;
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
        in "${pkgs.nix}/bin/nix --extra-experimental-features 'nix-command flakes' run github:numtide/llm-agents.nix#dsh${ref}";
      };
      environmentFiles = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        description = "Environment files for ${instanceName}";
        default = environmentFiles;
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
        description =
          "Paths with read and write permissions for ${instanceName}";
        default = [ home "/nix/var/nix" "${cfg.workspaceBase}/shared" ];
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
        default = "4G";
      };
      cpuQuota = lib.mkOption {
        type = lib.types.str;
        description = "The CPU quota for ${instanceName}";
        default = "200%";
      };
      tasksMax = lib.mkOption {
        type = lib.types.int;
        description = "The maximum number of tasks for ${instanceName}";
        default = 1000;
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

  mkJulesOptions = { instanceName, userName ? instanceName
    , description ? "Jules (${instanceName})"
    , home ? "${cfg.workspaceBase}/${instanceName}", uid, environmentFiles ? [ ]
    , }: {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the ${instanceName} agent";
      };
      name = lib.mkOption {
        type = lib.types.str;
        description = "The name of the ${instanceName} user";
        default = userName;
      };
      description = lib.mkOption {
        type = lib.types.str;
        description = "The description of the ${instanceName} agent";
        default = description;
      };
      version = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description =
          "Version/commit of jules harness to use for ${instanceName}";
        example = "0.1.0-rc.7";
      };
      skipApprovals = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to skip approvals";
      };
      skipApprovalsFlag = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "CLI Flag to skip approvals";
      };
      useFreeClaudeCode = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to use the free-claude-code proxy";
      };
      customChangeDirFlag = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "CLI flag to start in a different directory";
      };
      home = lib.mkOption {
        type = lib.types.path;
        description = "The home folder of the ${instanceName} user";
        default = home;
      };
      uid = lib.mkOption {
        type = lib.types.int;
        description = "The UID of the ${instanceName} user";
        default = uid;
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
        in "${pkgs.nix}/bin/nix --extra-experimental-features 'nix-command flakes' run github:numtide/llm-agents.nix#jules${ref}";
      };
      environmentFiles = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        description = "Environment files for ${instanceName}";
        default = environmentFiles;
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
        description =
          "Paths with read and write permissions for ${instanceName}";
        default = [ home "/nix/var/nix" "${cfg.workspaceBase}/shared" ];
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
        default = "4G";
      };
      cpuQuota = lib.mkOption {
        type = lib.types.str;
        description = "The CPU quota for ${instanceName}";
        default = "200%";
      };
      tasksMax = lib.mkOption {
        type = lib.types.int;
        description = "The maximum number of tasks for ${instanceName}";
        default = 1000;
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

  mkGitclawOptions = { instanceName, userName ? instanceName
    , description ? "Gitclaw (${instanceName})"
    , home ? "${cfg.workspaceBase}/${instanceName}", uid, environmentFiles ? [ ]
    , }: {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the ${instanceName} agent";
      };
      name = lib.mkOption {
        type = lib.types.str;
        description = "The name of the ${instanceName} user";
        default = userName;
      };
      description = lib.mkOption {
        type = lib.types.str;
        description = "The description of the ${instanceName} agent";
        default = description;
      };
      version = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description =
          "Version/commit of gitclaw harness to use for ${instanceName}";
        example = "0.1.0-rc.7";
      };
      skipApprovals = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to skip approvals";
      };
      skipApprovalsFlag = lib.mkOption {
        type = lib.types.str;
        default = "--yolo";
        description = "CLI Flag to skip approvals";
      };
      useFreeClaudeCode = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to use the free-claude-code proxy";
      };
      customChangeDirFlag = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "CLI flag to start in a different directory";
      };
      home = lib.mkOption {
        type = lib.types.path;
        description = "The home folder of the ${instanceName} user";
        default = home;
      };
      uid = lib.mkOption {
        type = lib.types.int;
        description = "The UID of the ${instanceName} user";
        default = uid;
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
        in "${pkgs.nix}/bin/nix --extra-experimental-features 'nix-command flakes' run github:numtide/llm-agents.nix#gitclaw${ref}";
      };
      environmentFiles = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        description = "Environment files for ${instanceName}";
        default = environmentFiles;
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
        description =
          "Paths with read and write permissions for ${instanceName}";
        default = [ home "/nix/var/nix" "${cfg.workspaceBase}/shared" ];
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
        default = "4G";
      };
      cpuQuota = lib.mkOption {
        type = lib.types.str;
        description = "The CPU quota for ${instanceName}";
        default = "200%";
      };
      tasksMax = lib.mkOption {
        type = lib.types.int;
        description = "The maximum number of tasks for ${instanceName}";
        default = 1000;
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

  mkGrokOptions = { instanceName, userName ? instanceName
    , description ? "Grok (${instanceName})"
    , home ? "${cfg.workspaceBase}/${instanceName}", uid, environmentFiles ? [ ]
    , }: {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the ${instanceName} agent";
      };
      name = lib.mkOption {
        type = lib.types.str;
        description = "The name of the ${instanceName} user";
        default = userName;
      };
      description = lib.mkOption {
        type = lib.types.str;
        description = "The description of the ${instanceName} agent";
        default = description;
      };
      version = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description =
          "Version/commit of Grok harness to use for ${instanceName}";
        example = "0.1.0-rc.7";
      };
      skipApprovals = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to skip approvals";
      };
      skipApprovalsFlag = lib.mkOption {
        type = lib.types.str;
        default = "--yolo";
        description = "CLI Flag to skip approvals";
      };
      useFreeClaudeCode = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to use the free-claude-code proxy";
      };
      customChangeDirFlag = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "CLI flag to start in a different directory";
      };
      home = lib.mkOption {
        type = lib.types.path;
        description = "The home folder of the ${instanceName} user";
        default = home;
      };
      uid = lib.mkOption {
        type = lib.types.int;
        description = "The UID of the ${instanceName} user";
        default = uid;
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
        in "${pkgs.nix}/bin/nix --extra-experimental-features 'nix-command flakes' run github:numtide/llm-agents.nix#grok${ref}";
      };
      environmentFiles = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        description = "Environment files for ${instanceName}";
        default = environmentFiles;
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
        description =
          "Paths with read and write permissions for ${instanceName}";
        default = [ home "/nix/var/nix" "${cfg.workspaceBase}/shared" ];
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
        default = "4G";
      };
      cpuQuota = lib.mkOption {
        type = lib.types.str;
        description = "The CPU quota for ${instanceName}";
        default = "200%";
      };
      tasksMax = lib.mkOption {
        type = lib.types.int;
        description = "The maximum number of tasks for ${instanceName}";
        default = 1000;
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

  mkKimiCodeOptions = { instanceName, userName ? instanceName
    , description ? "KimiCode (${instanceName})"
    , home ? "${cfg.workspaceBase}/${instanceName}", uid, environmentFiles ? [ ]
    , }: {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the ${instanceName} agent";
      };
      name = lib.mkOption {
        type = lib.types.str;
        description = "The name of the ${instanceName} user";
        default = userName;
      };
      description = lib.mkOption {
        type = lib.types.str;
        description = "The description of the ${instanceName} agent";
        default = description;
      };
      version = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description =
          "Version/commit of KimiCode harness to use for ${instanceName}";
        example = "0.1.0-rc.7";
      };
      skipApprovals = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to skip approvals";
      };
      skipApprovalsFlag = lib.mkOption {
        type = lib.types.str;
        default = "--yolo";
        description = "CLI Flag to skip approvals";
      };
      useFreeClaudeCode = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to use the free-claude-code proxy";
      };
      customChangeDirFlag = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "CLI flag to start in a different directory";
      };
      home = lib.mkOption {
        type = lib.types.path;
        description = "The home folder of the ${instanceName} user";
        default = home;
      };
      uid = lib.mkOption {
        type = lib.types.int;
        description = "The UID of the ${instanceName} user";
        default = uid;
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
        in "${pkgs.nix}/bin/nix --extra-experimental-features 'nix-command flakes' run github:numtide/llm-agents.nix#kimi-code${ref}";
      };
      environmentFiles = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        description = "Environment files for ${instanceName}";
        default = environmentFiles;
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
        description =
          "Paths with read and write permissions for ${instanceName}";
        default = [ home "/nix/var/nix" "${cfg.workspaceBase}/shared" ];
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
        default = "4G";
      };
      cpuQuota = lib.mkOption {
        type = lib.types.str;
        description = "The CPU quota for ${instanceName}";
        default = "200%";
      };
      tasksMax = lib.mkOption {
        type = lib.types.int;
        description = "The maximum number of tasks for ${instanceName}";
        default = 1000;
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

  mkMinimaxCodeOptions = { instanceName, userName ? instanceName
    , description ? "MinimaxCode (${instanceName})"
    , home ? "${cfg.workspaceBase}/${instanceName}", uid, environmentFiles ? [ ]
    , }: {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the ${instanceName} agent";
      };
      name = lib.mkOption {
        type = lib.types.str;
        description = "The name of the ${instanceName} user";
        default = userName;
      };
      description = lib.mkOption {
        type = lib.types.str;
        description = "The description of the ${instanceName} agent";
        default = description;
      };
      version = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description =
          "Version/commit of MinimaxCode harness to use for ${instanceName}";
        example = "0.1.0-rc.7";
      };
      skipApprovals = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to skip approvals";
      };
      skipApprovalsFlag = lib.mkOption {
        type = lib.types.str;
        default = "--yolo";
        description = "CLI Flag to skip approvals";
      };
      useFreeClaudeCode = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to use the free-claude-code proxy";
      };
      customChangeDirFlag = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "CLI flag to start in a different directory";
      };
      home = lib.mkOption {
        type = lib.types.path;
        description = "The home folder of the ${instanceName} user";
        default = home;
      };
      uid = lib.mkOption {
        type = lib.types.int;
        description = "The UID of the ${instanceName} user";
        default = uid;
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
        in "${pkgs.nix}/bin/nix --extra-experimental-features 'nix-command flakes' run github:numtide/llm-agents.nix#minimax-code${ref}";
      };
      environmentFiles = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        description = "Environment files for ${instanceName}";
        default = environmentFiles;
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
        description =
          "Paths with read and write permissions for ${instanceName}";
        default = [ home "/nix/var/nix" "${cfg.workspaceBase}/shared" ];
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
        default = "4G";
      };
      cpuQuota = lib.mkOption {
        type = lib.types.str;
        description = "The CPU quota for ${instanceName}";
        default = "200%";
      };
      tasksMax = lib.mkOption {
        type = lib.types.int;
        description = "The maximum number of tasks for ${instanceName}";
        default = 1000;
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

  mkOpencode2Options = { instanceName, userName ? instanceName
    , description ? "Opencode2 (${instanceName})"
    , home ? "${cfg.workspaceBase}/${instanceName}", uid, environmentFiles ? [ ]
    , }: {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the ${instanceName} agent";
      };
      name = lib.mkOption {
        type = lib.types.str;
        description = "The name of the ${instanceName} user";
        default = userName;
      };
      description = lib.mkOption {
        type = lib.types.str;
        description = "The description of the ${instanceName} agent";
        default = description;
      };
      version = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description =
          "Version/commit of Opencode2 harness to use for ${instanceName}";
        example = "0.1.0-rc.7";
      };
      skipApprovals = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to skip approvals";
      };
      skipApprovalsFlag = lib.mkOption {
        type = lib.types.str;
        default = "--yolo";
        description = "CLI Flag to skip approvals";
      };
      useFreeClaudeCode = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to use the free-claude-code proxy";
      };
      customChangeDirFlag = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "CLI flag to start in a different directory";
      };
      home = lib.mkOption {
        type = lib.types.path;
        description = "The home folder of the ${instanceName} user";
        default = home;
      };
      uid = lib.mkOption {
        type = lib.types.int;
        description = "The UID of the ${instanceName} user";
        default = uid;
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
        in "${pkgs.nix}/bin/nix --extra-experimental-features 'nix-command flakes' run github:numtide/llm-agents.nix#opencode2${ref}";
      };
      environmentFiles = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        description = "Environment files for ${instanceName}";
        default = environmentFiles;
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
        description =
          "Paths with read and write permissions for ${instanceName}";
        default = [ home "/nix/var/nix" "${cfg.workspaceBase}/shared" ];
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
        default = "4G";
      };
      cpuQuota = lib.mkOption {
        type = lib.types.str;
        description = "The CPU quota for ${instanceName}";
        default = "200%";
      };
      tasksMax = lib.mkOption {
        type = lib.types.int;
        description = "The maximum number of tasks for ${instanceName}";
        default = 1000;
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

  mkQwenCodeOptions = { instanceName, userName ? instanceName
    , description ? "QwenCode (${instanceName})"
    , home ? "${cfg.workspaceBase}/${instanceName}", uid, environmentFiles ? [ ]
    , }: {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the ${instanceName} agent";
      };
      name = lib.mkOption {
        type = lib.types.str;
        description = "The name of the ${instanceName} user";
        default = userName;
      };
      description = lib.mkOption {
        type = lib.types.str;
        description = "The description of the ${instanceName} agent";
        default = description;
      };
      version = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description =
          "Version/commit of QwenCode harness to use for ${instanceName}";
        example = "0.1.0-rc.7";
      };
      skipApprovals = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to skip approvals";
      };
      skipApprovalsFlag = lib.mkOption {
        type = lib.types.str;
        default = "--yolo";
        description = "CLI Flag to skip approvals";
      };
      useFreeClaudeCode = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to use the free-claude-code proxy";
      };
      customChangeDirFlag = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "CLI flag to start in a different directory";
      };
      home = lib.mkOption {
        type = lib.types.path;
        description = "The home folder of the ${instanceName} user";
        default = home;
      };
      uid = lib.mkOption {
        type = lib.types.int;
        description = "The UID of the ${instanceName} user";
        default = uid;
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
        in "${pkgs.nix}/bin/nix --extra-experimental-features 'nix-command flakes' run github:numtide/llm-agents.nix#qwen-code${ref}";
      };
      environmentFiles = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        description = "Environment files for ${instanceName}";
        default = environmentFiles;
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
        description =
          "Paths with read and write permissions for ${instanceName}";
        default = [ home "/nix/var/nix" "${cfg.workspaceBase}/shared" ];
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
        default = "4G";
      };
      cpuQuota = lib.mkOption {
        type = lib.types.str;
        description = "The CPU quota for ${instanceName}";
        default = "200%";
      };
      tasksMax = lib.mkOption {
        type = lib.types.int;
        description = "The maximum number of tasks for ${instanceName}";
        default = 1000;
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

  mkMuseCodeOptions = { instanceName, userName ? instanceName
    , description ? "MuseCode (${instanceName})"
    , home ? "${cfg.workspaceBase}/${instanceName}", uid, environmentFiles ? [ ]
    , }: {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the ${instanceName} agent";
      };
      name = lib.mkOption {
        type = lib.types.str;
        description = "The name of the ${instanceName} user";
        default = userName;
      };
      description = lib.mkOption {
        type = lib.types.str;
        description = "The description of the ${instanceName} agent";
        default = description;
      };
      version = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description =
          "Version/commit of MuseCode harness to use for ${instanceName}";
        example = "0.1.0-rc.7";
      };
      skipApprovals = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to skip approvals";
      };
      skipApprovalsFlag = lib.mkOption {
        type = lib.types.str;
        default = "--yolo";
        description = "CLI Flag to skip approvals";
      };
      useFreeClaudeCode = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to use the free-claude-code proxy";
      };
      customChangeDirFlag = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "CLI flag to start in a different directory";
      };
      home = lib.mkOption {
        type = lib.types.path;
        description = "The home folder of the ${instanceName} user";
        default = home;
      };
      uid = lib.mkOption {
        type = lib.types.int;
        description = "The UID of the ${instanceName} user";
        default = uid;
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
        in "${pkgs.nix}/bin/nix --extra-experimental-features 'nix-command flakes' run github:numtide/llm-agents.nix#muse-code${ref}";
      };
      environmentFiles = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        description = "Environment files for ${instanceName}";
        default = environmentFiles;
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
        description =
          "Paths with read and write permissions for ${instanceName}";
        default = [ home "/nix/var/nix" "${cfg.workspaceBase}/shared" ];
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
        default = "4G";
      };
      cpuQuota = lib.mkOption {
        type = lib.types.str;
        description = "The CPU quota for ${instanceName}";
        default = "200%";
      };
      tasksMax = lib.mkOption {
        type = lib.types.int;
        description = "The maximum number of tasks for ${instanceName}";
        default = 1000;
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

  mkZcodeOptions = { instanceName, userName ? instanceName
    , description ? "Zcode (${instanceName})"
    , home ? "${cfg.workspaceBase}/${instanceName}", uid, environmentFiles ? [ ]
    , }: {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the ${instanceName} agent";
      };
      name = lib.mkOption {
        type = lib.types.str;
        description = "The name of the ${instanceName} user";
        default = userName;
      };
      description = lib.mkOption {
        type = lib.types.str;
        description = "The description of the ${instanceName} agent";
        default = description;
      };
      version = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description =
          "Version/commit of Zcode harness to use for ${instanceName}";
        example = "0.1.0-rc.7";
      };
      skipApprovals = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to skip approvals";
      };
      skipApprovalsFlag = lib.mkOption {
        type = lib.types.str;
        default = "--yolo";
        description = "CLI Flag to skip approvals";
      };
      useFreeClaudeCode = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to use the free-claude-code proxy";
      };
      customChangeDirFlag = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "CLI flag to start in a different directory";
      };
      home = lib.mkOption {
        type = lib.types.path;
        description = "The home folder of the ${instanceName} user";
        default = home;
      };
      uid = lib.mkOption {
        type = lib.types.int;
        description = "The UID of the ${instanceName} user";
        default = uid;
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
        in "${pkgs.nix}/bin/nix --extra-experimental-features 'nix-command flakes' run github:numtide/llm-agents.nix#zcode${ref}";
      };
      environmentFiles = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        description = "Environment files for ${instanceName}";
        default = environmentFiles;
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
        description =
          "Paths with read and write permissions for ${instanceName}";
        default = [ home "/nix/var/nix" "${cfg.workspaceBase}/shared" ];
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
        default = "4G";
      };
      cpuQuota = lib.mkOption {
        type = lib.types.str;
        description = "The CPU quota for ${instanceName}";
        default = "200%";
      };
      tasksMax = lib.mkOption {
        type = lib.types.int;
        description = "The maximum number of tasks for ${instanceName}";
        default = 1000;
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

  mkJustEveryCodeOptions = { instanceName, userName ? instanceName
    , description ? "Just-Every Code (${instanceName})"
    , home ? "${cfg.workspaceBase}/${instanceName}", uid, environmentFiles ? [ ]
    , }: {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the ${instanceName} agent";
      };
      name = lib.mkOption {
        type = lib.types.str;
        description = "The name of the ${instanceName} user";
        default = userName;
      };
      description = lib.mkOption {
        type = lib.types.str;
        description = "The description of the ${instanceName} agent";
        default = description;
      };
      version = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description =
          "Version/commit of Just-Every Code harness to use for ${instanceName}";
        example = "0.1.0-rc.7";
      };
      skipApprovals = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to skip approvals";
      };
      skipApprovalsFlag = lib.mkOption {
        type = lib.types.str;
        default = "--yolo";
        description = "CLI Flag to skip approvals";
      };
      useFreeClaudeCode = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to use the free-claude-code proxy";
      };
      customChangeDirFlag = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "CLI flag to start in a different directory";
      };
      home = lib.mkOption {
        type = lib.types.path;
        description = "The home folder of the ${instanceName} user";
        default = home;
      };
      uid = lib.mkOption {
        type = lib.types.int;
        description = "The UID of the ${instanceName} user";
        default = uid;
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
        in "${pkgs.nix}/bin/nix --extra-experimental-features 'nix-command flakes' run github:numtide/llm-agents.nix#code${ref}";
      };
      environmentFiles = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        description = "Environment files for ${instanceName}";
        default = environmentFiles;
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
        description =
          "Paths with read and write permissions for ${instanceName}";
        default = [ home "/nix/var/nix" "${cfg.workspaceBase}/shared" ];
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
        default = "4G";
      };
      cpuQuota = lib.mkOption {
        type = lib.types.str;
        description = "The CPU quota for ${instanceName}";
        default = "200%";
      };
      tasksMax = lib.mkOption {
        type = lib.types.int;
        description = "The maximum number of tasks for ${instanceName}";
        default = 1000;
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

  mkFreeClaudeCode = { home, owner
    , authToken ? "8SU/Y90FgCJ/uKqZv3yG01mCr8e0WsSqWRPwBsDN/k3b/525YdM/yvhc8BtP"
    }: {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the Free Claude Code";
      };
      owner = lib.mkOption {
        type = lib.types.str;
        description = "The name of the user owning Free Claude Code";
        default = owner;
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
        default = "${home}/free-claude-code";
        description = "free-claude-code path";
      };

      uvCachePath = lib.mkOption {
        type = lib.types.path;
        default = "${home}/.cache/uv";
        description = "UV cache dir";
      };

      anthropicAuthToken = lib.mkOption {
        type = lib.types.str;
        default = authToken;
        description =
          "Custom auth token for Anthropic (to make free-claude-code private)";
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
      userName = "claude-code";
      home = "${cfg.workspaceBase}/claude-code";
      uid = 5001;
    };

    codex = mkCodexOptions {
      instanceName = "codex";
      userName = "codex";
      uid = 5002;
    };

    pi = mkPiOptions {
      instanceName = "pi";
      userName = "pi";
      uid = 5004;
    };

    hermesPc = mkHermesOptions {
      instanceName = "hermesPc";
      userName = "hermes-pc";
      home = "${cfg.workspaceBase}/hermes-pc";
      uid = 5005;
    };

    hermesWork = mkHermesOptions {
      instanceName = "hermesWork";
      userName = "hermes-work";
      home = "${cfg.workspaceBase}/hermes-work";
      uid = 5006;
    };

    hermesPersonal = mkHermesOptions {
      instanceName = "hermesPersonal";
      userName = "hermes-personal";
      home = "${cfg.workspaceBase}/hermes-personal";
      uid = 5007;
    };

    deepseek = mkDeepseekOptions {
      instanceName = "deepseek";
      userName = "deepseek";
      home = "${cfg.workspaceBase}/deepseek";
      uid = 5008;
    };

    jules = mkJulesOptions {
      instanceName = "jules";
      userName = "jules";
      home = "${cfg.workspaceBase}/jules";
      uid = 5009;
    };

    grok = mkGrokOptions {
      instanceName = "grok";
      userName = "grok";
      home = "${cfg.workspaceBase}/grok";
      uid = 5010;
    };

    gitclaw = mkGitclawOptions {
      instanceName = "gitclaw";
      userName = "gitclaw";
      home = "${cfg.workspaceBase}/gitclaw";
      uid = 5011;
    };

    kimiCode = mkKimiCodeOptions {
      instanceName = "kimiCode";
      userName = "kimicode";
      home = "${cfg.workspaceBase}/kimicode";
      uid = 5012;
    };

    minimaxCode = mkMinimaxCodeOptions {
      instanceName = "minimaxCode";
      userName = "minimaxcode";
      home = "${cfg.workspaceBase}/minimaxcode";
      uid = 5013;
    };

    opencode2 = mkOpencode2Options {
      instanceName = "opencode2";
      userName = "opencode2";
      home = "${cfg.workspaceBase}/opencode2";
      uid = 5014;
    };

    qwenCode = mkQwenCodeOptions {
      instanceName = "qwenCode";
      userName = "qwencode";
      home = "${cfg.workspaceBase}/qwencode";
      uid = 5015;
    };

    museCode = mkMuseCodeOptions {
      instanceName = "museCode";
      userName = "musecode";
      home = "${cfg.workspaceBase}/musecode";
      uid = 5016;
    };

    zcode = mkZcodeOptions {
      instanceName = "zcode";
      userName = "zcode";
      home = "${cfg.workspaceBase}/zcode";
      uid = 5017;
    };

    justEveryCode = mkJustEveryCodeOptions {
      instanceName = "justEveryCode";
      userName = "justeverycode";
      home = "${cfg.workspaceBase}/justeverycode";
      uid = 5018;
    };

    freeClaudeCode = mkFreeClaudeCode {
      home = "${cfg.workspaceBase}/shared";
      owner = "claude-code";
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
          "gitlab.colordigital.cloud"
          "nexus.colordigital.cloud"
          "jenkins.colordigital.cloud"
          "ran01.dmix.io"
          "grafana.dmix.io"
          "colordigital.atlassian.net"

          # ── Claude Code (Anthropic) ──
          "api.anthropic.com"
          "statsig.anthropic.com"
          "sentry.io"
          "claude.ai"
          "platform.claude.com"
          "downloads.claude.ai"
          "storage.googleapis.com"
          "bridge.claudeusercontent.com"
          "raw.githubusercontent.com"

          # ── OpenRouter ──
          "openrouter.ai"
          "api.openrouter.ai"

          # ── deepseek ──
          "api.deepseek.com"

          # ── nvidia rim ──
          "rim.attestation.nvidia.com"

          # ── OpenAI / ChatGPT / Codex ──
          "api.openai.com"
          "cdn.openai.com"
          "chatgpt.com"
          "ab.chatgpt.com"
          "files.oaiusercontent.com"
          "openaipublic.blob.core.windows.net"
          "developers.openai.com"

          # -- minimax.io --
          "api.minimax.io"

          # ── npm (needed for codex/node tools) ──
          "registry.npmjs.org"

          # ── GitHub (git + API + downloads) ──
          "github.com"
          "api.github.com"
          "raw.githubusercontent.com"
          "objects.githubusercontent.com"
          "codeload.github.com"

          # ── Google AI ──
          "generativelanguage.googleapis.com" # Gemini API
          "aiplatform.googleapis.com" # Vertex AI
          "oauth2.googleapis.com" # auth
          "accounts.google.com" # auth
          "www.googleapis.com" # general Google API
          "storage.googleapis.com" # model artifacts
          "aistudio.google.com" # AI Studio web
          "cloudcode-pa.googleapis.com"

          # ── Common dependencies ──
          "github.com" # git operations
          "api.github.com" # GitHub API
          "raw.githubusercontent.com" # raw file fetches
          "objects.githubusercontent.com" # git LFS / releases
          "nixos.org" # nix run needs this
          "cache.nixos.org" # nix binary cache
          "channels.nixos.org"
          "fastdl.mongodb.org"
          "repo.maven.apache.org"
          "docs.rs"
          "doc.rust-lang.org"
          "developer.mozilla.org"
          "stackoverflow.com"
          "wiki.nixos.org"
          "man7.org"
          "gitlab.com"

          # -- TTS --
          "speech.platform.bing.com"

          # -- MCPs --
          "espectro.dev"
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
          "kibana.dmix.io"
          "grafana.dmix.io"
          "ran01.dmix.io"
          "dev.dmix.cloud"
          "auth-dev.dmix.cloud"
          "dev2.dmix.cloud"
          "auth2-dev.dmix.cloud"
          "int.dmix.cloud"
          "auth-int.dmix.cloud"
          "dmix.cloud"
          "auth.dmix.cloud"
        ];
        description = "Private domains";
      };
    };
  };
}

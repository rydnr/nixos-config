{ config, pkgs, ... }:
let
  # ──────────────────────────────────────────────
  # Define the shared workspace root
  # ──────────────────────────────────────────────
  agentWorkspaceBase = "/srv/agent-workspaces";

  # ──────────────────────────────────────────────
  # Helper to define a locked-down agent user
  # ──────────────────────────────────────────────
  mkAgentUser = { name, uid, description }: {
    isNormalUser = true;
    inherit uid description;
    shell = pkgs.bash;
    home = "${agentWorkspaceBase}/${name}";
    createHome = true;
    extraGroups = [
      "agents"
      # Nothing else. No wheel, no docker, no disk.
    ];
  };

in {

  users.extraUsers.claude = mkAgentUser {
    name = "claude";
    uid = 1003;
    description = "Claude Code Agent";
  };

  users.extraUsers.codex = mkAgentUser {
    name = "codex";
    uid = 1004;
    description = "Codex Agent";
  };

  # ════════════════════════════════════════════════
  # 2. FILESYSTEM BOUNDARIES
  # ════════════════════════════════════════════════

  # Create and permission the workspace directories
  systemd.tmpfiles.rules = [
    # Base directory: owned by root, readable by agents group
    "d ${agentWorkspaceBase}       0750 root   agents -  -"

    # Per-agent directories: each agent owns ONLY its own space
    "d ${agentWorkspaceBase}/claude 0700 claude claude -  -"
    "d ${agentWorkspaceBase}/codex  0700 codex  codex  -  -"

    # Shared input directory (you drop files here for agents to read)
    "d ${agentWorkspaceBase}/shared 0750 root   agents -  -"
  ];

  # ════════════════════════════════════════════════
  # 3. SUDO: DENY AGENTS ENTIRELY
  # ════════════════════════════════════════════════

  security.sudo.extraRules = [{
    groups = [ "agents" ];
    commands = [{
      command = "ALL";
      options = [ "!authenticate" ];
    }];
    runAs = "ALL";
    # Explicitly deny
  }];

  # Better: use a sudoers drop-in that denies the group
  environment.etc."sudoers.d/deny-agents".text = ''
    %agents ALL=(ALL:ALL) !ALL
  '';

  # ════════════════════════════════════════════════
  # 4. SYSTEMD SANDBOXING (run agents as services)
  # ════════════════════════════════════════════════

  # Example: Run Claude as a sandboxed systemd service
  systemd.services.claude-agent = {
    description = "Claude Code Agent";
    serviceConfig = {
      User = "claude";
      Group = "agents";

      # ── Filesystem isolation ──
      WorkingDirectory = "${agentWorkspaceBase}/claude";
      ProtectHome = "yes"; # Can't see /home
      ProtectSystem = "strict"; # / is read-only
      ReadWritePaths = [
        "${agentWorkspaceBase}/claude" # ONLY its own workspace
      ];
      ReadOnlyPaths = [
        "${agentWorkspaceBase}/shared" # Can read shared inputs
      ];
      PrivateTmp = true; # Isolated /tmp
      TemporaryFileSystem = "/home:ro"; # Empty /home visible

      # ── Capability restrictions ──
      NoNewPrivileges = true; # Can't escalate
      CapabilityBoundingSet = ""; # Drop ALL capabilities
      AmbientCapabilities = "";

      # ── Network control ──
      # Option A: No network at all
      # PrivateNetwork = true;
      # Option B: Allow network (for API calls, git, etc.)
      RestrictAddressFamilies = "AF_INET AF_INET6 AF_UNIX";

      # ── System call filtering ──
      SystemCallFilter = [
        "@system-service" # Allow normal syscalls
        "~@mount" # Block mounting
        "~@reboot" # Block reboot
        "~@swap" # Block swap manipulation
        "~@clock" # Block clock changes
        "~@module" # Block kernel modules
        "~@raw-io" # Block raw I/O
        "~@privileged" # Block privileged ops
      ];
      SystemCallArchitectures = "native";

      # ── Resource limits ──
      MemoryMax = "4G";
      CPUQuota = "200%"; # 2 cores max
      TasksMax = 100; # Max 100 processes
      LimitNOFILE = 4096;
    };

    # What the agent actually runs
    script = ''
      exec ${pkgs.your-agent-launcher}/bin/claude-agent
    '';
  };

  # ════════════════════════════════════════════════
  # 5. NETWORK RESTRICTIONS (optional, via firewall)
  # ════════════════════════════════════════════════

  # Restrict what agents can connect to using iptables owner match
  networking.firewall.extraCommands = ''
    # Allow agents to reach only specific API endpoints
    # Block everything first
    iptables -A OUTPUT -m owner --gid-owner agents -j REJECT

    # Then allow specific things
    # DNS
    iptables -I OUTPUT -m owner --gid-owner agents \
      -p udp --dport 53 -j ACCEPT
    # HTTPS (for API calls)
    iptables -I OUTPUT -m owner --gid-owner agents \
      -p tcp --dport 443 -j ACCEPT
    # Git SSH
    iptables -I OUTPUT -m owner --gid-owner agents \
      -p tcp --dport 22 -j ACCEPT
  '';
}

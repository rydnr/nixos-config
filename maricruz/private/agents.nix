{ config, ... }: {
  agents = rec {
    claudeCode.enable = true;
    codex.enable = true;
    gemini.enable = true;
    pi.enable = true;
    hermesPc = {
      enable = true;
      # version = "v2026.4.23";
    };
    hermesWork = { enable = false; };
    hermesPersonal = { enable = true; };
    deepseek = { enable = true; };
    jules = { enable = true; };
    freeClaudeCode = {
      enable = false;
      owner = "claude-code";
    };
  };
}

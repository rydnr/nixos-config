{ config, ... }: {
  agents = rec {
    claudeCode.enable = true;
    codex.enable = true;
    pi.enable = true;
    hermesPc = {
      enable = true;
      # version = "v2026.4.23";
    };
    hermesWork = { enable = false; };
    hermesPersonal = { enable = true; };
    deepseek = { enable = true; };
    jules = { enable = true; };
    grok = { enable = true; };
    gitclaw = { enable = true; };
    kimiCode = { enable = true; };
    minimaxCode = { enable = true; };
    opencode2 = { enable = true; };
    qwenCode = { enable = true; };
    museCode = { enable = true; };
    zcode = { enable = true; };
    justEveryCode = { enable = true; };
    freeClaudeCode = {
      enable = false;
      owner = "claude-code";
    };
  };
}

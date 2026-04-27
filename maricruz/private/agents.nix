{ config, ... }: {
  agents = {
    claude.enable = true;
    codex.enable = true;
    gemini.enable = true;
    pi.enable = true;
    hermes.enable = true;
  };
}

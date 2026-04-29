{ config, ... }: {
  agents = {
    claudeCode.enable = true;
    codex.enable = true;
    gemini.enable = true;
    piWork.enable = false;
    piDryWit.enable = true;
    piPythonEda.enable = true;
    piJavaEda.enable = true;
    hermesPc = {
      enable = true;
      version = "v2026.4.23";
    };
    hermesPersonal = {
      enable = true;
      version = "v2026.4.23";
    };
  };
}

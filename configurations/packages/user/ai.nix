{ ... }:

{
    programs = {
        aider-chat.enable = true;
        aichat = {
            enable = true;
            settings.clients = [
                {
                    type = "openai-compatible";
                    name = "ollama";
                    api_base = "http://localhost:11434/v1";
                    models = [
                        { name = "llama3.1"; max_tokens = 4096; }
                        { name = "qwen3-coder"; max_tokens = 8192; }
                    ];
                }
            ];
        };
    };

    home.sessionVariables = {
        OLLAMA_API_BASE = "http://127.0.0.1:11434";
        AIDER_MODEL = "ollama/qwen3-coder";
    };
    
    programs.bash.shellAliases = {
        ask = "aichat";
        code = "aider";
    };
}

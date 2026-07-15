{ pkgs, ... }:

let
    model_fast = "gpt-oss:20b";
in {
    programs = {
        aichat = {
            enable = true;
            settings = {
                clients = [
                    {
                        type = "openai-compatible";
                        name = "ollama";
                        api_base = "http://localhost:11434/v1";
                        models = [
                            { name = "${model_fast}"; max_tokens = 4096; }
                        ];
                    }
                ];
            };
        };
    };

    home.packages = [ pkgs.claude-code ];

    home.sessionVariables = {
        OLLAMA_API_BASE = "http://127.0.0.1:11434";
    };
    
    programs.bash.shellAliases = {
        ask = "aichat --model 'ollama:${model_fast}' --prompt 'Answer with maximum conciseness: direct only, no greetings, filler, explanations, or preambles unless explicitly requested. Use short sentences or bullet points only if necessary. Omit all hedging, examples, summaries, and closing remarks. Prioritize speed and factual accuracy above all else.'";
    };
}

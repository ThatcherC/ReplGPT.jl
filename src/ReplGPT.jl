module ReplGPT

import OpenAI
import ReplMaker
import Markdown

const apiKeyName = "OPENAI_API_KEY"

function call_chatgpt(s)

    if haskey(ENV, apiKeyName)
        r = OpenAI.create_chat(
            ENV[apiKeyName],
            "gpt-3.5-turbo",
            [Dict("role" => "user", "content" => s)],
        )

        # TODO: check for errors!
        #if !=(r.status, 200)
        #  @test false
        #end  
        response = r.response["choices"][begin]["message"]["content"]

        Markdown.parse(response)
    else
        Markdown.parse(
            "No API key found in ENV! Please set the OpenAI API key environment variable with $(apiKeyName)=<YOUR OPENAI API KEY>",
        )
    end
end

function init_repl()

    if !haskey(ENV, apiKeyName)
        @warn "$apiKeyName not found in ENV! Please set the environment variable $(apiKeyName)=<YOUR OPENAI API KEY>"
    end

    ReplMaker.initrepl(
        call_chatgpt,
        prompt_text = "ChatGPT> ",
        prompt_color = :blue,
        start_key = '}',
        mode_name = "ChatGPT_mode",
    )
end

__init__() = isdefined(Base, :active_repl) ? init_repl() : nothing


end # module

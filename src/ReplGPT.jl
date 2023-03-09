module ReplGPT

import OpenAI
import ReplMaker
import Markdown
import Preferences

const apiKeyName = "OPENAI_API_KEY"

function getAPIkey()
    key = missing
    if haskey(ENV, apiKeyName)
        key = ENV[apiKeyName]
    end

    return key
end

function call_chatgpt(s)
    key = getAPIkey()
    if !ismissing(key)
        r = OpenAI.create_chat(
            key,
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

    if ismissing(getAPIkey())
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

module ReplGPT

import OpenAI
import ReplMaker
import Markdown

const apiKeyName = "OPENAI_API_KEY"

conversation = Vector{Dict{String, String}}()

function call_chatgpt(s)

    if haskey(ENV, apiKeyName)

        userMessage = Dict("role" => "user", "content" => s)
        append!(conversation, userMessage)

        r = OpenAI.create_chat(
            ENV[apiKeyName],
            "gpt-3.5-turbo",
            conversation,
        )

        # TODO: check for errors!
        #if !=(r.status, 200)
        #  @test false
        #end  
        response = r.response["choices"][begin]["message"]["content"]

        # append ChatGPT's response to the conversation history
        # TODO: the object built here might just be the same as r.response["choices"][begin]["message"]
        responseMessage = Dict("role" => "assistant", "content" => s)
        append!(conversation, responseMessage)

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

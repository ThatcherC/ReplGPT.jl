module ReplGPT

import OpenAI
import ReplMaker
import Markdown

using Preferences

include("formatting.jl")
include("keys.jl")

conversation = Vector{Dict{String,String}}()

function call_chatgpt(s)
    key = getAPIkey()
    if !ismissing(key)
        userMessage = Dict("role" => "user", "content" => s)
        push!(conversation, userMessage)

        r = OpenAI.create_chat(key, "gpt-3.5-turbo", conversation)

        # TODO: check for errors!
        #if !=(r.status, 200)
        #  @test false
        #end  
        response = r.response["choices"][begin]["message"]["content"]

        # append ChatGPT's response to the conversation history
        # TODO: the object built here might just be the same as r.response["choices"][begin]["message"]
        responseMessage = Dict("role" => "assistant", "content" => response)
        push!(conversation, responseMessage)

        format(response)
    else
        format(
            "OpenAI API key not found! Please set with `ReplGPT.setAPIkey(\"<YOUR OPENAI API KEY>\")` or set the environment variable $(api_key_name)=<YOUR OPENAI API KEY>",
        )
    end
end

function init_repl()

    if ismissing(getAPIkey())
        @warn "OpenAI API key not found! Please set with `ReplGPT.setAPIkey(\"<YOUR OPENAI API KEY>\")` or set the environment variable $(api_key_name)=<YOUR OPENAI API KEY>"
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

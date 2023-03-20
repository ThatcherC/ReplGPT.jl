module ReplGPT

import OpenAI
import ReplMaker
import Markdown

using Preferences

const api_key_name = "OPENAI_API_KEY"
const api_pref_name = "openai_api_key"

format::Function = Markdown.parse

"""
    function getAPIkey()

Returns an OpenAI API key to use from either the `LocalPreferences.toml` file or the
`OPENAI_API_KEY` environment variable. If neither is present, returns `missing`.
"""
function getAPIkey()
    key = missing

    # try to load key from Preferences:
    key = @load_preference(api_pref_name, missing)

    # if not koaded from preferences, look in environment variables
    if ismissing(key) && haskey(ENV, api_key_name)
        key = ENV[api_key_name]
    end

    return key
end

"""
    function setAPIkey(key::String)

Sets the OpenAI API key for ReplGPT to use. The key will be saved as plaintext to your environment's
`LocalPreferences.toml` file (perhaps somewhere like `~/.julia/environments/v1.8/LocalPreferences.toml`).
The key can be deleted with `ReplGPT.clearAPIkeyI()`. 
"""
function setAPIkey(key::String)
    @set_preferences!(api_pref_name => key)
end

"""
    function clearAPIkey()

Deletes the OpenAI API key saved in `LocalPreferences.toml` if present. 

See also: ReplGPT.setAPIkey(key::String)
"""
function clearAPIkey()
    @delete_preferences!(api_pref_name)
end

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

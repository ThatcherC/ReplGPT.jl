module ReplGPT

import OpenAI
import ReplMaker
import Markdown

using Preferences

const api_key_name = "OPENAI_API_KEY"
const api_pref_name = "openai_api_key"

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

        Markdown.parse(response)
    else
        Markdown.parse(
            "OpenAI API key not found! Please set with `ReplGPT.setAPIkey(\"<YOUR OPENAI API KEY>\")` or set the environment variable $(api_key_name)=<YOUR OPENAI API KEY>",
        )
    end
end

"""
    function should_init_repl()

Check whether we should call `init_repl`. This function should return `true` when 
called from a `using ReplGPT` call in the REPL or via `startup.jl`. It should return
false when used in a script. 
"""
function should_init_repl()
    isinteractive()
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

function __init__()
    if should_init_repl()
        # if there exists an active REPL (ie, we're in the Julia shell and called `using ReplGPT`)
        if isdefined(Base, :active_repl)
            init_repl()
        else # if there's no REPL yet, we might be in startup.jl
            # adapted from https://github.com/MasonProtter/ReplMaker.jl/blob/7b4efadceb0ec268d7c6351add83094ca37776e2/README.md?plain=1#L245-L260
            atreplinit() do repl
                try
                    init_repl()
                catch
                end
            end
        end

    else
        nothing
    end
end


end # module

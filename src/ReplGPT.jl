module ReplGPT

import OpenAI
import ReplMaker
import Markdown

@static if VERSION >= v"1.6"
    using Preferences
end

const apiKeyName = "OPENAI_API_KEY"
const apiPrefName = "openai_api_key"

"""
    function getAPIkey()

Returns an OpenAI API key to use from either the `LocalPreferences.toml` file or the
`OPENAI_API_KEY` environment variable. If neither is present, returns `missing`.
"""
function getAPIkey()
    key = missing

    # try to load key from Preferences:
    @static if VERSION >= v"1.6"
        key = @load_preference(apiPrefName, missing)
    end

    # if not koaded from preferences, look in environment variables
    if ismissing(key) && haskey(ENV, apiKeyName)
        key = ENV[apiKeyName]
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
    @set_preferences!(apiPrefName => key)
end

"""
    function clearAPIkey()

Deletes the OpenAI API key saved in `LocalPreferences.toml` if present. 

See also: ReplGPT.setAPIkey(key::String)
"""
function clearAPIkey()
    @delete_preferences!(apiPrefName)
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
        @warn "OpenAI API key not found! Please set with `ReplGPT.setAPIkey(<YOUR OPENAI API KEY>)` or set the environment variable $(apiKeyName)=<YOUR OPENAI API KEY>"
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

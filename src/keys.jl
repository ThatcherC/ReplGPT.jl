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
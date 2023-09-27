const api_model_name = "OPENAI_API_MODEL"
const api_pref_model_name = "openai_api_model"

"""
    function getmodelname()

Returns an OpenAI API model name to use from either the `LocalPreferences.toml` file or the
`OPENAI_API_MODEL` environment variable. If neither is present, returns `gpt-3.5-turbo`.
"""
function getmodelname()
    model = "gpt-3.5-turbo"

    # try to load model from Preferences:
    model = @load_preference(api_pref_model_name, "gpt-3.5-turbo")

    # if not koaded from preferences, look in environment variables
    if model == "gpt-3.5-turbo" && haskey(ENV, api_model_name)
        model = ENV[api_model_name]
    end

    return model
end

"""
    function setmodelname(model::String)

Sets the OpenAI API model for ReplGPT to use. The model will be saved as plaintext to your environment's
`LocalPreferences.toml` file (perhaps somewhere like `~/.julia/environments/v1.8/LocalPreferences.toml`).
The model can be deleted with `ReplGPT.clearmodelname()`. 
"""
function setmodelname(model::String)
    @set_preferences!(api_pref_model_name => model)
end

"""
    function clearmodelname()

Deletes the OpenAI API model saved in `LocalPreferences.toml` if present. 

See also: ReplGPT.setmodelname(model::String)
"""
function clearmodelname()
    @delete_preferences!(api_pref_model_name)
end

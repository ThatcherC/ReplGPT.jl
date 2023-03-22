var documenterSearchIndex = {"docs":
[{"location":"#ReplGPT.jl","page":"ReplGPT.jl","title":"ReplGPT.jl","text":"","category":"section"},{"location":"","page":"ReplGPT.jl","title":"ReplGPT.jl","text":"Documentation for ReplGPT.jl","category":"page"},{"location":"","page":"ReplGPT.jl","title":"ReplGPT.jl","text":"","category":"page"},{"location":"#Key-Management-Functions","page":"ReplGPT.jl","title":"Key Management Functions","text":"","category":"section"},{"location":"","page":"ReplGPT.jl","title":"ReplGPT.jl","text":"ReplGPT.getAPIkey()","category":"page"},{"location":"#ReplGPT.getAPIkey-Tuple{}","page":"ReplGPT.jl","title":"ReplGPT.getAPIkey","text":"function getAPIkey()\n\nReturns an OpenAI API key to use from either the LocalPreferences.toml file or the OPENAI_API_KEY environment variable. If neither is present, returns missing.\n\n\n\n\n\n","category":"method"},{"location":"","page":"ReplGPT.jl","title":"ReplGPT.jl","text":"ReplGPT.setAPIkey(key::String)\n\nReplGPT.clearAPIkey()","category":"page"},{"location":"#ReplGPT.setAPIkey-Tuple{String}","page":"ReplGPT.jl","title":"ReplGPT.setAPIkey","text":"function setAPIkey(key::String)\n\nSets the OpenAI API key for ReplGPT to use. The key will be saved as plaintext to your environment's LocalPreferences.toml file (perhaps somewhere like ~/.julia/environments/v1.8/LocalPreferences.toml). The key can be deleted with ReplGPT.clearAPIkeyI(). \n\n\n\n\n\n","category":"method"},{"location":"#ReplGPT.clearAPIkey-Tuple{}","page":"ReplGPT.jl","title":"ReplGPT.clearAPIkey","text":"function clearAPIkey()\n\nDeletes the OpenAI API key saved in LocalPreferences.toml if present. \n\nSee also: ReplGPT.setAPIkey(key::String)\n\n\n\n\n\n","category":"method"},{"location":"#Index","page":"ReplGPT.jl","title":"Index","text":"","category":"section"},{"location":"","page":"ReplGPT.jl","title":"ReplGPT.jl","text":"","category":"page"}]
}
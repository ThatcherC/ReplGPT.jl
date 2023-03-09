# ReplGPT.jl

Talk to ChatGPT from the Julia REPL!

It's as simple as `using ReplGPT` and entering the shell with `}`:
```
julia> using ReplGPT
REPL mode ChatGPT_mode initialized. Press } to enter and backspace to exit.

julia> 

ChatGPT> How do you exponentiate a matrix in Julia?
  You can exponentiate a matrix in Julia by using the expm function provided by the LinearAlgebra package.

  Here is an example code to exponentiate a matrix in Julia:

  using LinearAlgebra
  
  # define a matrix
  A = [1 2; 3 4]
  
  # exponentiate the matrix
  expm(A)

  This will output the exponential of the matrix A.

ChatGPT> 
```

## Getting Started:
You will need to obtain an OpenAI API key from [openai.com](openai.com) and pass it to Julia. ReplGPT.jl
will look for an API key in the `OPENAI_API_KEY` environment variable and also in the module's settings.

The **recommended approach** is to save the API key in the 
module's settings by running:

```julia
julia> using ReplGPT

julia> ReplGPT.setAPIkey("<YOUR KEY HERE>")
```

**Note:** with this approach your API key will be stored in plaintext in a 
`LocalPreferences.toml` folder in your environment directory. For example, on a Linux computer running Julia 1.8, the key is
stored in 
`~/.julia/environments/v1.8/LocalPreferences.toml`.

If there is interest, we can look for a non-plaintext way to store these keys.

To specify your key using environment variables, invoke Julia
as shown below:

```sh
$ OPENAI_API_KEY=<key goes here> julia
```



Inspiration drawn from 
[OpenAI.jl](https://github.com/rory-linehan/OpenAI.jl), 
[ReplMaker.jl](https://github.com/MasonProtter/ReplMaker.jl), 
[APL.jl](https://github.com/shashi/APL.jl),
and Xe Iaso's ChatGPT emacs integration in 
["We're never getting rid of ChatGPT"](https://xeiaso.net/blog/chatgpt-emacs).

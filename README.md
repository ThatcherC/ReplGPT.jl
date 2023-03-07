# ReplGPT.jl

Talk to ChatGPT from the Julia REPL!

It's as simple as `using ReplGPT` and entering the shell with `}`:
```julia
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

**NOTE:** You will need to acquire an OpenAI API key from [openai.com](openai.com) and store it in the 
`OPENAI_API_KEY` environment variable:

```sh
$ OPENAI_API_KEY=<key goes here> julia

$ # or

$ export OPENAI_API_KEY=<key goes here>
$ julia
```

Inspiration drawn from 
[OpenAI.jl](https://github.com/rory-linehan/OpenAI.jl), 
[ReplMaker.jl](https://github.com/MasonProtter/ReplMaker.jl), 
and [APL.jl](https://github.com/shashi/APL.jl)

# ReplGPT.jl

Talk to ChatGPT from the Julia REPL!

It's as simple as `using ReplGPT` and entering the shell with `}`:
```julia
julia> using ReplGPT
REPL mode ChatGPT_mode initialized. Press } to enter and backspace to exit.

ChatGPT> Can you give me a quick example of exponentiating a matrix in Julia?
  Certainly! Here's an example of exponentiating a matrix in Julia:

  A = [1 2; 3 4]   # Create a 2x2 matrix
  B = exp(A)       # Exponentiate the matrix using the "exp" function

  The resulting matrix B will be:

  2.718281828459045  7.3890560989306496
  20.085536923187668  54.598150033144236

  In this example, we exponentiated the matrix A using the built-in exp function in Julia, which applies the exponential
  function element-wise to a matrix.

ChatGPT> Thanks! Can you redo it with the matrix A = [1 i; -i 1]?
  Sure, here's how you can exponentiate the matrix A = [1 i; -i 1] in Julia:

  using LinearAlgebra
  
  A = [1 im; -im 1] # Create 2x2 matrix with complex elements
  B = exp(A) # Exponentiate the matrix using the "exp" function in LinearAlgebra
  

  The resulting matrix B will be:

  -0.131204 + 0.991017im    0.841471 - 0.540302im
  -0.841471 - 0.540302im   -0.131204 - 0.991017im

  In this example, we created a 2x2 matrix A with complex elements using the imaginary unit im in Julia. Then we used the exp
  function from the LinearAlgebra package to exponentiate the matrix A.

ChatGPT> Great! What language was all this again?
  This was all done in Julia, a high-level, dynamic programming language designed for numerical and scientific computing, data
  science, and artificial intelligence.

ChatGPT> 
```

## Getting Started:
You will need to obtain an OpenAI API key from [openai.com](https://platform.openai.com/account/api-keys) and pass it to Julia. ReplGPT.jl
will look for an API key in the module's settings and in 
the `OPENAI_API_KEY` environment variable as a fallback.

The **recommended approach** is to save the API key in the 
module's settings by running:

```julia
julia> using ReplGPT

julia> ReplGPT.setAPIkey("<YOUR KEY HERE>")
```

The API key can later be cleared with `ReplGPT.clearAPIkey()`.

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

Note that when the environment variable is used, the key is **not** saved to the `LocalPreferences.toml` file.

---

Inspiration drawn from 
[OpenAI.jl](https://github.com/rory-linehan/OpenAI.jl), 
[ReplMaker.jl](https://github.com/MasonProtter/ReplMaker.jl), 
[APL.jl](https://github.com/shashi/APL.jl),
and Xe Iaso's ChatGPT emacs integration in 
["We're never getting rid of ChatGPT"](https://xeiaso.net/blog/chatgpt-emacs).

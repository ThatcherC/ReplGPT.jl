"""
    function markdown(s::String)
A simple Markdown formatter. This is the default since ChatGPT
seems to like emitting Markdown strings and the formatting looks nice.

See also: [`ReplGPT.plaintext`](@ref), another formatter that does **no** formatting,
which is nice in case you don't want the ChatGPT output to be displayed
as Markdown.
"""
function markdown(s::String)
    Markdown.parse(s)
end

"""
    function plaintext(s::String)
A simple plain text formatter. Unlike [`ReplGPT.markdown`](@ref), this formatter
performs no text transformations except removing some leading whitespace.
"""
function plaintext(s::String)
    println(strip(s))
end

format::Function = markdown

"""
    function setFormatter(f::Function)
Set the ReplGPT formatter. The default formatter is [`ReplGPT.markdown`](@ref),
but [`ReplGPT.plaintext`](@ref) may be preferred if ChatGPT's response
shouldn't be displayed as Markdown text.

Other functions may be passed to `setFormatter` as long as they accept a 
string as input an return or print something.

# Examples
```julia-repl
julia> ReplGPT.setFormatter(ReplGPT.plaintext)
plaintext (generic function with 1 method)

julia> ReplGPT.setFormatter(ReplGPT.markdown)
markdown (generic function with 1 method)
```
"""
function setFormatter(f::Function)
    global format = f;
end
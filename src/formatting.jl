function markdown(s::String)
    Markdown.parse(s)
end

function plaintext(s::String)
    println(strip(s))
end

format::Function = markdown

function setFormatter(f::Function)
    global format = f
end
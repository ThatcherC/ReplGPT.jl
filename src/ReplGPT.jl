module ReplGPT

import OpenAI
import ReplMaker
import Markdown

using Preferences

include("formatting.jl")
include("keys.jl")
include("models.jl")

"""
    function ReplGPT.generate_empty_conversation()

Returns a new empty conversation history.
"""
function generate_empty_conversation()
    Vector{Dict{String,String}}()
end

conversation = generate_empty_conversation()

"""
    function ReplGPT.initialize_conversation()

Sets the ChatGPT conversation to an empty state. This effectively
starts a new chat with ChatGPT with no recollection of past messages.
"""
function initialize_conversation()
    global conversation = generate_empty_conversation()
end

"""
    function ReplGPT.conversation_as_string()

Serializes a conversation history to a string. Messages sent from the user
are preceded by "You:", messages from ChatGPT are preceded by "ChatGPT:",
and any system messages are preceded by "System:".

"""
function conversation_as_string()
    buf = IOBuffer()
    for message in conversation
        if message["role"] == "user"
            println(buf, "You:")
            println(buf, "----\n")
        elseif message["role"] == "assistant"
            println(buf, "ChatGPT:")
            println(buf, "--------\n")
        elseif message["role"] == "system"
            println(buf, "System:")
            println(buf, "-------\n")
        end

        println(buf, message["content"])
        println(buf)
    end

    String(take!(buf))
end

"""
    function ReplGPT.save_conversation(filepath)

Saves the output of [`ReplGPT.conversation_as_string()`](@ref) to a file at 
`filepath`. See the chat and output of ReplGPT.save_conversation() below.

## Example:

```julia
julia> 

ChatGPT> What does LISP stand for in computing?
  LISP stands for "LISt Processor".

ChatGPT> How about FORTRAN?
  FORTRAN stands for "FORmula TRANslation".

julia> ReplGPT.save_conversation("/tmp/convo.txt")

shell> cat /tmp/convo.txt
You:
----

What does LISP stand for in computing?

ChatGPT:
--------

LISP stands for "LISt Processor".

You:
----

How about FORTRAN?

ChatGPT:
--------

FORTRAN stands for "FORmula TRANslation".
```
"""
function save_conversation(filepath)
    s = conversation_as_string()

    try
        open(filepath, "w") do io
            println(io, s)
        end
    catch
        @error "Failed to open file '$filepath'!"
    end
end

function call_chatgpt(s)
    key = getAPIkey()
    model = getmodelname()
    if !ismissing(key)
        userMessage = Dict("role" => "user", "content" => s)
        push!(conversation, userMessage)

        r = OpenAI.create_chat(key, model, conversation)

        # TODO: check for errors!
        while !=(r.status, 200)
            format("ChatGPT is busy! Do you want to try again? y/n")
            userreply = readline()
            if userreply == "y"
                r = OpenAI.create_chat(key, model, conversation)
            else
                format("ChatGPT is busy! Do you want to try again?")
                break
            end
        end
        #end  
        response = r.response["choices"][begin]["message"]["content"]

        # append ChatGPT's response to the conversation history
        # TODO: the object built here might just be the same as r.response["choices"][begin]["message"]
        responseMessage = Dict("role" => "assistant", "content" => response)
        push!(conversation, responseMessage)

        format(response)
    else
        format(
            "OpenAI API key not found! Please set with `ReplGPT.setAPIkey(\"<YOUR OPENAI API KEY>\")` or set the environment variable $(api_key_name)=<YOUR OPENAI API KEY>",
        )
    end
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

__init__() = isdefined(Base, :active_repl) ? init_repl() : nothing


end # module

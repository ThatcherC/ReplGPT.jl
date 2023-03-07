module ReplGPT

import OpenAI
import ReplMaker

function call_chatgpt(s)
  r = OpenAI.create_chat(
    ENV["OPENAI_API_KEY"], 
    "gpt-3.5-turbo",
    [Dict("role" => "user", "content"=> s)]
  )

  # TODO: check for errors!
  #if !=(r.status, 200)
  #  @test false
  #end  
  r.response["choices"][begin]["message"]["content"]
end

function init()
  ReplMaker.initrepl(call_chatgpt, 
                prompt_text="ChatGPT> ",
                prompt_color = :blue, 
                start_key='}', 
                mode_name="ChatGPT_mode")
end

end # module

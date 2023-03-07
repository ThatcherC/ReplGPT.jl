module ReplGPT

import OpenAI
import ReplMaker
import Markdown

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
  response = r.response["choices"][begin]["message"]["content"]
  # TODO: check if response is valid markdown. if not, return as string
  Markdown.parse(response)
end

function init()
  ReplMaker.initrepl(call_chatgpt, 
                prompt_text="ChatGPT> ",
                prompt_color = :blue, 
                start_key='}', 
                mode_name="ChatGPT_mode");
end

end # module

require "result/result"

struct RequestBody
  def initialize(@selector : String)
  end

  getter selector
end

class ResponseBody
end

alias RawRequest = String
alias RawResponse = String

alias Request = Result(RequestBody,String)
alias Response = Result(ResponseBody,String)



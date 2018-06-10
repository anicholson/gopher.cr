require "result/result"

struct RequestBody
  def initialize(@selectors : Array(String))
  end

  getter selectors
end

struct ResponseBody
end

alias RawRequest = String
alias RawResponse = String

alias Request = Result(RequestBody, String)
alias Response = Result(ResponseBody, String)

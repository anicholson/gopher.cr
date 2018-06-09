require "result/result"

class RequestBody
end

class ResponseBody
end

alias RawRequest = String
alias RawResponse = String

alias Request = Result(RequestBody,String)
alias Response = Result(ResponseBody,String)



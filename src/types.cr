require "result/result"

class RequestBody
end

class ResponseBody
end

RawRequest = String
RawResponse = String

Request = Result(RequestBody,String)
Response = Result(ResponseBody,String)

abstract class Parser
  abstract def parse(raw : RawRequest) : Request
end

abstract class Resolver
  abstract def resolve(req : Request) : Response
end

abstract class Renderer
  abstract def render(resp : Response) : RawResponse
end

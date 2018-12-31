require "result/result"
require "./request_body"
require "./menu"

require "./resource"

module Gopher
  struct Error; end

  alias ResponseBody = Menu | Resource | Error

  alias RawRequest = String
  alias RawResponse = String

  alias Request = Result(RequestBody, String)
  alias Response = Result(ResponseBody, String)
end

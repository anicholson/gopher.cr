The server should consist of the following:

- a `Parser`, which turns the raw string into a `Request`
- a `Resolver`, which takes a `Request` and returns a `Response`

or, in type  terms:

```
type Request = Ok => RequestBody | Error => String
type alias RawRequest = String

type Response = Ok => ResponseBody | Error => String

type alias RawResponse = String

- Parser#parse : RawRequest -> Request
- Resolver#resolve : Request -> Response
- Renderer#render : Response -> RawResponse

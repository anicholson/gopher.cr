# gopher.cr [![Build Status](https://travis-ci.org/anicholson/gopher.cr.svg?branch=master)](https://travis-ci.org/anicholson/gopher.cr)

An implementation of RFC 1437, the Gopher protocol.

This repository is 2 things:

1. A library that implements the Gopher protocol
2. An example server that serves Gopher requests

## Gopher Protocol

The Gopher protocol consists of 2 phases: request & response. 

Like its relative HTTP, clients makes a request for a URI to the server, and the server responds.
Unlike HTTP, however, there are no headers, caching, MIME response types, keepalives, etc.
This makes the protocol both simpler and less featureful.

### Requests

A request to a gopher:// server consists of a single line, containing a URI (called a selector):

```
/1stuff/1and/1nonsense/0intro.txt\r\n
```

the server then resolves that request into a response, and renders it back to the client.


### Responses

A Response can be one of 3 things:

* a menu of further choices a user can make
* a resource (a file, or a another server)
* an error

A copy of the RFC that describes the protocol is [included in this repo][rfc]



## Using this library

To use this library, you need to:

1. Create a `Server` object
2. Provide it with `Resolver`(s) that instruct it how to find content
3. Tell the server to listen for requests!

A good example for how this can be done exists in `src/example.cr`

If you're looking for a more turnkey solution, check out its sister project
[Port70][port70].



# Development

Testing on the application is built using the excellent [minitest.cr][minitest].

Run tests with `crystal spec`. 

[port70]: https://github.com/anicholson/port70
[rfc]: ./rfc-1436.txt
[minitest]: https://github.com/ysbaddaden/minitest.cr

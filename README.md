# gopher.cr

An implementation of RFC 1437, the Gopher protocol.
[![Build Status](https://travis-ci.org/anicholson/gopher.cr.svg?branch=master)](https://travis-ci.org/anicholson/gopher.cr)

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
/stuff/and/nonsense/intro.txt\r\n
```

the server then resolves that request into a response, and renders it back to the client.


### Responses

A Response can be one of 3 things:

* a menu of further choices a user can make
* a resource (a file, or a another server)
* an error

A copy of the RFC that describes the protocol is [included in this repo][rfc].

[rfc]: ./rfc-1436.txt

## Using this library

TODO

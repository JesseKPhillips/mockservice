This is an implementation of a generic mock service. This allows for remotely
controlling responses to requests by posting expected responses.

A mapping file, formatted similar to OpenAPI, can be used to setup a
number of mock responses as defaults.

This uses a queue based approach for posted requests. Multiple postings can be
made for the same address and the requests to that endpoint will be servered
First In First Out. This approach does not work well for parallel testing.

# Alternatives

* Wiremock: http://wiremock.org/

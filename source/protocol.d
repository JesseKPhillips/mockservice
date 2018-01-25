module mockservice.protocol;

import vibe.data.serialization;

struct HttpRequest {
    string[string] header;
    string payload;
    @optional
    int status;
    @optional
    string method;
    @optional
    string requestURI;
}

struct Specification {
    struct PathItem {
        HttpRequest response;
    }

    PathItem[string][string] paths;
}


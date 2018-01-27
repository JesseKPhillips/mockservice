module mockservice.protocol;

import vibe.data.serialization;
import vibe.data.json;
import vibe.http.common;

struct HttpRequest {
    string[string] header;
    @optional
    string payload;
    @optional
    @name("$fileref")
    string fileref;
    @optional
    Json jsonPayload;
    @optional
    int status;
    @byName @optional
    HTTPMethod method;
    @optional
    string requestURI;
}

struct Specification {
    struct PathItem {
        HttpRequest response;
    }

    PathItem[string][string] paths;
}


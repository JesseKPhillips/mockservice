import vibe.vibe;

import std.experimental.logger : trace;

import mockservice.protocol;

void main()
{
    auto router = new URLRouter;
    router.any("/MockAddress/*", &handleRequest);
    setLogLevel(LogLevel.trace);
	listenHTTP(":8080", router);
	runApplication();
}

void handleRequest(HTTPServerRequest req, HTTPServerResponse res)
{
    import std.file;
    auto spec = readText("mockResponse.json");
    auto j = deserializeJson!Specification(spec);
    auto router = new URLRouter;
    foreach(path, item; j.paths) {
        foreach(method, req; item) {
            trace(method);
            router.addRoute(method, path, req.response);
        }
    }
    router.handleRequest(req, res);
    trace(router.getAllRoutes());
}

auto addRoute(URLRouter router, string method, string path, HttpRequest req) {
    import std.traits;
    import std.conv;
    import std.string;
    foreach(m; EnumMembers!HTTPMethod){
        if(m.to!string.toLower() == method.toLower()) {
            router.match(m, path, handleRequest(req));
        }
    }
}

auto handleRequest(HttpRequest r) {
    return (HTTPServerRequest req, HTTPServerResponse res) {
        foreach(k, v; r.header)
            res.headers[k] = v;
        res.writeBody(r.payload);
        res.statusCode = r.status;
    };
}

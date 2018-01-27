module mockservice.mockaddress;

import std.range;

import vibe.d;

import mockservice.protocol;

package Specification[] route;
package HttpRequest[] history;

void resetRoute(string defaultRoute) {
    auto spec = deserializeJson!Specification(defaultRoute);
    if(route.empty)
        route = [spec];
    else
        route.front = spec;
}

void handleRequest(HTTPServerRequest req, HTTPServerResponse res)
{
    //Store Request
    history.length += 1;
    history.back.payload = req.bodyReader.readAllUTF8();
    history.back.requestURI = req.requestURI;
    history.back.method = req.method;
    foreach(k, v; req.headers)
        history.back.header[k] = v;

    //Return planned response
    Specification spec;
    if(route.length > 1) {
        spec = moveBack(route);
        route.popBack();
    } else
        spec = route.front;
    auto router = buildRouter(spec, "");
    router.handleRequest(req, res);
}

auto buildRouter(Specification spec, string basePath) {
    auto router = new URLRouter;
    foreach(path, item; spec.paths) {
        foreach(method, req; item) {
            import std.path;
            import std.file;
            auto fileref = basePath.buildPath(req.response.fileref);
            if(exists(fileref))
                req.response.payload = readText(fileref);
            else if(req.response.jsonPayload != Json.undefined)
                req.response.payload = req.response.jsonPayload.to!string;
            router.addRoute(method, path, req.response);
        }
    }
    return router;
}

auto addRoute(URLRouter router, string method, string path, HttpRequest req) {
    import std.traits;
    import std.conv;
    import std.string;
    foreach(m; EnumMembers!HTTPMethod){
        if(m.to!string.toLower() == method.toLower()) {
            router.match(m, path, handleRequest(req));
            return;
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

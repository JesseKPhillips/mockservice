module mockservice.mockcontroller;

import std.range;

import vibe.d;

import mockservice.protocol;

@path("/MockController")
interface Controller {
    @method(HTTPMethod.POST)
    @safe void postMockResponse(Specification res);
    @method(HTTPMethod.PUT)
    @safe void putMockResponse(Specification res);

    @method(HTTPMethod.GET)
    @queryParam("count", "count")
    @safe HttpRequest[] getHistory(int count = 0);
    @method(HTTPMethod.DELETE)
    @safe void deleteHistory();
}

class SimpleController : Controller {
    import mockservice.mockaddress;
    @safe void postMockResponse(Specification res) {
        route ~= res;
    }

    @safe void putMockResponse(Specification res) {
        if(route.empty)
            route = [res];
        else
            route.front = res;
        route = route[0..1];
    }

    @safe HttpRequest[] getHistory(int count = 0) {
        if(count == 0)
            return history;
        return history[$-count..$];
    }

    @safe void deleteHistory() {
        history.length = 0;
    }
}

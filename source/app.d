import vibe.d;

import std.experimental.logger : trace;
import std.getopt;
import std.path;
import std.file;

import mockservice.protocol;
import mockservice.mockaddress;
import mockservice.mockcontroller;

void main(string[] args)
{
    resetRoute(readText(buildPath(args[0].dirName, "mockResponse.json")));
    auto router = new URLRouter;
    router.any("/MockAddress/*", &mockservice.mockaddress.handleRequest);
    router.registerRestInterface(new SimpleController, MethodStyle.pascalCase);
    setLogLevel(LogLevel.trace);
	listenHTTP(":8080", router);
	runApplication();
}

async function handleRequest(request) {

    var output = {};

    output.worker = 'child';
    output.url = request.url;
    output.cf = request.cf;
    output.requestHeaders = {};

    for (var value of request.headers.entries()) {
        output.requestHeaders[value[0]] = value[1]
    }

    var headers = new Headers();
    headers.set('Content-Type', 'application/json');

    return new Response(JSON.stringify(output), {
        "headers": headers
    });

}

addEventListener('fetch', event => {
    event.respondWith(handleRequest(event.request))
})
async function handleRequest(request) {
    var childResponse = await fetch("https://child.saas.obez.uk/parent-to-child-subrequest");

    var childData = await childResponse.json();

    var output = {};

    output.worker = 'parent';
    output.url = request.url;
    output.cf = request.cf;
    output.requestHeaders = {};

    for (var value of request.headers.entries()) {
        output.requestHeaders[value[0]] = value[1]
    }

    var headers = new Headers();
    headers.set('Content-Type', 'application/json');

    output.child = childData;

    var output = {
        "parent": output
    }

    return new Response(JSON.stringify(output), {
        "headers": headers
    });

}

addEventListener('fetch', event => {
    event.respondWith(handleRequest(event.request))
})
const http=require('http');
const os=require('os');
const port=8090;

console.log(`server starting on port ${port}...`);

var handler= function(request,response){
    console.log("Received request from"+request.connection.remoteAddress);
    response.writeHead(200);
    response.end("you have hit   "+os.hostname()+"\n");

}

var www=http.createServer(handler);
www.listen(port);
public with sharing class ScannedItemWSMock implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest request){
        
        HttpResponse res=new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        String body = '';
        res.setBody(body);
        res.setStatusCode(200);
        return res;
    }
}
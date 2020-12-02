import ballerina/io;
import ballerina/test;
import ballerina/http;

http:Client httpClientEndpoint = new ("http://localhost:9090/data");

type TestCustomer record {|

    int Id;
    string Name;
    string Email;

|};

TestCustomer myCustomer = {
    Id : 206,
    Name : "Tony Stark",
    Email: "stark@gmail.com"
};

@test:Config{

}

function testAddCustomer (){
    http:Request req = new;

    json jsonRequest = {"Id" : myCustomer.Id, "Name" : myCustomer.Name, "Email" : myCustomer.Email};

    req.setJsonPayload(jsonRequest);
    var res = httpClientEndpoint -> post("/customer", req);
    if(res is http:Response){
        var jsonResponse = res.getJsonPayload();

        io:println("Status Code : ", res.statusCode, " Message : ", jsonResponse.toString());

    }
    else{
        io:println("Test Request Failed");
    }

}

@test:Config{
    dependsOn:["testAddCustomer"]
}

function testGetCustomer(){
    var res = httpClientEndpoint -> get("/customer/" + myCustomer.Id.toString());

    if(res is http:Response){
        var jsonResponse = res.getJsonPayload();
        if(jsonResponse is json){
            io:println("Status Code : ", res.statusCode, " Message : ", jsonResponse.toString());
        }
        else{
            io:println("Status Code : ", res.statusCode, " Message : Invalid payload received");
        }
    }
    else{
        io:println("Test Request Failed");
    }
}

@test:Config{
    dependsOn:["testAddCustomer"]
}

function testUpdateCustomer(){
    http:Request req = new;

    json jsonRequest = {"Id" : myCustomer.Id, "Name" : myCustomer.Name, "Email" : "ironman@gmail.com"};

    req.setJsonPayload(jsonRequest);
    var res = httpClientEndpoint -> put("/customer", req);
    if(res is http:Response){
        var jsonResponse = res.getJsonPayload();

        if(res.statusCode == 200){
            io:println("Status Code : ", res.statusCode, " Message : ", jsonResponse.toString());
        }
        else{
            io:println("Status Code : ", res.statusCode, " Message : Invalid payload received");
        }
    }
    else{
        io:println("Test Request Failed");
    }
}

import ballerina/io;
import ballerina/test;


    DBConfiguration config = {
        username: "root",
        password: "1234",
        url: "http://localhost:3306"
    };

    DBClient dbClient = new(config);

@test:Config{}
function testRetrieveById(){

    json|error result = dbClient.getCustomerbyId(1);

    if result is json{
            io:println(result.toString());

    }else{
        test:assertFail(result.message());
    }
}
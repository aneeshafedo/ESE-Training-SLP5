import ballerina/http;
import ballerina/'log;
import ballerina/sql;
import ballerina/io;
import ballerina/java.jdbc;
import ballerina/lang.'int as ints;


jdbc:Client customerDB = check new ("jdbc:mysql://localhost:3306/CustomerDB?serverTimezone=UTC", "testuser", "1234");

type Customer record {|
    int Id;
    string Name;
    string Email;
|};

listener http:Listener httpListenerDB = new(9090);

@http:ServiceConfig {
    basePath: "/data"
}

service CustomerService on httpListenerDB{
    @http:ResourceConfig {

        methods: ["POST"],
        path: "/customer"
    }

    resource function addCustomer(http:Caller caller, http:Request req){
        http:Response response = new;
        var payloadDBJson  = req.getJsonPayload();

        if(payloadDBJson is json){
            Customer|error customerData = payloadDBJson.cloneWithType(Customer);
            log:printDebug(customerData.toString());
            io:println(customerData.toString());

            if(customerData is Customer){

                sql:ParameterizedQuery insertQuery =  `INSERT INTO CustomerDetails (Id,Name,Email) VALUES (${customerData.Id},${customerData.Name},${customerData.Email})`;

                var result = customerDB -> execute(<@untainted>insertQuery);

                if(result is sql:ExecutionResult){
                    response.statusCode = 201;
                    json payload = { status: "Customer Added.", customerId: customerData.Id };
                    response.setPayload(<@untainted>payload);
                }
                else{
                    response.statusCode = 400;
                    json payload = { status: "Customer Not Added.", Error: result.toString() };
                    response.setPayload(<@untainted>payload);
                }
            }
            else{
                response.statusCode = 400;
                response.setPayload("Error : Invalid Data");
            }
            var result = caller -> respond(response);
            if result is error {
                log:printError("Error sending response", err = result);
            }

        }
    }

    @http:ResourceConfig {
        methods: ["GET"],
        path: "/customer/{customerId}"
    }

    resource function getcustomer (http:Caller httpCaller, http:Request request, string customerId) returns @untainted error?{
        
        http:Response response = new;

        var customerIdDB = ints:fromString(customerId);
        io:println("id : ", customerIdDB);

        if customerIdDB is int{

            sql:ParameterizedQuery getQuery = `SELECT * FROM CustomerDetails WHERE Id = ${customerIdDB}`;


            stream<Customer, sql:Error> resultStream = <stream<Customer, sql:Error>> customerDB -> query(<@untainted>getQuery, Customer);

            error? e = resultStream.forEach(function(Customer cus) {
                io:println("Customer : ", cus);
                json|error retrivedCustomer = cus.cloneWithType(json);

                if(retrivedCustomer is json){
                        response.statusCode = 200;
                        json payload = { status: "Customer Retrieved.", customerData: retrivedCustomer };
                        response.setPayload(<@untainted>payload);
                    }
                else{
                    response.statusCode = 400;
                    json payload = {Error : "Invalid Data", Message :  <@untainted>retrivedCustomer.toString()};
                    response.setPayload(payload);
                }    
            });

        }
        else{
            response.statusCode = 400;
            response.setPayload("Error: Customer Id is invalid");
            
        }

        var result = httpCaller -> respond(response);
        if result is error {
            log:printError("Error sending response", err = result);
        }

    }

    @http:ResourceConfig {
        methods: ["PUT"],
        path: "/customer"
    }

    resource function updateCustomerDetails(http:Caller caller, http:Request req) {
        http:Response response = new;
        

        var payloadDBJson  = req.getJsonPayload();

        if(payloadDBJson is json){
            Customer|error customerData = payloadDBJson.cloneWithType(Customer);
            log:printDebug(customerData.toString());
            io:println(customerData.toString());


            io:println("existingCustomer :", customerData);

            if (customerData is Customer){
                int|error customerIdDB = customerData.Id;
                if customerIdDB is int {
                    sql:ParameterizedQuery updateQuery =  `UPDATE CustomerDetails SET Name = ${customerData.Name}, Email = ${customerData.Email} WHERE Id = ${customerIdDB}`;

                    var result = customerDB->execute(<@untainted>updateQuery);

                    if (result is sql:ExecutionResult){
                        response.statusCode = 200;
                        json payload = { status: "Customer Updated.", customerId: customerData.Id };
                        response.setPayload(<@untainted>payload);
                    }
                    else{
                        response.statusCode = 400;
                        json payload = { status: "Customer Updated.", customerId: customerData.Id };
                        response.setPayload(<@untainted>payload);
                    }

                }
                else{
                    response.statusCode = 400;
                    response.setPayload("Error: Invalid customer ID");
                }

            }
            else{
                response.statusCode = 400;
                response.setPayload("Error : Invalid Customer Data");
            }

            
        }
        else {
            response.statusCode = 400;
            response.setPayload("Error: Invalid payload received");
        }

        var result = caller -> respond(response);
        if result is error {
            log:printError("Error sending response", err = result);
        }
    }


}
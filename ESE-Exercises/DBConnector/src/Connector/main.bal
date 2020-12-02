import ballerina/http;

public type DBConfiguration record {|
   string username;
   string password;
   string url; 
|};

public type Customer record {|
    int Id;
    string Name;
    string Email;
|};


public class DBClient {
    public string url;
    public string username;
    public string password;
    http:Client dbClient;
    
    public function init(DBConfiguration conf){
        self.username = conf.username;
        self.password = conf.password;
        self.url = conf.url;
        self.dbClient = new(self.url);
    }

    public function getCustomerbyId(int customerId) returns @tainted json|error {
        http:Response? result = new;

        result = <http:Response> self.dbClient -> get(string `/data/customers/${customerId}`);

        if result is http:Response{
            
            json payload = <json> result.getJsonPayload();
            return payload;
            
        }
        else{
            return result;
        }
    }
}
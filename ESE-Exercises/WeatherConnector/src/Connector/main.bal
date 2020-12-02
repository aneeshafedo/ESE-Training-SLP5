import ballerina/io;
import ballerina/http;

public type OpenWeatherConfiguration record {
    string appid;
    string url;
};

type APICallErrorData record {|
   string code;
   string city;
   //string message; 
|};

public const API_CALL_FAILED = "Api Call Failed!";
public const NOT_FOUND = "Not Found";

type APICallforSingleEntryError error<APICallErrorData>;



public type WeatherClient client object {
    string appid;
    string url;
    http:Client weatherClient;
    
    public remote function getWeatherByCity(string city,string? statecode, boolean isByName) returns @tainted json|error;
    
};

public class WeatherClass {
    *WeatherClient;

    function init(OpenWeatherConfiguration conf){
        self.appid = conf.appid;
        self.url = conf.url;
        self.weatherClient = new(self.url);
    }

    public function getWeatherByCity(string city,string? statecode, boolean isByName) returns @tainted json|error{
        http:Response? result = new;
        io:println("City : ", city, " api key : ", self.appid);

        if(isByName){
            if (statecode is string && city != "" && statecode != ""){
                result = <http:Response> self.weatherClient ->get(string `/weather?q=${city},${statecode}&appid=${self.appid}`);
            }
            else if(city != ""){
                result = <http:Response> self.weatherClient ->get(string `/weather?q=${city}&appid=${self.appid}`);
            }
            else{
                result = ();
            }
        }
        else{
            if(city != ""){
                result = <http:Response> self.weatherClient ->get(string `/weather?id=${city}&appid=${self.appid}`);
            }
            else{
                result = ();
            }
        }

        

        if result is http:Response{
            if result.statusCode == 200{
                json payload = <json> result.getJsonPayload();
                json[] weatherResult = <json []> payload.weather;

                io:println("result : ", weatherResult);
                return weatherResult[0].description;

            }
            else{
                
                json|error payload = <json> result.getJsonPayload();
                if(payload is json){
                    io:println("Error : ", payload.message);

                    return APICallforSingleEntryError(payload.message.toString(), code = payload.cod.toString(), city = city);
                }
                else{
                    return error(NOT_FOUND);
                }
                
                
            }
        }
        else{
            io:println("Error : ",result);
            return error(API_CALL_FAILED);
            
        }

    }

    public function getWeatherofMultipleCities(string  countries)returns @tainted json|error{

        http:Response ? result = new;

        if (countries.length() > 0){
            result = <http:Response> self.weatherClient ->get(string `/group?id=${countries}&appid=${self.appid}`);
        }
        else{
            result = ();
        }

        if result is http:Response{
            if result.statusCode == 200{
                json payload = <json> result.getJsonPayload();
                json[] weatherResult = <json []> payload.list;

                return weatherResult;

            }
            else{
                
                json|error payload = <json> result.getJsonPayload();
                if(payload is json){
                    io:println("Error : ", payload.message);

                    return APICallforSingleEntryError(payload.message.toString(), code = payload.cod.toString(), city = countries);
                }
                else{
                    return error(NOT_FOUND);
                }
                
                
            }
        }
        else{
            io:println("Error : ",result);
            return error(API_CALL_FAILED);
            
        }

    }

}




import ballerina/io;
import ballerina/test;

OpenWeatherConfiguration testConf = {
    appid: "69b310f8d3233e106c8640b483bdea0e",
    url: "http://api.openweathermap.org/data/2.5"
};

string countryName = "London";
string statecode = "uk";
string countryId = "2172797";
string cities = "524901, 703448";

@test:Config{

}

function testGetWeatherByCountryName(){
    
    WeatherClass myclient = new WeatherClass(testConf);
    
    json|error result = myclient.getWeatherByCity(countryName, (), true);
    
    if result is json{
            io:println("testGetWeatherByCountryName : ",result);

    }else{
        io:println(result.message());
        test:assertFail(result.toString());
    }
}
@test:Config{

}
function testGetWeatherByCountryId(){
    
    WeatherClass myclient = new WeatherClass(testConf);
    
    json|error result = myclient.getWeatherByCity(countryId, (), false);
    
    if result is json{
        io:println("testGetWeatherByCountryId : ", result);

    }else{
        io:println("testGetWeatherByCountryId : ",result.message());
        test:assertFail(result.toString());
    }
}
@test:Config{

}
function testGetWeatherByStateName(){
    
    WeatherClass myclient = new WeatherClass(testConf);
    
    json|error result = myclient.getWeatherByCity(countryName, statecode, true);
    
    if result is json{
            io:println("testGetWeatherByStateName : ",result);

    }else{
        io:println(result.message());
        test:assertFail(result.toString());
    }
}

@test:Config{

}
function testGetWeatherofMultipleCities(){
    WeatherClass myclient = new WeatherClass(testConf);
    
    json|error result = myclient.getWeatherofMultipleCities(cities);
    
    if result is json{
            io:println("testGetWeatherofMultipleCities : ",result);

    }else{
        io:println(result.message());
        test:assertFail(result.toString());
    }
}






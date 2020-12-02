import ballerina/io;

public function main (string... args) returns error? {
    string filename = args[0];

    io:println("File name : ", filename);

    FileInputStream|error fileInputStream = newFileInputStream3(filename);

    if fileInputStream is error {
        io:println("The file '"+filename+"' cannot be loaded. Reason: " + fileInputStream.message());
    }

    else{
        Yaml yaml = newYaml1();
        InputStream inputStream = new(fileInputStream.jObj);
        Object mapobj = yaml.load(inputStream);
        io:println(mapobj); 

    }
    

    
}

import ballerina/io;
type Person object {
    public int age;
    public string firstName;
    public string lastName;

    function getFullName() returns string;

    function checkAndModifyAge(int condition, int a);
};
class Employee {
    public int age;
    public string firstName;
    public string lastName;

    function init(int age, string firstName, string lastName) {
        self.age = age;
        self.firstName = firstName;
        self.lastName = lastName;
    }

    function getFullName() returns string {
        return self.firstName + " " + self.lastName;
    }

    function checkAndModifyAge(int condition, int a) {
        if (self.age < condition) {
            self.age = a;
        }
    }
}
public function main() {

    Person p = new Employee(5, "John", "Doe");
    io:println(p.getFullName());
    
    p.checkAndModifyAge(10, 50);

    io:println(p.age);
}
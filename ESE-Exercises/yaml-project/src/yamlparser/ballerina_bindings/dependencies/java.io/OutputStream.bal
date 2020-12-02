// This is an empty Ballerina object autogenerated to represent the `java.io.OutputStream` Java class.
//
// If you need the implementation of this class generated, please use the following command.
//
// $ ballerina bindgen [(-cp|--classpath) <classpath>...] [(-o|--output) <output>] (<class-name>...)
//
// E.g. $ ballerina bindgen java.io.OutputStream


import ballerina/java;

# Ballerina object mapping for Java abstract class `java.io.OutputStream`.
#
# + _OutputStream - The field that represents this Ballerina object, which is used for Java subtyping.
# + _Closeable - The field that represents the superclass object `Closeable`.
# + _AutoCloseable - The field that represents the superclass object `AutoCloseable`.
# + _Object - The field that represents the superclass object `Object`.
# + _Flushable - The field that represents the superclass object `Flushable`.
@java:Binding {
    'class: "java.io.OutputStream"
}
class OutputStream {

    *java:JObject;

    OutputStreamT _OutputStream = OutputStreamT;
    CloseableT _Closeable = CloseableT;
    AutoCloseableT _AutoCloseable = AutoCloseableT;
    ObjectT _Object = ObjectT;
    FlushableT _Flushable = FlushableT;

    # The init function of the Ballerina object mapping `java.io.OutputStream` Java class.
    #
    # + obj - The `handle` value containing the Java reference of the object.
    function init(handle obj) {
        self.jObj = obj;
    }

    # The function to retrieve the string value of a Ballerina object mapping a Java class.
    #
    # + return - The `string` form of the object instance.
    function toString() returns string {
        return java:jObjToString(self.jObj);
    }
}


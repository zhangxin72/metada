#include "MyClass.hpp"
#include <iostream>

/**
 * @brief Main entry point
 * @return int Exit code
 */
int main() {
    MyClass obj;
    obj.doSomething();
    std::cout << "Hello, World!" << '\n';
    return 0;
}
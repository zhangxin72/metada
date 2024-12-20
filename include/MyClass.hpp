#ifndef MYCLASS_HPP
#define MYCLASS_HPP

/**
 * @brief A simple demonstration class
 */
class MyClass {
public:
    /// Default constructor
    MyClass();

    /**
     * @brief Performs an example operation
     */
    void doSomething();

private:
    int m_value{0};  ///< Internal value
};
#endif

// Copyright © 2020 ShawnJames. All rights reserved.
// Created by Shawn James
// GuardDebugOperator.swift

/// GuardDebugOperator
infix operator ><

/// Used in guard statements to print an error message before failing.
/// ```
/// guard let middleName = middleName >< "Missing middle name" else {
/// ```
/// - Parameters:
///   - lhs: The optional that is being unwrapped in the guard statement
///   - rhs: The message that you would like to print if the guard statement fails
/// - Returns: The unwrapped object or nil
func >< <T>(lhs: T?, rhs: String) -> T? {
    if lhs == nil { print(rhs) }
    return lhs
}

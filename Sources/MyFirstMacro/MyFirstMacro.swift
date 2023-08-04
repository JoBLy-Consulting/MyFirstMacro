// The Swift Programming Language
// https://docs.swift.org/swift-book

/// A macro that validates a string expression as URL

import Foundation

@freestanding(expression)
public macro IsURL(_ value: String) -> URL = #externalMacro(module: "MyFirstMacroMacros", type: "IsURLMacro")

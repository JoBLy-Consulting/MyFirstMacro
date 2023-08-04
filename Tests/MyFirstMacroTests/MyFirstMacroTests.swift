import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(MyFirstMacroMacros)
import MyFirstMacroMacros

let testMacros: [String: Macro.Type] = [
    "IsURL": IsURLMacro.self,
]
#endif

final class MyFirstMacroTests: XCTestCase {
    func testIsURLMacro() throws {
        #if canImport(MyFirstMacroMacros)
        assertMacroExpansion(
            """
            #IsURL(\"https://consulting.myjobly.fr\")
            """,
            expandedSource: """
            URL(string: \"https://consulting.myjobly.fr\")!
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}

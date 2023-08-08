import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Implementation of the `IsURL` macro, which evaluates
/// a String value as a valid URL and return the unwrapped value
/// and the source code that produced the value.
///
import Foundation
enum URLMacroErrors: Error, CustomStringConvertible {
    case incorrectExpressionValue
    case incorrectURL
    
    var description: String {
        switch self {
        case .incorrectExpressionValue: return "The expression sent is not a valid IsURLMAcro value"
        case .incorrectURL: return "The URL sent has an incorrect format"
        }
    }
}

public struct IsURLMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        guard
            let urlExpr = node.argumentList.first?.expression,
            let segments = urlExpr.as(StringLiteralExprSyntax.self)?.segments,
            let urlSegment = segments.first?.as(StringSegmentSyntax.self)
        else {
            throw URLMacroErrors.incorrectExpressionValue
        }
        
        guard let _ = URL(string: urlSegment.content.text) else {
            throw URLMacroErrors.incorrectURL
        }
        
        return "URL(string: \(urlExpr))!"
    }
}

@main
struct MyFirstMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        IsURLMacro.self,
    ]
}

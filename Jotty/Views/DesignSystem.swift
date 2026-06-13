import SwiftUI

extension Color {
    static let jottyPaper = Color(red: 0.97, green: 0.95, blue: 0.90)
    static let jottyInk = Color(red: 0.13, green: 0.12, blue: 0.10)
    static let jottySage = Color(red: 0.45, green: 0.58, blue: 0.49)
    static let jottyAmber = Color(red: 0.84, green: 0.56, blue: 0.25)
    static let jottyClay = Color(red: 0.69, green: 0.38, blue: 0.31)
    static let jottyCard = Color.white.opacity(0.72)
}

extension NoteMood {
    var tint: Color {
        switch self {
        case .spark: .jottyAmber
        case .calm: .jottySage
        case .plan: .jottyClay
        }
    }
}

extension Date {
    var jottyRelativeLabel: String {
        formatted(.relative(presentation: .named))
    }
}

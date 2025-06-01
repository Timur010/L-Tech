import Foundation

extension String {
    func digitsOnly() -> String {
        return self.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
    }
}

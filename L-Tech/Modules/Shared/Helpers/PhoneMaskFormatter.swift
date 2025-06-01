import Foundation

struct PhoneMaskFormatter {
    static func apply(mask: String, to input: String) -> String {
        let numbers = input.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
        let maskCountryCode = extractCountryCode(from: mask)

        var trimmedNumbers = numbers
        if numbers.hasPrefix(maskCountryCode) {
            trimmedNumbers = String(numbers.dropFirst(maskCountryCode.count))
        }

        var result = ""
        var index = trimmedNumbers.startIndex

        for ch in mask {
            if index == trimmedNumbers.endIndex { break }
            if ch == "X" || ch == "Х" {
                result.append(trimmedNumbers[index])
                index = trimmedNumbers.index(after: index)
            } else {
                result.append(ch)
            }
        }

        return result
    }

    static func extractCountryCode(from mask: String) -> String {
        let pattern = "^\\+(\\d+)"
        if let regex = try? NSRegularExpression(pattern: pattern),
           let match = regex.firstMatch(in: mask, range: NSRange(mask.startIndex..., in: mask)),
           let range = Range(match.range(at: 1), in: mask) {
            return String(mask[range])
        }
        return ""
    }
}

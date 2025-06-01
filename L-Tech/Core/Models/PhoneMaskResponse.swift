import Foundation

struct PhoneMaskResponse: Decodable {
    let phoneMask: String
}

struct AuthResponse: Decodable {
    let success: Bool
}

struct Post: Decodable {
    let id: String
    let title: String
    let text: String
    let image: String
    let sort: Int
    let date: String
    
    var fullImageURL: URL? {
            return URL(string: "http://dev-exam.l-tech.ru" + image)
    }
}

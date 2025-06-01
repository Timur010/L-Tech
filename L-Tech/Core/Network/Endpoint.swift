import Alamofire

enum Endpoint {
    case phoneMask
    case login(phone: String, password: String)
    case posts

    var url: String {
        switch self {
        case .phoneMask:
            return "http://dev-exam.l-tech.ru/api/v1/phone_masks"
        case .login:
            return "http://dev-exam.l-tech.ru/api/v1/auth"
        case .posts:
            return "http://dev-exam.l-tech.ru/api/v1/posts"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .phoneMask, .posts:
            return .get
        case .login:
            return .post
        }
    }

    var parameters: Parameters? {
        switch self {
        case .login(let phone, let password):
            return [
                "phone": phone,
                "password": password
            ]
        default:
            return nil
        }
    }

    var headers: HTTPHeaders? {
        switch self {
        case .login:
            return ["Content-Type": "application/x-www-form-urlencoded"]
        default:
            return nil
        }
    }
}

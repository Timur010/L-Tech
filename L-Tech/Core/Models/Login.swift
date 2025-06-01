
enum Login {
    enum Request {
        struct LoginUser {
            let phone: String
            let password: String
        }
    }

    enum Response {
        struct AuthResult {
            let success: Bool
        }
    }

    enum ViewModel {
        struct DisplayLoginResult {
            let isSuccess: Bool
        }
    }
}

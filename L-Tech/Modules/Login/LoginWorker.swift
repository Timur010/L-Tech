import Foundation
import Alamofire

final class LoginWorker {
    var currentPhoneMask: String = ""
    private let keychainStorage = LoginStorageService()
    let networkService: NetworkServiceProtocol = NetworkService()

    func login(phone: String, password: String, completion: @escaping (Bool) -> Void) {
        networkService.request(.login(phone: phone, password: password)) { (result: Result<AuthResponse, AFError>) in
            switch result {
            case .success(let response):
                completion(response.success)
            case .failure:
                completion(false)
            }
        }
    }

    func fetchPhoneMask(completion: @escaping (String) -> Void) {
        networkService.request(.phoneMask) { (result: Result<PhoneMaskResponse, AFError>) in
            switch result {
            case .success(let response):
                self.currentPhoneMask = response.phoneMask
                completion(response.phoneMask)
            case .failure:
                completion("+X (XXX) XXX-XXXX")
            }
        }
    }

    func saveCredentials(phone: String, password: String) {
        keychainStorage.saveCredentials(phone: phone, password: password, mask: currentPhoneMask)
    }

    func loadStoredCredentials() -> (phone: String, password: String)? {
        keychainStorage.loadCredentials(for: currentPhoneMask)
    }
}

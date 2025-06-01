import Foundation

final class LoginStorageService {
    private let keychain = KeychainService.shared

    enum Keys {
        static let phoneRaw = "user_phone_raw"
        static let phoneMask = "user_phone_mask"
        static let password = "user_password"
    }

    func saveCredentials(phone: String, password: String, mask: String) {
        keychain.save(key: Keys.phoneRaw, value: phone)
        keychain.save(key: Keys.phoneMask, value: mask)
        keychain.save(key: Keys.password, value: password)
    }

    func loadCredentials(for mask: String) -> (phone: String, password: String)? {
        guard let storedMask = keychain.get(key: Keys.phoneMask),
              let phone = keychain.get(key: Keys.phoneRaw),
              !phone.isEmpty,
              storedMask == mask,
              let password = keychain.get(key: Keys.password) else {
            return nil
        }
        return (phone, password)
    }
}

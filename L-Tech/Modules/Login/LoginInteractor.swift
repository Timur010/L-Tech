import Foundation

protocol LoginBusinessLogic {
    func login(request: Login.Request.LoginUser)
    func loadPhoneMask()
    func prefillStoredCredentials()
}

final class LoginInteractor: LoginBusinessLogic {
    var presenter: LoginPresentationLogic?
    private let worker = LoginWorker()

    func login(request: Login.Request.LoginUser) {
        worker.login(phone: request.phone, password: request.password) { [weak self] success in
            if success {
                self?.worker.saveCredentials(phone: request.phone, password: request.password)
            }
            let response = Login.Response.AuthResult(success: success)
            self?.presenter?.presentLoginResult(response: response)
        }
    }

    func loadPhoneMask() {
        worker.fetchPhoneMask { [weak self] mask in
            self?.presenter?.presentPhoneMask(mask: mask)
        }
    }

    func prefillStoredCredentials() {
        if let creds = worker.loadStoredCredentials() {
            presenter?.presentStoredCredentials(phone: creds.phone, password: creds.password)
        }
    }
}

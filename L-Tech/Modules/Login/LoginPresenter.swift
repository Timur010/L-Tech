import Foundation

protocol LoginPresentationLogic {
    func presentLoginResult(response: Login.Response.AuthResult)
    func presentPhoneMask(mask: String)
    func presentStoredCredentials(phone: String, password: String)
}

final class LoginPresenter: LoginPresentationLogic {
    weak var viewController: LoginDisplayLogic?

    func presentLoginResult(response: Login.Response.AuthResult) {
        let viewModel = Login.ViewModel.DisplayLoginResult(isSuccess: response.success)
        viewController?.displayLoginResult(viewModel: viewModel)
    }

    func presentPhoneMask(mask: String) {
        viewController?.displayPhoneMask(mask: mask)
    }

    func presentStoredCredentials(phone: String, password: String) {
        viewController?.displayStoredCredentials(phone: phone, password: password)
    }
}


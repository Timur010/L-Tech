import UIKit
import SnapKit

protocol LoginDisplayLogic: AnyObject {
    func displayLoginResult(viewModel: Login.ViewModel.DisplayLoginResult)
    func displayPhoneMask(mask: String)
    func displayStoredCredentials(phone: String, password: String)
}

final class LoginViewController: UIViewController {

    var interactor: LoginBusinessLogic?
    var router: LoginRoutingLogic?

    private let logoImageView = UIImageView(image: UIImage(named: "logo"))
    private let titleLabel = LTEXLabel(style: .title3bold)
    private let phoneLabel = LTEXLabel(style: .bodySemibold)
    private let phoneTextField = UITextField()
    private let passwordLabel = LTEXLabel(style: .bodySemibold)
    private let passwordFieldWithError = LTEXTextFieldWithError()
    private let showPasswordButton = UIButton(type: .system)
    private let loginButton = UIButton(type: .system)

    private var phoneMask: String = "+X (XXX) XXX-XXXX"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupUI()
        setupLayout()
        setupActions()

        interactor?.loadPhoneMask()
        phoneTextField.delegate = self
        passwordFieldWithError.textField.isSecureTextEntry = true
    }

    private func setupUI() {
        titleLabel.text = "Вход в аккаунт"
        titleLabel.textAlignment = .center

        phoneLabel.text = "Телефон"
        phoneTextField.placeholder = "+7"
        phoneTextField.keyboardType = .phonePad
        phoneTextField.borderStyle = .roundedRect

        passwordLabel.text = "Пароль"

        showPasswordButton.setImage(UIImage(named: "property_close"), for: .normal)
        showPasswordButton.tintColor = .lightGray

        loginButton.setTitle("Войти", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = .lightBLueCustom
        loginButton.layer.cornerRadius = Layout.cornerRadius
        loginButton.isEnabled = false
    }

    private func setupLayout() {
        [
            logoImageView, titleLabel,
            phoneLabel, phoneTextField,
            passwordLabel, passwordFieldWithError,
            showPasswordButton, loginButton
        ].forEach { view.addSubview($0) }

        logoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(Layout.logoTop)
            $0.centerX.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(Layout.titleTop)
            $0.centerX.equalToSuperview()
        }

        phoneLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Layout.sectionTop)
            $0.leading.equalToSuperview().offset(Layout.sideInset)
        }

        phoneTextField.snp.makeConstraints {
            $0.top.equalTo(phoneLabel.snp.bottom).offset(Layout.labelToFieldSpacing)
            $0.leading.trailing.equalToSuperview().inset(Layout.sideInset)
            $0.height.equalTo(Layout.fieldHeight)
        }

        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(phoneTextField.snp.bottom).offset(Layout.fieldSpacing)
            $0.leading.equalTo(phoneTextField)
        }

        passwordFieldWithError.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(Layout.labelToFieldSpacing)
            $0.leading.trailing.equalTo(phoneTextField)
        }

        showPasswordButton.snp.makeConstraints {
            $0.centerY.equalTo(passwordFieldWithError.textField)
            $0.trailing.equalTo(passwordFieldWithError.textField).inset(Layout.passwordIconTrailing)
            $0.size.equalTo(CGSize(width: 24, height: 24))
        }

        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwordFieldWithError.snp.bottom).offset(Layout.loginTopSpacing)
            $0.leading.trailing.equalTo(passwordFieldWithError)
            $0.height.equalTo(Layout.loginButtonHeight)
        }
    }

    private func setupActions() {
        phoneTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordFieldWithError.textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        showPasswordButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }

    @objc private func togglePasswordVisibility() {
        let tf = passwordFieldWithError.textField
        tf.isSecureTextEntry.toggle()
        let imageName = tf.isSecureTextEntry ? "property_close" : "property_open"
        showPasswordButton.setImage(UIImage(named: imageName), for: .normal)
    }

    @objc private func loginButtonTapped() {
        guard let rawPhone = phoneTextField.text?.digitsOnly(),
              let password = passwordFieldWithError.textField.text else { return }

        passwordFieldWithError.hideError()
        interactor?.login(request: .init(phone: rawPhone, password: password))
    }

    @objc private func textDidChange() {
        let isPhoneValid = !(phoneTextField.text?.isEmpty ?? true)
        let isPasswordValid = !(passwordFieldWithError.textField.text?.isEmpty ?? true)

        loginButton.isEnabled = isPhoneValid && isPasswordValid
        loginButton.backgroundColor = loginButton.isEnabled ? .blueCustom : .lightBLueCustom

        if isPasswordValid {
            passwordFieldWithError.hideError()
        }
    }
}

extension LoginViewController: LoginDisplayLogic {
    func displayPhoneMask(mask: String) {
        phoneMask = mask
        phoneTextField.text = ""
        phoneTextField.placeholder = "+ \(PhoneMaskFormatter.extractCountryCode(from: mask))"
        interactor?.prefillStoredCredentials()
    }

    func displayStoredCredentials(phone: String, password: String) {
        phoneTextField.text = PhoneMaskFormatter.apply(mask: phoneMask, to: phone)
        passwordFieldWithError.textField.text = password
        textDidChange()
    }

    func displayLoginResult(viewModel: Login.ViewModel.DisplayLoginResult) {
        if viewModel.isSuccess {
            router?.routeToMain()
        } else {
            passwordFieldWithError.showError(message: "Неверный пароль")
        }
    }
}


extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneTextField {
            let currentText = textField.text ?? ""
            guard let range = Range(range, in: currentText) else { return false }
            let updated = currentText.replacingCharacters(in: range, with: string)
            textField.text = PhoneMaskFormatter.apply(mask: phoneMask, to: updated)
            return false
        }
        return true
    }
}

private enum Layout {
    static let logoTop: CGFloat = 40
    static let titleTop: CGFloat = 16
    static let sectionTop: CGFloat = 32
    static let fieldSpacing: CGFloat = 20
    static let labelToFieldSpacing: CGFloat = 8
    static let loginTopSpacing: CGFloat = 45
    static let sideInset: CGFloat = 16
    static let fieldHeight: CGFloat = 44
    static let loginButtonHeight: CGFloat = 54
    static let cornerRadius: CGFloat = 10
    static let passwordIconTrailing: CGFloat = 12
}

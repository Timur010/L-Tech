import UIKit
import SnapKit

final class LTEXTextFieldWithError: UIView {

    let textField = UITextField()
    private let errorLabel = LTEXLabel(style: .footnote)
    private let borderView = UIView()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        addSubview(borderView)
        addSubview(textField)
        addSubview(errorLabel)

        borderView.layer.cornerRadius = 8
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.systemGray4.cgColor

        textField.borderStyle = .none
        errorLabel.textColor = .systemRed
        errorLabel.isHidden = true

        borderView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }

        textField.snp.makeConstraints {
            $0.edges.equalTo(borderView).inset(8)
        }

        errorLabel.snp.makeConstraints {
            $0.top.equalTo(borderView.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(borderView)
            $0.bottom.equalToSuperview()
        }
    }

    func showError(message: String) {
        borderView.layer.borderColor = UIColor.systemRed.cgColor
        errorLabel.text = message
        errorLabel.isHidden = false
    }

    func hideError() {
        borderView.layer.borderColor = UIColor.systemGray4.cgColor
        errorLabel.isHidden = true
    }
}

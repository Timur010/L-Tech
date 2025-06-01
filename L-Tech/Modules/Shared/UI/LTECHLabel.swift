import UIKit

final class LTECHLabel: UILabel {

    enum Style {
        case body
        case bodySemibold
        case title2Bold
        case headline
        case title3bold
        case subheadline
        case subheadlineSemibold
        case footnote
    }

    private var styleAttributes: [NSAttributedString.Key: Any] = [:]

    init(style: Style) {
        super.init(frame: .zero)
        configure(with: style)
        numberOfLines = 0
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func configure(with style: Style) {
        switch style {
        case .body:
            styleAttributes = LTECHTypography.body
        case .bodySemibold:
            styleAttributes = LTECHTypography.bodySemibold
        case .title2Bold:
            styleAttributes = LTECHTypography.title2Bold
        case .headline:
            styleAttributes = LTECHTypography.headline
        case .title3bold:
            styleAttributes = LTECHTypography.title3bold
        case .subheadline:
            styleAttributes = LTECHTypography.subheadline
        case .subheadlineSemibold:
            styleAttributes = LTECHTypography.subheadlineSemibold
        case .footnote:
            styleAttributes = LTECHTypography.footnote
        }
    }

    override var text: String? {
        didSet {
            guard let text = text else { return }
            self.attributedText = NSAttributedString(string: text, attributes: styleAttributes)
        }
    }
}


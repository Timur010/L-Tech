import UIKit

final class LTEXLabel: UILabel {

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
            styleAttributes = LTEXTypography.body
        case .bodySemibold:
            styleAttributes = LTEXTypography.bodySemibold
        case .title2Bold:
            styleAttributes = LTEXTypography.title2Bold
        case .headline:
            styleAttributes = LTEXTypography.headline
        case .title3bold:
            styleAttributes = LTEXTypography.title3bold
        case .subheadline:
            styleAttributes = LTEXTypography.subheadline
        case .subheadlineSemibold:
            styleAttributes = LTEXTypography.subheadlineSemibold
        case .footnote:
            styleAttributes = LTEXTypography.footnote
        }
    }

    override var text: String? {
        didSet {
            guard let text = text else { return }
            self.attributedText = NSAttributedString(string: text, attributes: styleAttributes)
        }
    }
}


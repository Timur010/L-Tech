import UIKit

enum LTECHTypography {

    static var body: [NSAttributedString.Key: Any] {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 2.4
        paragraph.paragraphSpacing = 15

        return [
            .font: UIFont.systemFont(ofSize: 17, weight: .regular),
            .kern: -0.41,
            .paragraphStyle: paragraph
        ]
    }
    
    static var bodySemibold: [NSAttributedString.Key: Any] {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 2.4

        return [
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold),
            .kern: -0.41,
            .paragraphStyle: paragraph
        ]
    }

    static var title2Bold: [NSAttributedString.Key: Any] {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 7.6

        return [
            .font: UIFont.systemFont(ofSize: 22, weight: .bold),
            .kern: 0.8,
            .paragraphStyle: paragraph
        ]
    }

    static var headline: [NSAttributedString.Key: Any] {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 1.6
        
        return [
            .font: UIFont.systemFont(ofSize: 22, weight: .semibold),
            .kern: -0.41,
            .paragraphStyle: paragraph
        ]
    }

    static var title3bold: [NSAttributedString.Key: Any] {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 3.4
        
        return [
            .font: UIFont.systemFont(ofSize: 20, weight: .semibold),
            .kern: 0.75,
            .paragraphStyle: paragraph
        ]
    }

    static var subheadline: [NSAttributedString.Key: Any] {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = -0.4
        paragraph.paragraphSpacing = 10
        
        return [
            .font: UIFont.systemFont(ofSize: 15, weight: .regular),
            .kern: -0.24,
            .paragraphStyle: paragraph
        ]
    }

    static var subheadlineSemibold: [NSAttributedString.Key: Any] {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = -0.4
        
        return [
            .font: UIFont.systemFont(ofSize: 15, weight: .semibold),
            .kern: -0.24,
            .paragraphStyle: paragraph
        ]
    }

    static var footnote: [NSAttributedString.Key: Any] {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = -2.4
        
        return [
            .font: UIFont.systemFont(ofSize: 13, weight: .regular),
            .kern: -0.08,
            .paragraphStyle: paragraph
        ]
    }
}

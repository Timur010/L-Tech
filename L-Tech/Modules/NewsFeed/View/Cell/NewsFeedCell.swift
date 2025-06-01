import UIKit
import SnapKit

final class NewsFeedCell: UITableViewCell {

    private let containerView = UIView()
    private let separator = UIView()
    private let postImageView = UIImageView()
    private let titleLabel = LTEXLabel(style: .subheadlineSemibold)
    private let textLabelContent = LTEXLabel(style: .subheadline)
    private let dateLabel = LTEXLabel(style: .footnote)


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHierarchy()
        setupLayout()
        setupStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupHierarchy() {
        contentView.addSubview(containerView)

        [separator, postImageView, titleLabel, textLabelContent, dateLabel].forEach {
            containerView.addSubview($0)
        }
    }

    private func setupLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        separator.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.leading.equalToSuperview().inset(Layout.sideInset)
            $0.height.equalTo(Layout.separatorHeight)
        }

        postImageView.snp.makeConstraints {
            $0.top.equalTo(separator.snp.bottom).offset(Layout.topInset)
            $0.leading.equalToSuperview().inset(Layout.sideInset)
            $0.width.height.equalTo(Layout.imageSize)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(postImageView.snp.top)
            $0.leading.equalTo(postImageView.snp.trailing).offset(Layout.sideInset)
            $0.trailing.equalToSuperview().inset(Layout.sideInset)
        }

        textLabelContent.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Layout.spacingBetweenLabels)
            $0.leading.trailing.equalTo(titleLabel)
        }

        dateLabel.snp.makeConstraints {
            $0.top.equalTo(textLabelContent.snp.bottom).offset(Layout.spacingBetweenTextAndDate)
            $0.leading.trailing.equalTo(titleLabel)
            $0.bottom.equalToSuperview().inset(Layout.bottomInset)
            $0.bottom.greaterThanOrEqualTo(postImageView.snp.bottom)
        }
    }

    private func setupStyle() {
        selectionStyle = .none

        separator.backgroundColor = UIColor.systemGray4

        postImageView.contentMode = .scaleAspectFill
        postImageView.clipsToBounds = true

        dateLabel.textColor = UIColor(resource: .gray)
        titleLabel.numberOfLines = 0
        textLabelContent.numberOfLines = 0
    }


    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
    }


    func configure(with viewModel: NewsFeed.Fetch.ViewModel.DisplayedPost) {
        titleLabel.text = viewModel.title
        textLabelContent.text = viewModel.text
        dateLabel.text = viewModel.date

        if let url = viewModel.imageURL {
            postImageView.load(from: url)
        }
    }
}

private enum Layout {
    static let sideInset: CGFloat = 16
    static let topInset: CGFloat = 20
    static let imageSize: CGFloat = 80
    static let separatorHeight: CGFloat = 1
    static let spacingBetweenLabels: CGFloat = 4
    static let spacingBetweenTextAndDate: CGFloat = 6
    static let bottomInset: CGFloat = 16
}

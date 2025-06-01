import UIKit
import SnapKit

protocol NewsDetailDisplayLogic: AnyObject {
    func displayPost(viewModel: NewsDetail.ViewModel)
}

final class NewsDetailViewController: UIViewController, NewsDetailDisplayLogic {
    
    var interactor: NewsDetailBusinessLogic?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let dateLabel = LTEXLabel(style: .footnote)
    private let titleLabel = LTEXLabel(style: .title3bold)
    private let postImageView = UIImageView()
    private let bodyLabel = LTEXLabel(style: .body)
    private let headerView = UIView()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "icon_arrow"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "icon_heart"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "icon_share"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        setupUI()

        interactor?.fetchPost()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    func displayPost(viewModel: NewsDetail.ViewModel) {
        dateLabel.text = viewModel.date
        titleLabel.text = viewModel.title
        bodyLabel.text = viewModel.text
        if let url = viewModel.imageURL {
            postImageView.load(from: url)
        }
        
    }
    
    private func setupUI() {
        setupHeaderView()
        setupScrollView()
        setupContentViews()
        setupConstraints()
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
    }
    
    private func setupHeaderView() {
        view.addSubview(headerView)
        headerView.addSubview(backButton)
        headerView.addSubview(likeButton)
        headerView.addSubview(shareButton)
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Layout.headerHeight)
        }

        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Layout.sideInset)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(Layout.iconSize)
        }

        shareButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Layout.sideInset)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(Layout.iconSize)
        }

        likeButton.snp.makeConstraints {
            $0.trailing.equalTo(shareButton.snp.leading).offset(-Layout.spacingBetweenIcons)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(Layout.iconSize)
        }

    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
    
    private func setupContentViews() {
        [dateLabel, titleLabel, postImageView, bodyLabel].forEach {
            contentView.addSubview($0)
        }
        
        dateLabel.textColor = .gray
        titleLabel.numberOfLines = 0
        
        postImageView.contentMode = .scaleAspectFill
        postImageView.clipsToBounds = true
        
        bodyLabel.numberOfLines = 0
    }
    
    private func setupConstraints() {
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Layout.topInset)
            $0.leading.trailing.equalToSuperview().inset(Layout.sideInset)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(Layout.spacingTitleToDate)
            $0.leading.trailing.equalToSuperview().inset(Layout.sideInset)
        }

        postImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Layout.spacingImageToTitle)
            $0.leading.trailing.equalToSuperview().inset(Layout.sideInset)
            $0.height.equalTo(Layout.imageHeight)
        }

        bodyLabel.snp.makeConstraints {
            $0.top.equalTo(postImageView.snp.bottom).offset(Layout.spacingBodyToImage)
            $0.leading.trailing.equalToSuperview().inset(Layout.sideInset)
            $0.bottom.equalToSuperview().inset(Layout.bottomInset)
        }
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension NewsDetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

private enum Layout {
    static let sideInset: CGFloat = 16
    static let topInset: CGFloat = 16
    static let spacingTitleToDate: CGFloat = 8
    static let spacingImageToTitle: CGFloat = 32
    static let imageHeight: CGFloat = 226
    static let spacingBodyToImage: CGFloat = 32
    static let bottomInset: CGFloat = 24
    static let headerHeight: CGFloat = 44
    static let iconSize: CGFloat = 24
    static let spacingBetweenIcons: CGFloat = 16
}

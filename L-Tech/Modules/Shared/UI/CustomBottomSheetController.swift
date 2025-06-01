import UIKit
import SnapKit

final class CustomBottomSheetController: UIViewController {

    var onFilterSelected: ((String) -> Void)?
    
    private let filters = ["По умолчанию", "По дате"]
    private var selectedFilter: String

    private let backgroundView = UIView()
    private let containerView = UIView()
    private let titleLabel = LTEXLabel(style: .bodySemibold)

    init(selected: String) {
        self.selectedFilter = selected
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        setupBackground()
        setupContainer()
        setupHeader()
        setupFilterStack()
    }

    private func setupBackground() {
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.addSubview(backgroundView)
        backgroundView.frame = view.bounds

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissSelf))
        backgroundView.addGestureRecognizer(tap)
    }

    private func setupContainer() {
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = Layout.cornerRadius
        containerView.clipsToBounds = true

        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.height * Layout.sheetHeightRatio)
            $0.bottom.equalToSuperview()
        }
    }

    private func setupHeader() {
        titleLabel.text = "Сортировка"
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)

        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(named: "icon-close"), for: .normal)
        closeButton.tintColor = .lightGray
        closeButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)

        containerView.addSubview(titleLabel)
        containerView.addSubview(closeButton)

        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Layout.closeTopInset)
            $0.trailing.equalToSuperview().inset(Layout.sideInset)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(closeButton.snp.bottom).offset(Layout.titleTopInset)
            $0.leading.equalToSuperview().offset(Layout.sideInset)
        }
    }

    private func setupFilterStack() {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0

        containerView.addSubview(stack)
        stack.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Layout.stackTopInset)
            $0.leading.trailing.equalToSuperview()
        }

        for (index, filter) in filters.enumerated() {
            let row = createRow(for: filter, tag: index)
            stack.addArrangedSubview(row)

            if index < filters.count - 1 {
                let separator = UIView()
                separator.backgroundColor = .systemGray4
                separator.snp.makeConstraints { $0.height.equalTo(Layout.separatorHeight) }
                stack.addArrangedSubview(separator)
            }
        }
    }

    private func createRow(for filter: String, tag: Int) -> UIView {
        let row = UIView()
        row.tag = tag
        row.isUserInteractionEnabled = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(filterTapped(_:)))
        row.addGestureRecognizer(tap)

        let label = LTEXLabel(style: .body)
        label.text = filter

        let checkmark = UIImageView()
        checkmark.image = UIImage(named: "icon-chek")
        checkmark.isHidden = filter != selectedFilter

        row.addSubview(label)
        row.addSubview(checkmark)

        label.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Layout.sideInset)
            $0.centerY.equalToSuperview()
        }

        checkmark.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Layout.sideInset)
            $0.centerY.equalToSuperview()
        }

        row.snp.makeConstraints { $0.height.equalTo(Layout.rowHeight) }

        return row
    }

    @objc private func dismissSelf() {
        dismiss(animated: true)
    }

    @objc private func filterTapped(_ gesture: UITapGestureRecognizer) {
        guard let view = gesture.view else { return }
        let filter = filters[view.tag]
        onFilterSelected?(filter)
        dismiss(animated: true)
    }
}

// MARK: - Layout Constants

private enum Layout {
    static let sheetHeightRatio: CGFloat = 0.25
    static let cornerRadius: CGFloat = 16
    static let sideInset: CGFloat = 16
    static let closeTopInset: CGFloat = 8
    static let titleTopInset: CGFloat = 12
    static let stackTopInset: CGFloat = 16
    static let rowHeight: CGFloat = 44
    static let separatorHeight: CGFloat = 1
}

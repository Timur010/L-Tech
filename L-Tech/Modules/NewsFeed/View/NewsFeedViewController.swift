import UIKit
import SnapKit

protocol NewsFeedDisplayLogic: AnyObject {
    func displayPosts(viewModel: NewsFeed.Fetch.ViewModel)
}

final class NewsFeedViewController: UIViewController, NewsFeedDisplayLogic {

    var interactor: NewsFeedBusinessLogic?
    var router: NewsFeedRoutingLogic?
    
    private var displayedPosts: [NewsFeed.Fetch.ViewModel.DisplayedPost] = []

    private let tableView = UITableView()
    private let headerView = UIView()

    private let titleLabel: UILabel = {
        let label = LTECHLabel(style: .headline)
        label.text = "Лента новостей"
        label.textAlignment = .center
        return label
    }()

    private let refreshButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "icon_refresh")
        button.setImage(image, for: .normal)
        button.tintColor = .black
        return button
    }()

    private let filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("По умолчанию", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)

        let icon = UIImage(named: "icon-arrow")
        button.setImage(icon, for: .normal)
        button.tintColor = .black
        button.semanticContentAttribute = .forceRightToLeft
        button.contentHorizontalAlignment = .trailing

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupUI()
        setupRefreshControl()
        interactor?.fetchPosts(request: .init())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func setupUI() {
        setupHeaderView()
        setupFilterButton()
        setupTableView()

        refreshButton.addTarget(self, action: #selector(refreshPulled), for: .touchUpInside)
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
    }

    private func setupHeaderView() {
        view.addSubview(headerView)

        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Layout.headerHeight)
        }

        headerView.addSubview(titleLabel)
        headerView.addSubview(refreshButton)

        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        refreshButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(Layout.sideInset)
            $0.width.height.equalTo(Layout.refreshIconSize)
        }
    }

    private func setupFilterButton() {
        view.addSubview(filterButton)

        filterButton.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(Layout.filterTopOffset)
            $0.leading.trailing.equalToSuperview().inset(Layout.sideInset)
            $0.height.equalTo(Layout.filterButtonHeight)
        }
    }

    private func setupTableView() {
        view.addSubview(tableView)

        tableView.snp.makeConstraints {
            $0.top.equalTo(filterButton.snp.bottom).offset(Layout.tableTopOffset)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        tableView.register(NewsFeedCell.self, forCellReuseIdentifier: "NewsFeedCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
    }

    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshPulled), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc private func refreshPulled() {
        interactor?.fetchPosts(request: .init())
    }

    @objc private func filterButtonTapped() {
        let sheetVC = CustomBottomSheetController(selected: filterButton.title(for: .normal) ?? "По умолчанию")
        sheetVC.onFilterSelected = { [weak self] selected in
            self?.filterButton.setTitle(selected, for: .normal)
            self?.applyFilter(named: selected)
        }
        present(sheetVC, animated: true)
    }

    func displayPosts(viewModel: NewsFeed.Fetch.ViewModel) {
        displayedPosts = viewModel.displayedPosts
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
    }

    private func applyFilter(named: String) {
        switch named {
        case "По дате":
            displayedPosts.sort { $0.date > $1.date }
        case "По названию":
            displayedPosts.sort { $0.title < $1.title }
        default:
            break
        }

        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension NewsFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        displayedPosts.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let displayedPost = displayedPosts[indexPath.row]
        router?.routeToDetails(with: displayedPost)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedCell", for: indexPath) as? NewsFeedCell else {
            return UITableViewCell()
        }
        cell.configure(with: displayedPosts[indexPath.row])
        return cell
    }
}


private enum Layout {
    static let sideInset: CGFloat = 16
    static let headerHeight: CGFloat = 48
    static let filterButtonHeight: CGFloat = 36
    static let filterTopOffset: CGFloat = 8
    static let tableTopOffset: CGFloat = 16
    static let refreshIconSize: CGFloat = 24
}

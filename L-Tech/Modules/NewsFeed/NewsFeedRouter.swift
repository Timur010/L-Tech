import UIKit

protocol NewsFeedRoutingLogic {
    func routeToDetails(with post: NewsFeed.Fetch.ViewModel.DisplayedPost)
}

final class NewsFeedRouter: NewsFeedRoutingLogic {
    weak var viewController: UIViewController?

    func routeToDetails(with post: NewsFeed.Fetch.ViewModel.DisplayedPost) {
        let detailVC = NewsDetailBuilder.build(with: post)
        detailVC.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}

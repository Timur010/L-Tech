import UIKit

enum NewsDetailBuilder {
    static func build(with post: NewsFeed.Fetch.ViewModel.DisplayedPost) -> UIViewController {
        let viewController = NewsDetailViewController()
        let interactor = NewsDetailInteractor()
        let presenter = NewsDetailPresenter()

        viewController.interactor = interactor

        interactor.presenter = presenter
        interactor.post = post

        presenter.viewController = viewController

        return viewController
    }
}

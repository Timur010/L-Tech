import UIKit

final class NewsFeedBuilder {
    static func build() -> UIViewController {
        let viewController = NewsFeedViewController()
        let presenter = NewsFeedPresenter()
        let interactor = NewsFeedInteractor(networkService: NetworkService())
        let router = NewsFeedRouter()

        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController

        return viewController
    }
}

import UIKit

protocol LoginRoutingLogic {
    func routeToMain()
}

final class LoginRouter: LoginRoutingLogic {
    weak var viewController: UIViewController?

    func routeToMain() {
        let tabBar = MainTabBarBuilder.build()
        tabBar.modalPresentationStyle = .fullScreen
        viewController?.present(tabBar, animated: true, completion: nil)
    }
}

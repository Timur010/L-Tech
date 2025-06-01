import UIKit

final class MainTabBarBuilder {
    static func build() -> UITabBarController {
        let tabBarController = UITabBarController()

        let newsVC = NewsFeedBuilder.build()
        newsVC.tabBarItem = UITabBarItem(title: "Главное", image: UIImage(named: "icon_home"), tag: 0)

        let stub1 = UINavigationController(rootViewController: UIViewController())
        stub1.view.backgroundColor = .white
        stub1.tabBarItem = UITabBarItem(title: "Избранное", image: UIImage(named: "icon_heart"), tag: 1)

        let stub2 = UINavigationController(rootViewController: UIViewController())
        stub2.view.backgroundColor = .white
        stub2.tabBarItem = UITabBarItem(title: "Аккаунт", image: UIImage(named: "icon_user"), tag: 2)

        tabBarController.viewControllers = [
            UINavigationController(rootViewController: newsVC),
            stub1,
            stub2
        ]
        
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().isTranslucent = false

        return tabBarController
    }
}

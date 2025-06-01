import Foundation

protocol NewsDetailBusinessLogic {
    func fetchPost()
}


final class NewsDetailInteractor: NewsDetailBusinessLogic {
    var presenter: NewsDetailPresentationLogic?
    var post: NewsFeed.Fetch.ViewModel.DisplayedPost?

    func fetchPost() {
        guard let post = post else { return }
        presenter?.presentPost(response: .init(post: post))
    }
}

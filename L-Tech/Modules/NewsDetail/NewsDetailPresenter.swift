import Foundation

protocol NewsDetailPresentationLogic {
    func presentPost(response: NewsDetail.Response)
}

final class NewsDetailPresenter: NewsDetailPresentationLogic {
    weak var viewController: NewsDetailDisplayLogic?

    func presentPost(response: NewsDetail.Response) {
        let post = response.post

        let viewModel = NewsDetail.ViewModel(
            title: post.title,
            text: post.text,
            imageURL: post.imageURL,
            date: post.date
        )
        viewController?.displayPost(viewModel: viewModel)
    }
}



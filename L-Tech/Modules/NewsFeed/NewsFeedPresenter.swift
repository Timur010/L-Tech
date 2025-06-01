import Foundation

protocol NewsFeedPresentationLogic {
    func presentPosts(response: NewsFeed.Fetch.Response)
}

final class NewsFeedPresenter: NewsFeedPresentationLogic {
    weak var viewController: NewsFeedDisplayLogic?

    func presentPosts(response: NewsFeed.Fetch.Response) {
        let viewModel = NewsFeed.Fetch.ViewModel(displayedPosts: response.posts.map {
            NewsFeed.Fetch.ViewModel.DisplayedPost(
                title: $0.title,
                text: $0.text,
                imageURL: $0.fullImageURL,
                date: formatDate($0.date)
            )
        })
        viewController?.displayPosts(viewModel: viewModel)
    }

    private func formatDate(_ string: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]

        if let date = isoFormatter.date(from: string) {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.dateFormat = "d MMMM, HH:mm"
            return formatter.string(from: date)
        }
        return string
    }

}

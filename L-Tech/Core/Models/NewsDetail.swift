import Foundation

enum NewsDetail {
    struct Response {
        let post: NewsFeed.Fetch.ViewModel.DisplayedPost
    }

    struct ViewModel {
        let title: String
        let text: String
        let imageURL: URL?
        let date: String
    }
}

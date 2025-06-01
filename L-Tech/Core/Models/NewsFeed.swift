import Foundation

enum NewsFeed {
    enum Fetch {
        struct Request {}

        struct Response {
            let posts: [Post]
        }

        struct ViewModel {
            struct DisplayedPost {
                let title: String
                let text: String
                let imageURL: URL?
                let date: String
            }
            let displayedPosts: [DisplayedPost]
        }
    }
}

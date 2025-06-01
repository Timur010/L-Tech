import Foundation
import Alamofire

protocol NewsFeedBusinessLogic {
    func fetchPosts(request: NewsFeed.Fetch.Request)
}

final class NewsFeedInteractor: NewsFeedBusinessLogic {
    var presenter: NewsFeedPresentationLogic?
    let networkService: NetworkServiceProtocol
    let postStorage: RealmPostStorageProtocol

    init(networkService: NetworkServiceProtocol, postStorage: RealmPostStorageProtocol = RealmPostStorage()) {
        self.networkService = networkService
        self.postStorage = postStorage
    }

    func fetchPosts(request: NewsFeed.Fetch.Request) {
        networkService.request(.posts) { [weak self] (result: Result<[Post], AFError>) in
            switch result {
            case .success(let posts):
                let sortedPosts = posts.sorted { $0.sort < $1.sort }
                self?.postStorage.saveOrUpdate(posts: sortedPosts)
                self?.postStorage.deleteRemovedPosts(currentIDs: sortedPosts.map { $0.id })

                let response = NewsFeed.Fetch.Response(posts: sortedPosts)
                self?.presenter?.presentPosts(response: response)
            case .failure(let error):
                print("Fetch error: \(error.localizedDescription)")
                
                let cachedPosts = self?.postStorage.fetchPosts() ?? []
                let response = NewsFeed.Fetch.Response(posts: cachedPosts)
                self?.presenter?.presentPosts(response: response)
            }
        }
    }
}

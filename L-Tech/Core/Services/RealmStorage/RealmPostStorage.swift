import RealmSwift

protocol RealmPostStorageProtocol {
    func saveOrUpdate(posts: [Post])
    func fetchPosts() -> [Post]
    func deleteRemovedPosts(currentIDs: [String])
}

final class RealmPostStorage: RealmPostStorageProtocol {
    private let realm = try! Realm()

    func saveOrUpdate(posts: [Post]) {
        let realmPosts = posts.map { post in
            let item = RealmPost()
            item.id = post.id
            item.title = post.title
            item.text = post.text
            item.image = post.image
            item.sort = post.sort
            item.date = post.date
            return item
        }

        try? realm.write {
            realm.add(realmPosts, update: .modified)
        }
    }

    func fetchPosts() -> [Post] {
        let realmPosts = realm.objects(RealmPost.self).sorted(byKeyPath: "sort", ascending: true)
        return realmPosts.map {
            Post(id: $0.id, title: $0.title, text: $0.text, image: $0.image, sort: $0.sort, date: $0.date)
        }
    }

    func deleteRemovedPosts(currentIDs: [String]) {
        let allPosts = realm.objects(RealmPost.self)
        let toDelete = allPosts.filter { !currentIDs.contains($0.id) }

        try? realm.write {
            realm.delete(toDelete)
        }
    }
}

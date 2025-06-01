import Foundation
import RealmSwift

final class RealmPost: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var text: String = ""
    @objc dynamic var image: String = ""
    @objc dynamic var sort: Int = 0
    @objc dynamic var date: String = ""

    override static func primaryKey() -> String? {
        return "id"
    }
}

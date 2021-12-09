import UIKit

struct UserCategory {
    let categoryID: String
    let categoryTitle: String
    let imageUrl: String
    let currentUid: String

    init(dictionary: [String: Any]) {
        self.categoryID = dictionary["categoryID"] as? String ?? ""
        self.categoryTitle = dictionary["categoryTitle"] as? String ?? ""
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.currentUid = dictionary["currentUid"] as? String ?? ""
    }
}

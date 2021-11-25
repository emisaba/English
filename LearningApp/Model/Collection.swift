import UIKit

struct Collection {
    let collectionTitle: String
    let imageUrl: String
    
    init(dictionary: [String: Any]) {
        self.collectionTitle = dictionary["collectionTitle"] as? String ?? ""
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
    }
}

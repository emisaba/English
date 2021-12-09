import UIKit

struct SearchCollectionViewModel {
    let collection: AllCollection
    
    var userName: String {
        return collection.userName
    }
    
    var userImageUrl: URL? {
        return URL(string: collection.userImageUrl)
    }
    
    var cardImageUrl: URL? {
        return URL(string: collection.collectionImageUrl)
    }
    
    init(collection: AllCollection) {
        self.collection = collection
    }
}

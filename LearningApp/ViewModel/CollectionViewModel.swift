import UIKit

struct CollectionViewmodel {
    var collection: UserCollection
    
    var collectionTitle: String {
        return collection.collectionTitle
    }
    var collectionImage: URL? {
        return URL(string: collection.collectionImageUrl)
    }
    
    init(collection: UserCollection) {
        self.collection = collection
    }
}

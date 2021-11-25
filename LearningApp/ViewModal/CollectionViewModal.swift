import UIKit

struct CollectionViewmodel {
    var collection: Collection
    var collectionTitle: String {
        return collection.collectionTitle
    }
    var collectionImage: URL? {
        return URL(string: collection.imageUrl)
    }
    
    init(collection: Collection) {
        self.collection = collection
    }
}

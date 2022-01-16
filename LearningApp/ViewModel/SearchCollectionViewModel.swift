import UIKit

struct SearchCollectionViewModel {
    let collection: AllCollection
    let cellNumber: Int
    
    var userName: String {
        return collection.userName
    }
    
    var title: String {
        return collection.collectionTitle
    }
    
    var userImageUrl: URL? {
        return URL(string: collection.userImageUrl)
    }
    
    var cardImageUrl: URL? {
        return URL(string: collection.collectionImageUrl)
    }
    
    var sentenceCount: String {
        return "\(collection.sentenceCount)"
    }
    
    var wordCount: String {
        return "\(collection.wordCount)"
    }
    
    init(collection: AllCollection, cellNumber: Int) {
        self.collection = collection
        self.cellNumber = cellNumber
    }
}

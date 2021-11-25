import UIKit

struct Category {
    let categoryTitle: String
    let collectionTitle: String
    let imageUrl: String
    let sentence: SentenceInfo?
    let word: WordInfo?
    
    init(dictionary: [String: Any]) {
        self.categoryTitle = dictionary["categoryTitle"] as? String ?? ""
        self.collectionTitle = dictionary["collectionTitle"] as? String ?? ""
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.sentence = dictionary["sentenceInfo"] as? SentenceInfo ?? nil
        self.word = dictionary["wordInfo"] as? WordInfo ?? nil
    }
}

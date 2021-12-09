import UIKit

struct Word {
    let categoryID: String
    let collectionID: String
    let wordID: String
    let word: String
    let translatedWord: String
    let correct: Bool
    
    init(dictionary: [String: Any]) {
        self.categoryID = dictionary["categoryID"] as? String ?? ""
        self.collectionID = dictionary["collectionID"] as? String ?? ""
        self.wordID = dictionary["wordID"] as? String ?? ""
        self.word = dictionary["word"] as? String ?? ""
        self.translatedWord = dictionary["translatedWord"] as? String ?? ""
        self.correct = dictionary["correct"] as? Bool ?? true
    }
}

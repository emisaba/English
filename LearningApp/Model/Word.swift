import UIKit

struct Word {
    let wordID: String
    let word: String
    let translatedWord: String
    let correct: Bool
    
    init(wordID: String, dictionary: [String: Any]) {
        self.wordID = wordID
        self.word = dictionary["word"] as? String ?? ""
        self.translatedWord = dictionary["translatedWord"] as? String ?? ""
        self.correct = dictionary["correct"] as? Bool ?? true
    }
}

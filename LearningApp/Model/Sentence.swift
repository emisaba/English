import UIKit

struct Sentence {
    let sentenceID: String
    let sentence: String
    let transratedSentence: String
    let sentenceArray: [String]
    let correct: Bool
    
    init(dictionary: [String: Any]) {
        self.sentenceID = dictionary["sentenceID"] as? String ?? ""
        self.sentence = dictionary["sentence"] as? String ?? ""
        self.transratedSentence = dictionary["translatedSentence"] as? String ?? ""
        self.sentenceArray = dictionary["sentenceArray"] as? [String] ?? []
        self.correct = dictionary["correct"] as? Bool ?? true
    }
}

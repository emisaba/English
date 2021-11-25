import UIKit

struct CardViewmodel {
    
    let sentence: Sentence
    let sentenceEnglish: String
    let sentenceJapanese: String
    var englishArray: [String]
    
    let word: Word
    let wordEnglish: String
    let wordJapanese: String
    
    init(sentence: Sentence?, word: Word?) {
        self.sentence = sentence ?? Sentence(sentenceID: "", dictionary: ["" : ""])
        
        self.sentenceEnglish = sentence?.sentence ?? ""
        self.sentenceJapanese = sentence?.transratedSentence ?? ""
        self.englishArray = sentence?.sentenceArray ?? []
        
        self.word = word ?? Word(wordID: "", dictionary: ["" : ""])
        self.wordEnglish = word?.word ?? ""
        self.wordJapanese = word?.translatedWord ?? ""
    }
}

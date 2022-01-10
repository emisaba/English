import UIKit

// MARK: - CaptureCardViewDelegate

extension CardViewController: CaptureCardViewDelegate {
    
    // MARK: - API
    
    func createSentence(sentenceInfo: SentenceInfo) {
        let sentenceInfo = SentenceInfo(categoryID: sentenceInfo.categoryID,
                                        collectionID: sentenceInfo.collectionID,
                                        sentence: sentenceInfo.sentence,
                                        transratedSentence: sentenceInfo.transratedSentence,
                                        sentenceArray: sentenceInfo.sentenceArray)
        
        CardService.createSentence(sentenceInfo: sentenceInfo) { _ in
            
            self.wordsInfo.forEach { wordInfo in
                let wordInfo = WordInfo(categoryID: sentenceInfo.categoryID,
                                        collectionID: sentenceInfo.collectionID,
                                        word: wordInfo.word,
                                        translatedWord: wordInfo.translatedWord)
                
                CardService.createWord(wordInfo: wordInfo) { error in
                    if let error = error {
                        print("failed to upload:\(error.localizedDescription)")
                        return
                    }
                }
            }
            self.wordsInfo = []
        }
        topCard = cardViews.last
    }
    
    // MARK: - Helpers
    
    func saveInfo(view: CaptureCardView, sentenceInfo: SentenceInfo) {
        view.removeFromSuperview()
        cardViews.removeAll(where: { view == $0 as! CaptureCardView } )
        createSentence(sentenceInfo: sentenceInfo)
    }
    
    func topViewSentence(card: CaptureCardView, text: String) {
        guard let topCard = topCard as? CaptureCardView else { return }
        
        if card == topCard {
            let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.lexendDecaBold(size: 17), .foregroundColor: UIColor.white, .kern: 2]
            card.captureTextView.attributedText = NSAttributedString(string: text, attributes: attributes)
        }
    }
    
    func topViewWordArray(card: CaptureCardView, words: [String]) {
        guard let topCard = topCard as? CaptureCardView else { return }
        
        if card == topCard {
            card.inputAnswerView.englishArray = words
        }
    }
    
    func showCameraView() {
        let vc = CameraViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

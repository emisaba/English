import UIKit

// MARK: - CardViewDelegate

extension CardViewController: CardViewDelegate {
    
    // MARK: - API
    
    func saveSentence(correct: Bool, cardID: String, view: CardView) {
        
//        let categoryInfo = collectionInfo
//
//        CardService.saveSentenceTestResult(categoryInfo: categoryInfo, cardID: cardID, correct: correct) { error in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//            
//            self.prepareForNextCard()
//            self.checkIfLastCard(correct: correct)
//        }
    }
    
    // MARK: - Helpers
    
    func prepareForNextCard() {
        self.swipeCount += 1
        
        switch self.cardType {
        
        case .listening:
            guard let listenigCardView = view as? ListeningCardView else { return }
            listenigCardView.removeFromSuperview()
            self.cardViews.removeAll(where: { listenigCardView == $0 as! ListeningCardView } )
            self.topCard = self.cardViews.last
            
        case .speaking:
            guard let speakingCardView = view as? SpeakingCardView else { return }
            speakingCardView.removeFromSuperview()
            self.cardViews.removeAll(where: { speakingCardView == $0 as! SpeakingCardView } )
            self.topCard = self.cardViews.last
            
        case .writing:
            guard let writingCardView = view as? WritingCardView else { return }
            writingCardView.removeFromSuperview()
            self.cardViews.removeAll(where: { writingCardView == $0 as! WritingCardView } )
            self.topCard = self.cardViews.last
            
        case .dictation:
            guard let dictationCardView = view as? DictationCardView else { return }
            dictationCardView.removeFromSuperview()
            self.cardViews.removeAll(where: { dictationCardView == $0 as! DictationCardView } )
            self.topCard = self.cardViews.last
            
        default:
            break
        }
    }
    
    func checkIfLastCard(correct: Bool) {
        self.correctCount += correct ? 1 : 0
        
        if self.topCard == nil {
            
            let circlePersent = self.correctCount / self.swipeCount
            
            let circlePath = UIBezierPath(arcCenter: self.view.center,
                                          radius: 100,
                                          startAngle: -(.pi / 2),
                                          endAngle: (.pi * 2 * circlePersent) - (.pi / 2),
                                          clockwise: true)
            self.indicatorAnimation.path = circlePath.cgPath
            self.startCircleAnimation()
        }
    }
}


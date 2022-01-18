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
    
    func prepareForNextCard(cardView: CardView) {
        self.swipeCount += 1
        
        switch self.cardType {
        
        case .listening:
            self.cardViews.removeAll(where: { cardView == $0 as! ListeningCardView } )
            self.topCard = self.cardViews.last
            
            if let topCard = self.topCard as? ListeningCardView {
                topCard.isHidden = false
                
                var targetIndexItem = 0
                
                topCard.viewModel.englishArray.forEach { word in
                    
                    let targetIndexPath = IndexPath(item: targetIndexItem, section: 0)
                    guard let cell = topCard.showAnswerView.cellForItem(at: targetIndexPath) as? ShowAnswerViewCell else { return }
                    cell.defaultUI(shouldShowAnswer: false, text: word)
                    targetIndexItem += 1
                }
            }
            
        case .speaking:
            self.cardViews.removeAll(where: { cardView == $0 as! SpeakingCardView } )
            self.topCard = self.cardViews.last
            
            if let topCard = self.topCard as? SpeakingCardView {
                topCard.isHidden = false
            }
            
        case .writing:
            self.cardViews.removeAll(where: { cardView == $0 as! WritingCardView } )
            self.topCard = self.cardViews.last
            
            if let topCard = self.topCard as? WritingCardView {
                topCard.isHidden = false
            }
            
        case .dictation:
            self.cardViews.removeAll(where: { cardView == $0 as! DictationCardView } )
            self.topCard = self.cardViews.last
            
            if let topCard = self.topCard as? DictationCardView {
                topCard.isHidden = false
            }
            
        case .word:
            self.cardViews.removeAll(where: { cardView == $0 as! VocabularyCardView } )
            self.topCard = self.cardViews.last
            
            if let topCard = self.topCard as? VocabularyCardView {
                topCard.isHidden = false
            }
            
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


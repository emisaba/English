import UIKit

// MARK: - CaptureCardViewDelegate

extension CardViewController: CaptureCardViewDelegate {
    
    // MARK: - API
    
    func createCardService(info: CategoryInfo) {
        
        CreateCardService.registerNewCards(categoryInfo: info) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            self.wordsInfo = []
        }
        topCard = cardViews.last
    }
    
    // MARK: - Helpers
    
    func saveInfo(view: CaptureCardView, sentenceInfo: SentenceInfo) {
        
        view.removeFromSuperview()
        cardViews.removeAll(where: { view == $0 as! CaptureCardView } )
        
        let categoryTitle = categoryInfo.categoryTitle
        let collectionTitle = categoryInfo.collectionTitle
        let categoryInfo = CategoryInfo(categoryTitle: categoryTitle,
                                        collectionTitle: collectionTitle,
                                        image: nil,
                                        sentence: sentenceInfo,
                                        word: wordsInfo)
        
        createCardService(info: categoryInfo)
    }
    
    func topViewSentence(card: CaptureCardView, text: String) {
        guard let topCard = topCard as? CaptureCardView else { return }
        
        if card == topCard {
            card.captureTextView.text = text
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

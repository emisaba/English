import UIKit

extension CardViewController {
    
    func configureCard() {
        view.addSubview(deckView)
        
        let smallCardSize = cardType == .word || cardType == .dictation || cardType == .shadowing
        
        if smallCardSize {
            
            if cardType == .word {
                configureWordCard()
            } else {
                configureSentenceCard()
            }
            
            deckView.frame = CGRect(x: 20, y: 0, width: view.frame.width - 40, height: 335)
            deckView.center.y = view.frame.height / 2
            
        } else {
            configureSentenceCard()
            deckView.anchor(top: closeButton.bottomAnchor,
                            left: view.leftAnchor,
                            bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            right: view.rightAnchor,
                            paddingTop: 20,
                            paddingLeft: 30,
                            paddingBottom: 110,
                            paddingRight: 30)
        }
    }
    
    func configureWordCard() {
        
        guard let words = words else { return }
        
        words.forEach { word in
            let wordViewmodel = CardViewModel(sentence: nil, word: word)
            let id = ID(category: itemInfo.categoryID, collection: itemInfo.collectionID)
            
            let cardView = VocabularyCardView(viewModel: wordViewmodel,
                                              type: .word,
                                              shouldHideJapanese: shouldHideJapanese,
                                              id: id)
            deckView.addSubview(cardView)
            cardView.fillSuperview()
            cardView.vocabularyCardViewDelegate = self
            cardView.delegate = self
            
            cardViews = deckView.subviews.map { $0 as! VocabularyCardView }
            topCard = cardViews.last
            
            deckView.subviews.forEach { if $0 != topCard as! VocabularyCardView { $0.isHidden = true } }
        }
    }
    
    func configureSentenceCard() {
        
        if cardType == .capture {
            configureCaptureCard()
            
        } else {
            
            guard let sentences = sentences else { return }
            guard let cardType = cardType else { return }
            let id = ID(category: itemInfo.categoryID, collection: itemInfo.collectionID)
            
            sentences.forEach { sentence in
                
                if testCardType == .correct && sentence.correct == false { return }
                if testCardType == .inCorrect && sentence.correct == true { return }
                
                let cardViewmodel = CardViewModel(sentence: sentence, word: nil)
                
                switch cardType {
                
                case .listening:
                    let cardView = ListeningCardView(viewModel: cardViewmodel,
                                                     type: .listening,
                                                     shouldHideJapanese: shouldHideJapanese,
                                                     id: id)
                    cardView.delegate = self
                    cardView.cardID = sentence.sentenceID
                    cardView.shouldHideJapanese = shouldHideJapanese
                    
                    deckView.addSubview(cardView)
                    cardView.fillSuperview()
                    
                    cardViews = deckView.subviews.map { $0 as! ListeningCardView }
                    topCard = cardViews.last
                    
                    deckView.subviews.forEach { if $0 != topCard as! ListeningCardView { $0.isHidden = true } }
                    
                case .speaking:
                    let cardView = SpeakingCardView(viewModel: cardViewmodel,
                                                    type: .speaking,
                                                    shouldHideJapanese: shouldHideJapanese,
                                                    id: id)
                    cardView.delegate = self
                    cardView.cardID = sentence.sentenceID
                    cardView.shouldHideJapanese = shouldHideJapanese
                    
                    deckView.addSubview(cardView)
                    cardView.fillSuperview()
                    
                    cardViews = deckView.subviews.map { $0 as! SpeakingCardView }
                    topCard = cardViews.last
                    
                    deckView.subviews.forEach { if $0 != topCard as! SpeakingCardView { $0.isHidden = true } }
                    
                case .writing:
                    let cardView = WritingCardView(viewModel: cardViewmodel,
                                                   type: .writing,
                                                   shouldHideJapanese: shouldHideJapanese,
                                                   id: id)
                    cardView.delegate = self
                    cardView.cardID = sentence.sentenceID
                    cardView.shouldHideJapanese = shouldHideJapanese
                    
                    deckView.addSubview(cardView)
                    cardView.fillSuperview()
                    
                    cardViews = deckView.subviews.map { $0 as! WritingCardView }
                    topCard = cardViews.last
                    
                    deckView.subviews.forEach { if $0 != topCard as! WritingCardView { $0.isHidden = true } }
                    
                case .dictation:
                    let cardView = DictationCardView(viewModel: cardViewmodel,
                                                     type: .dictation,
                                                     shouldHideJapanese: shouldHideJapanese,
                                                     id: id)
                    cardView.delegate = self
                    cardView.dictationCardViewDelegate = self
                    cardView.cardID = sentence.sentenceID
                    cardView.shouldHideJapanese = shouldHideJapanese
                    
                    deckView.addSubview(cardView)
                    cardView.fillSuperview()
                    
                    cardViews = deckView.subviews.map { $0 as! DictationCardView }
                    topCard = cardViews.last
                    
                    deckView.subviews.forEach { if $0 != topCard as! DictationCardView { $0.isHidden = true } }
                    
                case .shadowing:
                    let cardView = ShadowingCardView(viewModel: cardViewmodel,
                                                     type: .shadowing,
                                                     shouldHideJapanese: shouldHideJapanese,
                                                     id: id)
                    cardView.delegate = self
                    cardView.cardID = sentence.sentenceID
                    cardView.shouldHideJapanese = shouldHideJapanese
                    
                    deckView.addSubview(cardView)
                    cardView.fillSuperview()
                    
                    cardViews = deckView.subviews.map { $0 as! ShadowingCardView }
                    topCard = cardViews.last
                    
                    deckView.subviews.forEach { if $0 != topCard as! ShadowingCardView { $0.isHidden = true } }
                    
                default:
                    break
                }
            }
        }
    }
    
    func configureCaptureCard() {
        let id = ID(category: itemInfo.categoryID, collection: itemInfo.collectionID)
        
        (0 ..< 3).forEach { _ in
            let cardView = CaptureCardView(viewModel: CardViewModel(sentence: nil, word: nil),
                                           type: .capture,
                                           shouldHideJapanese: shouldHideJapanese, id: id)
            cardView.captureCardDelegate = self
            deckView.addSubview(cardView)
            cardView.fillSuperview()
        }
        
        cardViews = deckView.subviews.map { $0 as! CaptureCardView }
        topCard = cardViews.last
    }
}

// MARK: - DictationCardViewDelegate

extension CardViewController: DictationCardViewDelegate {
    func didBeginTextViewEditing() {
        UIView.animate(withDuration: 0.3) {
            self.deckView.center.y -= 150
        }
    }
}

// MARK: - VocabularyCardViewDelegate

extension CardViewController: VocabularyCardViewDelegate {
    func didBeginTextFieldEditing() {
        UIView.animate(withDuration: 0.3) {
            self.deckView.center.y -= 130
        }
    }
}

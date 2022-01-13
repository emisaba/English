import UIKit

extension CardViewController {
    
    func configureCard() {
        
        view.addSubview(deckView)
        
        if cardType == .word {
            configureWordCard()
            deckView.anchor(left: view.leftAnchor,
                            right: view.rightAnchor,
                            paddingLeft: 20,
                            paddingRight: 20,
                            height: 375)
            deckView.centerY(inView: view)
        } else {
            configureSentenceCard()
            deckView.anchor(top: closeButton.bottomAnchor,
                            left: view.leftAnchor,
                            bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            right: view.rightAnchor,
                            paddingTop: 25,
                            paddingLeft: 30,
                            paddingBottom: 100,
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
            
            cardViews = deckView.subviews.map { $0 as! VocabularyCardView }
            topCard = cardViews.last
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
                    
                case .dictation:
                    let cardView = DictationCardView(viewModel: cardViewmodel,
                                                     type: .dictation,
                                                     shouldHideJapanese: shouldHideJapanese,
                                                     id: id)
                    cardView.delegate = self
                    cardView.cardID = sentence.sentenceID
                    cardView.shouldHideJapanese = shouldHideJapanese
                    
                    deckView.addSubview(cardView)
                    cardView.fillSuperview()
                    
                    cardViews = deckView.subviews.map { $0 as! DictationCardView }
                    topCard = cardViews.last
                    
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
                    
                default:
                    break
                }
            }
        }
    }
    
    func configureCaptureCard() {
        let id = ID(category: itemInfo.categoryID, collection: itemInfo.collectionID)
        
        (0 ..< 5).forEach { _ in
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

import UIKit

extension CardViewController {
    
    func configureCard() {
        
        view.addSubview(deckView)
        
        if cardType == .word {
            configureWordCard()
            deckView.anchor(top: closeButton.bottomAnchor,
                            left: view.leftAnchor,
                            right: view.rightAnchor,
                            paddingTop: 50,
                            paddingLeft: 20,
                            paddingRight: 20,
                            height: 375)
        } else {
            configureSentenceCard()
            deckView.anchor(top: closeButton.bottomAnchor,
                            left: view.leftAnchor,
                            bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            right: view.rightAnchor,
                            paddingTop: 50,
                            paddingLeft: 20,
                            paddingBottom: 100,
                            paddingRight: 20)
        }
    }
    
    func configureWordCard() {
        
        guard let words = words else { return }
        
        words.forEach { word in
            let wordViewmodel = CardViewmodel(sentence: nil, word: word)
            let cardView = VocabularyCardView(viewmodel: wordViewmodel, type: .word, shouldHideJapanese: shouldHideJapanese)
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
            
            sentences.forEach { sentence in
                
                if testCardType == .correct && sentence.correct == false { return }
                if testCardType == .inCorrect && sentence.correct == true { return }
                
                let cardViewmodel = CardViewmodel(sentence: sentence, word: nil)
                
                switch cardType {
                
                case .listening:
                    let cardView = ListeningCardView(viewmodel: cardViewmodel, type: .listening, shouldHideJapanese: shouldHideJapanese)
                    cardView.delegate = self
                    cardView.cardID = sentence.sentenceID
                    cardView.shouldHideJapanese = shouldHideJapanese
                    
                    deckView.addSubview(cardView)
                    cardView.fillSuperview()
                    
                    cardViews = deckView.subviews.map { $0 as! ListeningCardView }
                    topCard = cardViews.last
                    
                case .speaking:
                    let cardView = SpeakingCardView(viewmodel: cardViewmodel, type: .speaking, shouldHideJapanese: shouldHideJapanese)
                    cardView.delegate = self
                    cardView.cardID = sentence.sentenceID
                    cardView.shouldHideJapanese = shouldHideJapanese
                    
                    deckView.addSubview(cardView)
                    cardView.fillSuperview()
                    
                    cardViews = deckView.subviews.map { $0 as! SpeakingCardView }
                    topCard = cardViews.last
                    
                case .writing:
                    let cardView = WritingCardView(viewmodel: cardViewmodel, type: .writing, shouldHideJapanese: shouldHideJapanese)
                    cardView.delegate = self
                    cardView.cardID = sentence.sentenceID
                    cardView.shouldHideJapanese = shouldHideJapanese
                    
                    deckView.addSubview(cardView)
                    cardView.fillSuperview()
                    
                    cardViews = deckView.subviews.map { $0 as! WritingCardView }
                    topCard = cardViews.last
                    
                case .dictation:
                    let cardView = DictationCardView(viewmodel: cardViewmodel, type: .dictation, shouldHideJapanese: shouldHideJapanese)
                    cardView.delegate = self
                    cardView.cardID = sentence.sentenceID
                    cardView.shouldHideJapanese = shouldHideJapanese
                    
                    deckView.addSubview(cardView)
                    cardView.fillSuperview()
                    
                    cardViews = deckView.subviews.map { $0 as! DictationCardView }
                    topCard = cardViews.last
                    
                case .shadowing:
                    let cardView = ShadowingCardView(viewmodel: cardViewmodel, type: .shadowing, shouldHideJapanese: shouldHideJapanese)
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
        (0 ..< 50).forEach { _ in
            let cardView = CaptureCardView(viewmodel: CardViewmodel(sentence: nil, word: nil), type: .capture, shouldHideJapanese: shouldHideJapanese)
            cardView.captureCardDelegate = self
            deckView.addSubview(cardView)
            cardView.fillSuperview()
        }
        
        cardViews = deckView.subviews.map { $0 as! CaptureCardView }
        topCard = cardViews.last
    }
}

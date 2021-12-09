import UIKit

class WritingCardView: CardView {
    
    // MARK: - Lifecycle
    
    override init(viewModel: CardViewModel, type: CardType, shouldHideJapanese: Bool, id: ID) {
        super.init(viewModel: viewModel, type: type, shouldHideJapanese: shouldHideJapanese, id: id)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        
        addSubview(japaneseLabel)
        japaneseLabel.isHidden = shouldHideJapanese
        japaneseLabel.anchor(top: topAnchor,
                             left: leftAnchor,
                             right: rightAnchor,
                             paddingTop: 60,
                             paddingLeft: 10,
                             paddingRight: 10)
        japaneseLabel.centerX(inView: self)
        japaneseLabel.text = viewModel.sentenceJapanese
        
        addSubview(showAnswerView)
        showAnswerView.anchor(top: japaneseLabel.bottomAnchor,
                                   left: leftAnchor,
                                   right: rightAnchor,
                                   paddingTop: 30,
                                   paddingLeft: 20,
                                   paddingRight: 20,
                                   height: 120)
        showAnswerView.centerX(inView: self)
        showAnswerView.englishArray = viewModel.englishArray
        
        addSubview(inputAnswerView)
        inputAnswerView.anchor(top: showAnswerView.bottomAnchor,
                                    left: leftAnchor,
                                    bottom: bottomAnchor,
                                    right: rightAnchor,
                                    paddingTop: 30,
                                    paddingLeft: 20,
                                    paddingBottom: 30,
                                    paddingRight: 20)
        inputAnswerView.centerX(inView: self)
        inputAnswerView.englishArray = viewModel.englishArray
    }
}

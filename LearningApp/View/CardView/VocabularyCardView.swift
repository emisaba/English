import UIKit

class VocabularyCardView: CardView {
    
    // MARK: - Properties
    
    public lazy var vocabraryTextView = createTextView()
    
    // MARK: - Lifecycle
    
    override init(viewModel: CardViewModel, type: CardType, shouldHideJapanese: Bool, id: ID) {
        super.init(viewModel: viewModel, type: type, shouldHideJapanese: shouldHideJapanese, id: id)
        
        configureUI()
        vocabraryTextView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        
        addSubview(startButton)
        startButton.anchor(top: topAnchor,
                           paddingTop: 90)
        startButton.setDimensions(height: 50, width: 50)
        startButton.centerX(inView: self)
        
        addSubview(japaneseLabel)
        japaneseLabel.isHidden = shouldHideJapanese
        japaneseLabel.anchor(top: startButton.bottomAnchor,
                             left: leftAnchor,
                             right: rightAnchor,
                             paddingTop: 40,
                             paddingLeft: 10,
                             paddingRight: 10)
        japaneseLabel.centerX(inView: self)
        japaneseLabel.text = viewModel.wordJapanese
        
        addSubview(vocabraryTextView)
        vocabraryTextView.anchor(top: japaneseLabel.bottomAnchor,
                            left: leftAnchor,
                            right: rightAnchor,
                            paddingTop: 40,
                            paddingLeft: 20,
                            paddingRight: 20,
                            height: 50)
        vocabraryTextView.centerX(inView: self)
    }
}

// MARK: - UITextViewDelegate

extension VocabularyCardView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.lowercased() == viewModel.wordEnglish.lowercased() {
            textView.textColor = .systemGreen
        }
    }
}

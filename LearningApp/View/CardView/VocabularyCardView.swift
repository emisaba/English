import UIKit

protocol VocabularyCardViewDelegate {
    func didBeginTextFieldEditing()
}

class VocabularyCardView: CardView {
    
    // MARK: - Properties
    
    public var vocabularyCardViewDelegate: VocabularyCardViewDelegate?
    
    public lazy var vocabraryField = createTextField()
    
    // MARK: - Lifecycle
    
    override init(viewModel: CardViewModel, type: CardType, shouldHideJapanese: Bool, id: ID) {
        super.init(viewModel: viewModel, type: type, shouldHideJapanese: shouldHideJapanese, id: id)
        
        configureUI()
        vocabraryField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        
        addSubview(japaneseLabel)
        japaneseLabel.isHidden = shouldHideJapanese
        japaneseLabel.centerX(inView: self)
        japaneseLabel.centerY(inView: self)
        japaneseLabelText(text: viewModel.wordJapanese)
        
        addSubview(startButton)
        startButton.anchor(bottom: japaneseLabel.topAnchor,
                           paddingBottom: 40)
        startButton.setDimensions(height: 50, width: 50)
        startButton.centerX(inView: self)
        
        addSubview(vocabraryField)
        vocabraryField.anchor(top: japaneseLabel.bottomAnchor,
                                 left: leftAnchor,
                                 right: rightAnchor,
                                 paddingTop: 40,
                                 paddingLeft: 20,
                                 paddingRight: 20,
                                 height: 50)
        vocabraryField.centerX(inView: self)
    }
    
    func japaneseLabelText(text: String) {
        let attrubutes: [NSAttributedString.Key: Any] = [.font: UIFont.senobiMedium(size: 18), .foregroundColor: UIColor.white]
        japaneseLabel.attributedText = NSAttributedString(string:text, attributes: attrubutes)
    }
}

// MARK: - UITextViewDelegate

extension VocabularyCardView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        vocabularyCardViewDelegate?.didBeginTextFieldEditing()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.lexendDecaRegular(size: 16),
                                                         .foregroundColor: UIColor.white, .kern: 1]
        vocabraryField.attributedText = NSAttributedString(string: text, attributes: attributes)
        
        if textField.text?.lowercased() == viewModel.wordEnglish.lowercased() {
            textField.textColor = .systemGreen
        }
    }
}

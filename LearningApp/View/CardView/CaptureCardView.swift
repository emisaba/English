import UIKit

protocol CaptureCardViewDelegate {
    func showCameraView()
    func topViewWordArray(card: CaptureCardView, words: [String])
    func topViewtTranslatedSentence(card: CaptureCardView, text: String)
    func topViewSentence(card: CaptureCardView, text: String)
    func saveInfo(view: CaptureCardView, sentenceInfo: SentenceInfo)
    func didChangeTextView()
    func didEndTextView()
}

class CaptureCardView: CardView {
    
    // MARK: - Properties
    
    public var captureCardDelegate: CaptureCardViewDelegate?
    public var captureWordArray = [String]()
    
    public lazy var captureTextView = createTextView()
    private lazy var captureButton = createButton(image: #imageLiteral(resourceName: "camera"), selector: #selector(didTapCaptureButton))
    
    private lazy var translatedTextView = createTextView()
    
    public var wordsArray = [String]()
    
    // MARK: - Lifecycle
    
    override init(viewModel: CardViewModel, type: CardType, shouldHideJapanese: Bool, id: ID) {
        super.init(viewModel: viewModel, type: type, shouldHideJapanese: shouldHideJapanese, id: id)
        
        configureUI()
        getInfoFromCameraView()
        captureTextView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func didTapCaptureButton() {
        captureCardDelegate?.showCameraView()
    }
    
    @objc override func didTapDoneButton() {
        endEditing(true)
        captureCardDelegate?.didEndTextView()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        backgroundColor = UIColor.white.withAlphaComponent(0.15)
        
        addSubview(captureTextView)
        captureTextView.anchor(top: topAnchor,
                               left: leftAnchor,
                               right: rightAnchor,
                               paddingTop: 20,
                               paddingLeft: 20,
                               paddingRight: 20)
        captureTextView.backgroundColor = .white.withAlphaComponent(0.05)
        
        addSubview(captureButton)
        captureButton.backgroundColor = .clear
        captureButton.anchor(bottom: captureTextView.bottomAnchor,
                             right: captureTextView.rightAnchor)
        captureButton.setDimensions(height: 50, width: 50)
        captureButton.layer.borderWidth = 0
        
        addSubview(translatedTextView)
        translatedTextView.anchor(top: captureTextView.bottomAnchor,
                                  left: leftAnchor,
                                  right: rightAnchor,
                                  paddingTop: 20,
                                  paddingLeft: 20,
                                  paddingRight: 20)
        translatedTextView.setDimensions(height: 100, width: 100)
        translatedTextView.backgroundColor = .white.withAlphaComponent(0.05)
        
        addSubview(inputAnswerView)
        inputAnswerView.anchor(top: translatedTextView.bottomAnchor,
                                    left: leftAnchor,
                                    bottom: bottomAnchor,
                                    right: rightAnchor,
                                    paddingTop: 20,
                                    paddingLeft: 20,
                                    paddingBottom: 20,
                                    paddingRight: 20)
        inputAnswerView.centerX(inView: self)
        inputAnswerView.backgroundColor = .white.withAlphaComponent(0.05)
    }
    
    func translationTextFont(string: String) {
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.senobiMedium(size: 18), .foregroundColor: UIColor.white]
        translatedTextView.attributedText = NSAttributedString(string: string, attributes: attributes)
    }
    
    override func resetCardPosition(sender: UIPanGestureRecognizer) {
        
        let direction: SwipeDirection = sender.translation(in: nil).x > 100 ? .right : .left
        let shoudDismissCard = abs(sender.translation(in: nil).x) > 100
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseInOut) {
            
            if shoudDismissCard {
                let xTransition = CGFloat(direction.rawValue) * 1000
                let offScreenTransform = self.transform.translatedBy(x: xTransition, y: 0)
                self.transform = offScreenTransform
                
            } else {
                self.transform = .identity
            }
            
        } completion: { _ in
            if shoudDismissCard {
                
                guard let sentence = self.captureTextView.text else { return }
                guard let translatedSentence = self.translatedTextView.text else { return }
                let sentenceInfo = SentenceInfo(categoryID: self.id.category,
                                                collectionID: self.id.collection,
                                                sentence:  sentence.lowercased(),
                                                translatedSentence: translatedSentence,
                                                sentenceArray: self.wordsArray)
                
                self.captureCardDelegate?.saveInfo(view: self, sentenceInfo: sentenceInfo)
            }
        }
    }
    
    func getInfoFromCameraView() {
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("capturedWords"), object: nil, queue: .main) { notification in
            guard let words = notification.object as? [String] else { return }
            let sentence = words.joined(separator: " ")
            
            self.wordsArray = words
            self.captureCardDelegate?.topViewWordArray(card: self, words: self.createWordArray(text: sentence))
            self.captureCardDelegate?.topViewSentence(card: self, text: sentence)
            self.captureCardDelegate?.topViewtTranslatedSentence(card: self, text: sentence)
        }
    }
    
    func createWordArray(text: String) -> [String] {
        var replacingString = text.replacingOccurrences(of: ".", with: "")
        replacingString = replacingString.replacingOccurrences(of: ",", with: "")
        replacingString = replacingString.replacingOccurrences(of: "?", with: "")
        replacingString = replacingString.replacingOccurrences(of: "!", with: "")
        
        let replacingArray = replacingString.components(separatedBy: " ")
        return replacingArray
    }
    
    func createLabel(text: String) -> UILabel {
        let label = UILabel()
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.lightColor().withAlphaComponent(0.1),
                                                         .font: UIFont.senobiMedium(size: 14)]
        label.attributedText = NSAttributedString(string: "\(text)", attributes: attributes)
        label.numberOfLines = 0
        return label
    }
}

// MARK: - UITextView

extension CaptureCardView: UITextViewDelegate {
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        captureCardDelegate?.didChangeTextView()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        captureTextView.text = captureTextView.text
        wordsArray = createWordArray(text: captureTextView.text)
        
        let sentence = wordsArray.joined(separator: " ")
        let newWordArray = self.createWordArray(text: sentence)
        
        self.wordsArray = newWordArray
        self.captureCardDelegate?.topViewWordArray(card: self, words: newWordArray)
    }
}

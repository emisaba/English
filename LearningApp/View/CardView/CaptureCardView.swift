import UIKit
import MLKitTranslate

protocol CaptureCardViewDelegate {
    func showCameraView()
    func topViewWordArray(card: CaptureCardView, words: [String])
    func topViewSentence(card: CaptureCardView, text: String)
    func saveInfo(view: CaptureCardView, sentenceInfo: SentenceInfo)
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
    
    override init(viewmodel: CardViewmodel, type: CardType, shouldHideJapanese: Bool) {
        super.init(viewmodel: viewmodel, type: type, shouldHideJapanese: shouldHideJapanese)
        
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
    
    // MARK: - Helpers
    
    func configureUI() {
        
        addSubview(captureTextView)
        captureTextView.anchor(top: topAnchor,
                               left: leftAnchor,
                               right: rightAnchor,
                               paddingTop: 20,
                               paddingLeft: 20,
                               paddingRight: 20)
        
        addSubview(captureButton)
        captureButton.anchor(bottom: captureTextView.bottomAnchor,
                             right: captureTextView.rightAnchor)
        captureButton.setDimensions(height: 50, width: 50)
        
        addSubview(translatedTextView)
        translatedTextView.anchor(top: captureTextView.bottomAnchor,
                                  left: leftAnchor,
                                  right: rightAnchor,
                                  paddingTop: 20,
                                  paddingLeft: 20,
                                  paddingRight: 20)
        translatedTextView.setDimensions(height: 100, width: 100)
        
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
                guard let transratedSentence = self.translatedTextView.text else { return }
                
                self.captureCardDelegate?.saveInfo(view: self,
                                                   sentenceInfo: SentenceInfo(sentence: sentence.lowercased(),
                                                                              transratedSentence: transratedSentence,
                                                                              sentenceArray: self.wordsArray))
            }
        }
    }
    
    func translate(text: String) {
        
        let options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .japanese)
        let translator = Translator.translator(options: options)
        let conditions = ModelDownloadConditions(allowsCellularAccess: false, allowsBackgroundDownloading: true)
        
        translator.downloadModelIfNeeded(with: conditions) { error in
            guard error == nil else { return }
            
            translator.translate(text) { translatedText, error in
                guard error == nil else { return }
                
                self.translatedTextView.text = translatedText
            }
        }
    }
    
    func getInfoFromCameraView() {
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("capturedWords"), object: nil, queue: .main) { notification in
            guard let words = notification.object as? [String] else { return }
            let sentence = words.joined(separator: " ")
            
            self.wordsArray = words
            self.captureCardDelegate?.topViewWordArray(card: self, words: words)
            self.captureCardDelegate?.topViewSentence(card: self, text: sentence)
            
            self.translate(text: sentence)
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
}

// MARK: - UITextView

extension CaptureCardView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        captureTextView.text = captureTextView.text
        wordsArray = createWordArray(text: captureTextView.text)
        
        let sentence = wordsArray.joined(separator: " ")
        let newWordArray = self.createWordArray(text: sentence)
        
        self.wordsArray = newWordArray
        self.captureCardDelegate?.topViewWordArray(card: self, words: newWordArray)
    }
}

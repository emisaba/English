import UIKit

enum SwipeDirection: Int {
    case left = -1
    case right = 1
}

protocol CardViewDelegate {
    func saveSentence(correct: Bool, cardID: String, view: CardView)
}

class CardView: UIView {
    
    // MARK: - Properties
    
    public var delegate: CardViewDelegate?
    public var viewModel: CardViewModel
    
    public lazy var startButton = createButton(image: #imageLiteral(resourceName: "play"), selector: #selector(didTapStartButton))
    public lazy var japaneseLabel = createLabel(language: viewModel.sentenceJapanese, isJapanese: true)
    public lazy var englishLabel = createLabel(language: viewModel.sentenceEnglish, isJapanese: false)
    
    private let identifier = "identifier"
    public lazy var showAnswerView: ShowAnswerView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowlayout.scrollDirection = .vertical
        
        let cv = ShowAnswerView(frame: .zero, collectionViewLayout: flowlayout)
        cv.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return cv
    }()
    
    public lazy var inputAnswerView: InputAnswerView = {
        let flowlayout = CustomCollectionViewFlowLayout()
        flowlayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let cv = InputAnswerView(frame: .zero, collectionViewLayout: flowlayout)
        cv.cardType = self.cardType
        return cv
    }()
    
    public let cardType: CardType
    
    public var cardID = ""
    public var shouldHideJapanese = false
    
    private var timer: Timer?
    
    private var showDictationAnswer = false
    public var textViewTextCount = 0
    
    public let id: ID
    
    // MARK: - Lifecycle
    
    init(viewModel: CardViewModel, type: CardType, shouldHideJapanese: Bool, id: ID) {
        self.viewModel = viewModel
        self.cardType = type
        self.shouldHideJapanese = shouldHideJapanese
        self.id = id

        super.init(frame: .zero)
        backgroundColor = UIColor.white.withAlphaComponent(0.3)
        layer.cornerRadius = 12

        configureGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func didTapStartButton() {
        
        UIView.animate(withDuration: 0.1) {
            self.startButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: {_ in
            UIView.animate(withDuration: 0.1) {
                self.startButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
        
        if cardType == .shadowing { return }
        TextToSpeechService.startSpeech(text: cardType == .word ? viewModel.wordEnglish : viewModel.sentenceEnglish)
    }
    
    @objc func handlePanGesture(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            superview?.subviews.forEach { $0.layer.removeAllAnimations() }
        case .changed:
            panCard(sender: sender)
        case .ended:
            resetCardPosition(sender: sender)
        default: break
        }
    }
    
    @objc func didTapDoneButton() {
        endEditing(true)
    }
    
    // MARK: - Helpers
    
    func panCard(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: nil)
        let degrees = translation.x / 20
        let angle = degrees * .pi / 180
        let rotationalTransform = CGAffineTransform(rotationAngle: angle)
        transform = rotationalTransform.translatedBy(x: translation.x, y: translation.y)
    }
    
    func resetCardPosition(sender: UIPanGestureRecognizer) {
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
            let correct = direction == .right
            self.delegate?.saveSentence(correct: correct, cardID: self.cardID, view: self)
        }
    }
    
    func configureGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        addGestureRecognizer(pan)
    }
}

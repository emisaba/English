import UIKit

class CardViewController: UIViewController {
    
    // MARK: - Properties
    
    public var sentences: [Sentence]?
    public var words: [Word]?
    
    public lazy var captureBackgroundImage: UIImageView = {
        let blur = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: blur)
        effectView.alpha = 0.7
        
        let iv = UIImageView()
        iv.image = itemInfo.image
        iv.contentMode = .scaleAspectFill
        
        iv.addSubview(effectView)
        effectView.fillSuperview()
        return iv
    }()
    
    public lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "close-line"), for: .normal)
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        return button
    }()
    
    public let deckView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.1)
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.1
        return view
    }()
    
    public lazy var indicatorAnimation: CAShapeLayer = {
        let shape = CAShapeLayer()
        shape.lineWidth = 15
        shape.strokeColor = UIColor.systemYellow.cgColor
        shape.lineCap = .round
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeEnd = 0
        return shape
    }()
    
    private lazy var indicatorTrack: CAShapeLayer = {
        let circlePath = UIBezierPath(arcCenter: view.center,
                                      radius: 100,
                                      startAngle: -(.pi / 2),
                                      endAngle: .pi * 2,
                                      clockwise: true)
        
        let shape = CAShapeLayer()
        shape.path = circlePath.cgPath
        shape.lineWidth = 15
        shape.strokeColor = UIColor.systemGray.cgColor
        shape.fillColor = UIColor.clear.cgColor
        return shape
    }()
    
    private lazy var answerButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .lexendDecaRegular(size: 16)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(didTapAnswerButton), for: .touchUpInside)
        
        let attrubutes: [NSAttributedString.Key: Any] = [.font: UIFont.senobiBold(size: 16)]
        let attributedString = NSAttributedString(string: "答え", attributes: attrubutes)
        button.setAttributedTitle(attributedString, for: .normal)
        return button
    }()
    
    public var cardType: CardType?
    
    public var cardViews = [Any]()
    public var topCard: Any?
    
    public var wordsInfo = [WordInfo]()
    public var itemInfo: ItemInfo
    
    public var testCardType: QuestionType = .all
    
    public var shouldHideJapanese = false
    
    public var correctCount: CGFloat = 0
    public var swipeCount: CGFloat = 0
    
    private var itemViewController: ItemViewController?
    public var addCategoryViewController: AddCategoryViewController?
    public var collectionViewController: CollectionViewController?
    public var collectionAddImageButton: UIButton?
    
    // MARK: - Lifecycles
    
    init(cardType: CardType, itemInfo: ItemInfo, sentences: [Sentence]?,
         words: [Word]?, testCardType: QuestionType, japanese: Bool, itemViewController: ItemViewController?) {
        
        self.cardType = cardType
        self.itemInfo = itemInfo
        self.sentences = sentences
        self.words = words
        self.testCardType = testCardType
        self.shouldHideJapanese = japanese
        self.itemViewController = itemViewController
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if cardType == .capture {
            configureCaptureCardUI()
            
        } else {
            configureCardUIexceptCaptureView()
        }
        
        view.backgroundColor = .clear
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    // MARK: - API
    
    func updateCollectionCardCount() {
        CardService.updateCollectionCardCount(collectionID: itemInfo.collectionID) { error in
            if let error = error {
                print("failed to update counts: \(error.localizedDescription)")
                return
            }
            self.itemViewController?.configureUIParts()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Actions
    
    @objc func didTapCloseButton() {
        if cardType == .capture { updateCollectionCardCount() }
        
        if cardType == .capture && sentences == nil {
            
            dismiss(animated: false) {
                if self.addCategoryViewController != nil {
                    guard let addCategoryVC = self.addCategoryViewController?.navigationController else { return }
                    addCategoryVC.popToRootViewController(animated: true)
                    
                } else {
                    self.collectionAddImageButton?.hero.id = ""
                    self.collectionAddImageButton?.setImage(UIImage(), for: .normal)
                }
            }
            
        } else  {
            if cardType == .capture { return }
            
            itemViewController?.configureUIParts()
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func didTapAnswerButton() {
        
        UIView.animate(withDuration: 0.1) {
            self.answerButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: {_ in
            UIView.animate(withDuration: 0.1) {
                self.answerButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
        
        switch cardType {
        
        case .listening:
            guard let listenigTopCard = topCard as? ListeningCardView else { return }
            listenigTopCard.showAnswerView.shouldShowAnswer = true
            
        case .writing:
            guard let writingTopCard = topCard as? WritingCardView else { return }
            writingTopCard.showAnswerView.shouldShowAnswer = true
            
        case .dictation:
            guard let dictationTopCard = topCard as? DictationCardView else { return }
            NotificationCenter.default.post(name: Notification.Name("didTapAnswerButton"), object: true)
            dictationTopCard.showAnswer()
            
        case .word:
            guard let wordTopCard = topCard as? VocabularyCardView else { return }
            wordTopCard.vocabraryField.text = wordTopCard.viewModel.wordEnglish
            wordTopCard.vocabraryField.textColor = .systemRed
            
        default:
            break
        }
    }
    
    // MARK: - Helpers
    
    func startCircleAnimation() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = 3
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        indicatorAnimation.add(animation, forKey: "animation")
    }
    
    func configureCardUIexceptCaptureView() {
        
        
        
//        view.layer.addSublayer(indicatorTrack)
//        view.layer.addSublayer(indicatorAnimation)
        
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                           right: view.rightAnchor,
                           paddingBottom: -20,
                           paddingRight: 20)
        closeButton.setDimensions(height: 60, width: 60)
        
        configureCard()
        
        if cardType == .shadowing {
            return
        } else {
            view.addSubview(answerButton)
            answerButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                paddingBottom: 10)
            answerButton.setDimensions(height: 50, width: 180)
            answerButton.centerX(inView: view)
        }
    }
    
    func configureCaptureCardUI() {
        view.addSubview(captureBackgroundImage)
        captureBackgroundImage.fillSuperview()
        
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                           right: view.rightAnchor,
                           paddingRight: 20)
        closeButton.setDimensions(height: 60, width: 60)
        
        view.addSubview(deckView)
        deckView.anchor(top: closeButton.bottomAnchor,
                        left: view.leftAnchor,
                        bottom: view.safeAreaLayoutGuide.bottomAnchor,
                        right: view.rightAnchor,
                        paddingTop: 50,
                        paddingLeft: 30,
                        paddingBottom: 100,
                        paddingRight: 30)
        
        configureCaptureCard()
        showDictionaryViewController()
    }
    
    func showDictionaryViewController() {
        
        if cardType == .capture {
            
            NotificationCenter.default.addObserver(forName: Notification.Name("targetWord"), object: nil, queue: .main) { notification in
                self.showLoader(true)
                
                guard let word = notification.object as? String else { return }
                
                let dictionaryViewController = DictionaryViewController(term: word)
                dictionaryViewController.modalPresentationStyle = .fullScreen
                dictionaryViewController.setEnglishWord(text: word)
                
                dictionaryViewController.completion = { words in
                    
                    guard let english = words?[0] else { return }
                    guard let japanese = words?[1] else { return }
                    
                    self.wordsInfo.append(WordInfo(categoryID: self.itemInfo.categoryID,
                                                   collectionID: self.itemInfo.collectionID,
                                                   word: english, translatedWord: japanese))
                }
                
                self.present(dictionaryViewController, animated: true, completion: nil)
            }
        }
    }
}

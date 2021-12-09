import UIKit

class CardViewController: UIViewController {
    
    // MARK: - Properties
    
    public var sentences: [Sentence]?
    public var words: [Word]?
    
    public lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "pooh"), for: .normal)
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
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
        let button = UIButton()
        button.titleLabel?.font = .lexendDecaRegular(size: 16)
        button.setTitle("answer", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.titleLabel?.textColor = .systemGray
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.addTarget(self, action: #selector(didTapAnswerButton), for: .touchUpInside)
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
        if cardType != .capture { fetchCardInfo() }
        
        view.backgroundColor = .clear
        configureUI()
        
        showDictionaryViewController()
    }
    
    // MARK: - API
    
    func fetchCardInfo() {
        
//        let categoryTitle = collectionInfo.categoryTitle
//        let collectionTitle = collectionInfo.collectionTitle
//        let categoryInfo = CategoryInfo(categoryTitle: categoryTitle,
//                                        collectionTitle: collectionTitle,
//                                        image: nil, sentence: nil, word: nil)
//
//        CardService.fetchSentence(categoryInfo: categoryInfo) { sentences in
//            self.sentences = sentences
//
//            CardService.fetchWord(categoryInfo: categoryInfo) { words in
//                self.words = words
//            }
//        }
    }
    
    // MARK: - Actions
    
    @objc func didTapCloseButton() {
        
        if cardType == .capture && sentences == nil {
            navigationController?.popToRootViewController(animated: true)
            
        } else {
            itemViewController?.configureUIParts()
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func didTapAnswerButton() {
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
            wordTopCard.vocabraryTextView.text = wordTopCard.viewModel.wordEnglish
            wordTopCard.vocabraryTextView.textColor = .systemRed
            
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
    
    func configureUI() {
        
        view.addSubview(answerButton)
        answerButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            paddingBottom: 10)
        answerButton.setDimensions(height: 50, width: 180)
        answerButton.centerX(inView: view)
        
        view.layer.addSublayer(indicatorTrack)
        view.layer.addSublayer(indicatorAnimation)
        
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                           right: view.rightAnchor, paddingTop: 10,
                           paddingRight: 20)
        closeButton.setDimensions(height: 50, width: 50)
        
        configureCard()
    }
    
    func showDictionaryViewController() {
        if cardType == .capture {
            
            NotificationCenter.default.addObserver(forName: Notification.Name("targetWord"), object: nil, queue: .main) { notification in
                
                guard let word = notification.object as? String else { return }
                
                let dictionaryViewController = DictionaryViewController(term: word)
                dictionaryViewController.modalPresentationStyle = .fullScreen
                dictionaryViewController.inputEnglishView.text = word
                
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

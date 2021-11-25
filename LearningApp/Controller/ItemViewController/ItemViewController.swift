import UIKit

class ItemViewController: UIViewController {
    
    // MARK: - Properties
    
    private var sentences: [Sentence]?
    private var words: [Word]?
    
    private let baseView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let blackAlphaView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let visualEffectView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: blur)
        effectView.alpha = 0.7
        return effectView
    }()
    
    private let identifier = "identifier"
    public lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.dataSource = self
        tv.delegate = self
        tv.register(ItemViewCell.self, forCellReuseIdentifier: identifier)
        tv.separatorStyle = .none
        tv.backgroundColor = .none
        tv.allowsSelection = false
        tv.showsVerticalScrollIndicator = false
        return tv
    }()
    
    private lazy var closeButton = createButton(title: "close", closeButton: true)
    private lazy var addCardButton = createButton(title: "+", closeButton: false)
    
    private var imageViewFrame: CGRect
    private var category: Category?
    private var categoryInfo: CategoryInfo
    
    private var isWordHidden = false
    private var shoudHideJapanese = false
    
    private var testCardType: QuestionType = .all
    
    public var sections: [Section] = [Section(title: "shadowing", iconImage: #imageLiteral(resourceName: "pooh"), isOpened: false),
                                       Section(title: "Listening", iconImage: #imageLiteral(resourceName: "pooh"),  isOpened: false),
                                       Section(title: "Speaking", iconImage: #imageLiteral(resourceName: "pooh"), isOpened: false),
                                       Section(title: "writing", iconImage: #imageLiteral(resourceName: "pooh"), isOpened: false),
                                       Section(title: "dictation", iconImage: #imageLiteral(resourceName: "pooh"), isOpened: false),
                                       Section(title: "vocabulary", iconImage: #imageLiteral(resourceName: "pooh"), isOpened: false)]
    
    // MARK: - Lifecycle
    
    init(imageViewFrame: CGRect, categoryInfo: CategoryInfo) {
        self.imageViewFrame = imageViewFrame
        self.categoryInfo = categoryInfo
        
        super.init(nibName: nil, bundle: nil)
        
        baseView.frame = view.frame
        view.addSubview(baseView)
        
        view.addSubview(imageView)
        imageView.frame = imageViewFrame
        
        view.addSubview(visualEffectView)
        visualEffectView.frame = imageViewFrame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = categoryInfo.image
        fetchCollection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureUI()
    }
    
    // MARK: - API
    
    func fetchCollection() {
        
        let categoryTitle = categoryInfo.categoryTitle
        let collectionTitle = categoryInfo.collectionTitle
        
        let categoryInfo = CategoryInfo(categoryTitle: categoryTitle,
                                        collectionTitle: collectionTitle,
                                        image: nil, sentence: nil, word: nil)
        
        CreateCardService.fetchSentence(categoryInfo: categoryInfo) { sentences in
            
            if sentences.count != 0 {
                self.sentences = sentences
            } else {
                self.tableView.isHidden = true
            }
            
            CreateCardService.fetchWord(categoryInfo: categoryInfo) { words in
                
                if words.count != 0 {
                    self.words = words
                } else {
                    self.isWordHidden = true
                }
            }
        }
    }
    
    // MARK: - Actions
    
    @objc func didTapTestTypeButton(sender: UIButton) {
        
        let categoryTitle = categoryInfo.categoryTitle
        let collectionTitle = categoryInfo.collectionTitle
        let image = imageView.image
        
        let categoryInfo = CategoryInfo(categoryTitle: categoryTitle,
                                        collectionTitle: collectionTitle,
                                        image: image, sentence: nil, word: nil)
        
        var viewController = UIViewController()
        
        switch sender.accessibilityLabel {
        case "shadowing":
            viewController = CardViewController(cardType: .shadowing, categoryInfo: categoryInfo, sentences: sentences,
                                                words: words, testCardType: testCardType, japanese: shoudHideJapanese)
        case "Listening":
            viewController = CardViewController(cardType: .listening, categoryInfo: categoryInfo, sentences: sentences,
                                                words: words, testCardType: testCardType, japanese: shoudHideJapanese)
        case "Speaking":
            viewController = CardViewController(cardType: .speaking, categoryInfo: categoryInfo, sentences: sentences,
                                                words: words, testCardType: testCardType, japanese: shoudHideJapanese)
        case "writing":
            viewController = CardViewController(cardType: .writing, categoryInfo: categoryInfo, sentences: sentences,
                                                words: words, testCardType: testCardType, japanese: shoudHideJapanese)
        case "dictation":
            viewController = CardViewController(cardType: .dictation, categoryInfo: categoryInfo, sentences: sentences,
                                                words: words, testCardType: testCardType, japanese: shoudHideJapanese)
        case "vocabulary":
            viewController = CardViewController(cardType: .word, categoryInfo: categoryInfo, sentences: sentences,
                                                words: words, testCardType: testCardType, japanese: shoudHideJapanese)
        default: break
        }
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func didTapCloseButton(sender: UIButton) {
        
        let imageViewFrame = imageViewFrame
        let hideViews = [tableView, addCardButton, closeButton]
        
        UIView.animate(withDuration: 0.25) {
            self.hideViews(views: hideViews)
            
        } completion: { _ in
            
            UIView.animate(withDuration: 0.25) {
                self.imageView.frame = imageViewFrame
                self.visualEffectView.frame = imageViewFrame
                
            } completion: { _ in
                self.navigationController?.popViewController(animated: false)
            }
        }
    }
    
    @objc func didTapAddButton(sender: UIButton) {
        let viewController = CardViewController(cardType: .capture, categoryInfo: categoryInfo, sentences: sentences,
                                                words: words, testCardType: .all, japanese: false)
        navigationController?.pushViewController(viewController, animated: true)
    }

    // MARK: - Helpers
    
    func hideViews(views: [UIView]) {
        views.forEach { $0.isHidden = true }
    }
    
    func configureUI() {
        
        UIView.animate(withDuration: 0.25) {
            self.imageView.frame = self.view.frame
            self.visualEffectView.frame = self.view.frame
            
        } completion: { _ in
            self.view.addSubview(self.closeButton)
            self.closeButton.anchor(top: self.view.safeAreaLayoutGuide.topAnchor,
                                    right: self.view.rightAnchor,
                                    paddingTop: 5, paddingRight: 30)
            self.closeButton.setDimensions(height: 40, width: 40)
            
            self.view.addSubview(self.tableView)
            self.tableView.anchor(top: self.closeButton.bottomAnchor,
                                  left: self.view.leftAnchor,
                                  bottom: self.view.safeAreaLayoutGuide.bottomAnchor,
                                  right: self.view.rightAnchor,
                                  paddingTop: 25,
                                  paddingLeft: 25,
                                  paddingBottom: 30,
                                  paddingRight: 25)
            self.tableView.setDimensions(height: 500, width: self.view.frame.width - 50)
            
            self.view.addSubview(self.addCardButton)
            self.addCardButton.anchor(bottom: self.view.safeAreaLayoutGuide.bottomAnchor,
                                      paddingBottom: 15)
            self.addCardButton.setDimensions(height: 60, width: 60)
            self.addCardButton.centerX(inView: self.view)
            self.addCardButton.layer.cornerRadius = 30
        }
    }
}


// MARK: - UITableViewDataSource

extension ItemViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return createHeaderView(section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isWordHidden ? sections.count - 1 : sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        return section.isOpened ? 5 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ItemViewCell
        cell.viewModel = ItemViewModel(rowType: RowType.allCases[indexPath.row])
        cell.delegate = self
        
        let isOpen = sections[indexPath.section].isOpened
        cell.borderFrame.layer.borderColor = isOpen ? UIColor.white.cgColor : UIColor.clear.cgColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 ||  indexPath.row == 4 {
            return 16
            
        } else if indexPath.row == 3 {
            return 30
            
        } else {
            return 50
        }
    }
}

// MARK: - UITableViewDelegate

extension ItemViewController: UITableViewDelegate {
}

// MARK: - CategoryViewCellDelegate

extension ItemViewController: ItemViewCellDelegate {
    func shoudShowJapanese(show: Bool) {
        shoudHideJapanese = show
    }
    
    func questionType(type: QuestionType) {
        testCardType = type
    }
}

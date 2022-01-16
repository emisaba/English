import UIKit

class ItemViewController: UIViewController {
    
    // MARK: - Properties
    
    private var sentences: [Sentence]?
    private var words: [Word]?
    
    public lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = itemInfo.image
        return iv
    }()
    
    private let blackAlphaView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    public let visualEffectView: UIVisualEffectView = {
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
    
    private lazy var closeButton = UIButton.createImageButton(image: #imageLiteral(resourceName: "arrow-down"), target: self, action: #selector(didTapCloseButton))
    
    private lazy var addCardButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "add-fill"), for: .normal)
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        return button
    }()
    
    private let addCardButtonBackground: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .extraLight)
        let effectView = UIVisualEffectView(effect: blur)
        effectView.alpha = 0.3
        effectView.layer.cornerRadius = 30
        effectView.clipsToBounds = true
        return effectView
    }()
    
    private var category: UserCategory?
    private var itemInfo: ItemInfo
    
    private var isWordHidden = false
    private var shoudHideJapanese = false
    
    private var testCardType: QuestionType = .all
    
    public var sections: [Section] = [Section(title: "リスニング",  isOpened: false),
                                      Section(title: "スピーキング", isOpened: false),
                                      Section(title: "ボキャブラリ", isOpened: false),
                                      // Section(title: "ライティング", isOpened: false),
                                      Section(title: "ディクテーション", isOpened: false),
                                      Section(title: "シャドーイング", isOpened: false)]
    
    private let selectedCollection: CollectionViewCell
    
    // MARK: - Lifecycle
    
    init(itemInfo: ItemInfo, selectedCollection: CollectionViewCell) {
        self.itemInfo = itemInfo
        self.selectedCollection = selectedCollection
        
        super.init(nibName: nil, bundle: nil)
        
        view.addSubview(imageView)
        imageView.fillSuperview()
        
        view.addSubview(visualEffectView)
        visualEffectView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSentenceAndWord()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureUI()
    }
    
    // MARK: - API
    
    func fetchSentenceAndWord() {
        
        let accessID = ID(category: itemInfo.categoryID,
                          collection: itemInfo.collectionID)
        
        CardService.fetchSentences(accessID: accessID) { sentences in
            
            if sentences.count != 0 {
                self.sentences = sentences
            } else {
                self.tableView.isHidden = true
            }
            
            CardService.fetchWords(accessID: accessID) { words in
                
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
        
        var viewController = UIViewController()
        
        switch sender.accessibilityLabel {
        case "シャドーイング":
            viewController = CardViewController(cardType: .shadowing, itemInfo: itemInfo, sentences: sentences,
                                                words: words, testCardType: testCardType, japanese: shoudHideJapanese,
                                                itemViewController: self)
        case "リスニング":
            viewController = CardViewController(cardType: .listening, itemInfo: itemInfo, sentences: sentences,
                                                words: words, testCardType: testCardType, japanese: shoudHideJapanese,
                                                itemViewController: self)
        case "スピーキング":
            viewController = CardViewController(cardType: .speaking, itemInfo: itemInfo, sentences: sentences,
                                                words: words, testCardType: testCardType, japanese: shoudHideJapanese,
                                                itemViewController: self)
        case "ライティング":
            viewController = CardViewController(cardType: .writing, itemInfo: itemInfo, sentences: sentences,
                                                words: words, testCardType: testCardType, japanese: shoudHideJapanese,
                                                itemViewController: self)
        case "ディクテーション":
            viewController = CardViewController(cardType: .dictation, itemInfo: itemInfo, sentences: sentences,
                                                words: words, testCardType: testCardType, japanese: shoudHideJapanese,
                                                itemViewController: self)
        case "ボキャブラリ":
            viewController = CardViewController(cardType: .word, itemInfo: itemInfo, sentences: sentences,
                                                words: words, testCardType: testCardType, japanese: shoudHideJapanese,
                                                itemViewController: self)
        default: break
        }
        
        moveToCardView(vc: viewController)
    }
    
    @objc func didTapCloseButton(sender: UIButton) {
        dismiss(animated: true) { self.selectedCollection.hero.id = "" }
    }
    
    @objc func didTapAddButton(sender: UIButton) {
        let viewController = CardViewController(cardType: .capture, itemInfo: itemInfo, sentences: sentences,
                                                words: words, testCardType: .all, japanese: false,
                                                itemViewController: self)
        moveToCardView(vc: viewController)
    }

    // MARK: - Helpers
    
    func configureUI() {
        
        UIView.animate(withDuration: 0.25) {
            self.imageView.frame = self.view.frame
            self.visualEffectView.frame = self.view.frame
            
        } completion: { _ in
            self.configureUIParts()
        }
    }
    
    func configureUIParts() {
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                           right: view.rightAnchor,
                           paddingTop: -10,
                           paddingRight: 20)
        closeButton.setDimensions(height: 60, width: 60)
        
        view.addSubview(tableView)
        tableView.anchor(top: closeButton.bottomAnchor,
                         left: view.leftAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         right: view.rightAnchor,
                         paddingTop: 30,
                         paddingLeft: 25,
                         paddingBottom: 90,
                         paddingRight: 25)
        tableView.setDimensions(height: 500, width: view.frame.width - 50)
        
        view.addSubview(addCardButtonBackground)
        addCardButtonBackground.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
        addCardButtonBackground.setDimensions(height: 60, width: 60)
        addCardButtonBackground.centerX(inView: view)

        view.addSubview(addCardButton)
        addCardButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
        addCardButton.setDimensions(height: 60, width: 60)
        addCardButton.centerX(inView: view)
    }
    
    func moveToCardView(vc: UIViewController) {
        
        view.subviews.forEach {
            if $0 == imageView || $0 == visualEffectView { return }
            $0.removeFromSuperview()
        }

        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        
        present(vc, animated: true)
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

import UIKit

class TopViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var menuBar: MenuBar = {
        let view = MenuBar()
        view.delegate = self
        return view
    }()
    
    private let identifier = "identifier"
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = .white
        cv.isPagingEnabled = true
        cv.register(TopViewControllerCell.self,
                    forCellWithReuseIdentifier: identifier)
        return cv
    }()
    
    public var categories: [Category]? {
        didSet { collectionView.reloadData() }
    }
    
    public let diaryBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0)
        view.isUserInteractionEnabled = false
        return view
    }()
    
    public lazy var diaryView: DiaryView = {
        let diaryView = DiaryView()
//        diaryView.delegate = self
        return diaryView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        fetchCategory()
        collectionView.reloadData()
        Dimension.safeAreaTopHeight = view.safeAreaInsets.top
    }
    
    // MARK: - API
    
    func fetchCategory() {
        CreateCardService.fetchCategories { categories in
            self.categories = categories
        }
    }

    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        collectionView.frame = CGRect(x: 0,
                                      y: 70,
                                      width: view.frame.width,
                                      height: view.frame.height)
        view.addSubview(collectionView)
        
        view.addSubview(menuBar)
        menuBar.frame = CGRect(x: 0,
                               y: 40,
                               width: 230, height: 50)
        menuBar.center.x = view.center.x
        
        view.addSubview(self.diaryBackgroundView)
        diaryBackgroundView.fillSuperview()
        
        view.addSubview(diaryView)
        self.diaryView.frame = CGRect(x: 0,
                                      y: view.frame.height + 100,
                                      width: view.frame.width,
                                      height: view.frame.height)
    }
}

// MARK: - UICollectionViewDataSource

extension TopViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! TopViewControllerCell
        cell.categories = categories
        cell.isCalenderView = indexPath.row == 0 ? false : true
//        cell.calendarView.delegate = self
        cell.delegate = self
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewWidth = view.frame.width * 2
        let ratio = menuBar.frame.width / scrollViewWidth
        menuBar.underBar.frame.origin.x = scrollView.contentOffset.x * ratio
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let item = Int(targetContentOffset.move().x / view.frame.width)
        menuBar.collectionView.selectItem(at: IndexPath(item: item, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
}

// MARK: - UICollectionViewDelegate

extension TopViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - view.safeAreaInsets.top - 50)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TopViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - MenuBarDelegate

extension TopViewController: MenuBarDelegate {
    func didSelectMenu(indexPath: IndexPath) {
        collectionView.isPagingEnabled = false
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        collectionView.isPagingEnabled = true
    }
}

// MARK: - TopViewCellDelegate

extension TopViewController: TopViewControllerCellDelegate {
    
    func didTapAddCategoryButton() {
        let vc = AddCategoryViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapCategory(indexPath: IndexPath, collectionView: UICollectionView) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        let cellY = Dimension.safeAreaTopHeight + 60
        let cellFrame = CGRect(x: 0, y: cellY, width: cell.frame.size.width, height: cell.frame.size.height)
        
        if let categories = categories {
            let category = categories[indexPath.row]
            let vc = CollectionViewController(category: category, frame: cellFrame)
            vc.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(vc, animated: false)
        }
    }
}

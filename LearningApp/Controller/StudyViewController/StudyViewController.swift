import UIKit

class StudyViewController: UIViewController {
    
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
        cv.register(StudyCell.self,
                    forCellWithReuseIdentifier: identifier)
        return cv
    }()
    
    public var categories: [UserCategory]? {
        didSet { collectionView.reloadData() }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
        fetchCategory()
        collectionView.reloadData()
        Dimension.safeAreaTopHeight = view.safeAreaInsets.top
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureUI()
    }
    
    // MARK: - API
    
    func fetchCategory() {
        CardService.fetchUserCategories { categories in
            self.categories = categories
        }
    }

    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(menuBar)
        menuBar.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                       paddingTop: 10)
        menuBar.setDimensions(height: 50, width: 200)
        menuBar.centerX(inView: view)
        
        view.addSubview(collectionView)
        collectionView.anchor(top: menuBar.bottomAnchor,
                              left: view.leftAnchor,
                              bottom: view.bottomAnchor,
                              right: view.rightAnchor,
                              paddingTop: 10)
    }
}

// MARK: - UICollectionViewDataSource

extension StudyViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! StudyCell
        cell.categories = categories
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

extension StudyViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - view.safeAreaInsets.top - 60)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension StudyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - MenuBarDelegate

extension StudyViewController: MenuBarDelegate {
    func didSelectMenu(indexPath: IndexPath) {
        collectionView.isPagingEnabled = false
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        collectionView.isPagingEnabled = true
    }
}

// MARK: - TopViewCellDelegate

extension StudyViewController: TopViewControllerCellDelegate {
    
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
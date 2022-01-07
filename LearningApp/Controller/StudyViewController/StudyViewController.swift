import UIKit
import Hero

class StudyViewController: UIViewController {
    
    // MARK: - Properties
    
    private let identifier = "identifier"
    
    private lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.darkColor()
        cv.dataSource = self
        cv.delegate = self
        cv.register(CategoryView.self, forCellWithReuseIdentifier: identifier)
        return cv
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 25
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        button.layer.shadowRadius = 5
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return button
    }()
    
    public var categories: [UserCategory] = [] {
        didSet { categoryCollectionView.reloadData() }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCategory()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        Dimension.safeAreaTopHeight = view.safeAreaInsets.top
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        
        guard let tabBar = tabBarController as? TabBarController else { return }
        tabBar.tabBarView.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let tabBar = tabBarController as? TabBarController else { return }
        tabBar.tabBarView.isHidden = true
    }
    
    // MARK: - API
    
    func fetchCategory() {
        CardService.fetchUserCategories { categories in
            self.categories = categories
        }
    }
    
    // MARK: - Action
    
    @objc func didTapAddButton() {
        let vc = AddCategoryViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(categoryCollectionView)
        categoryCollectionView.anchor(top: view.topAnchor,
                                      left: view.leftAnchor,
                                      bottom: view.bottomAnchor,
                                      right: view.rightAnchor,
                                      paddingTop: -Dimension.safeAreaTopHeight)
        
        categoryCollectionView.addSubview(addCategoryButton)
        addCategoryButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                 right: view.rightAnchor,
                                 paddingTop: -10,
                                 paddingRight: 10)
        addCategoryButton.setDimensions(height: 60, width: 60)
    }
}

// MARK: - UICollectionViewDataSource

extension StudyViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CategoryView
        cell.viewModel = CategoryViewModel(category: categories[indexPath.row])
        cell.isStudyVC = true
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension StudyViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryView else { return }
        cell.hero.id = "moveToCollectionVC"
        
        let category = categories[indexPath.row]
        
        let vc = CollectionViewController(category: category, selectedCategory: cell)
        vc.headerView.hero.id = "moveToCollectionVC"
        vc.isHeroEnabled = true
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.25, delay: 0.05 * Double(indexPath.row)) {
            cell.alpha = 1
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension StudyViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

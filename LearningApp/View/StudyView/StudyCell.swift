import UIKit

protocol TopViewControllerCellDelegate {
    func didTapCategory(indexPath: IndexPath, collectionView: UICollectionView)
    func didTapAddCategoryButton()
}

class StudyCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    public var delegate: TopViewControllerCellDelegate?
    public var categories: [UserCategory]? {
        didSet { categoryCollectionView.reloadData() }
    }
    
    private let identifier = "identifier"
    
    private lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        cv.register(CategoryView.self, forCellWithReuseIdentifier: identifier)
        return cv
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPink
        button.clipsToBounds = true
        button.layer.cornerRadius = 25
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        button.layer.shadowRadius = 5
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(categoryCollectionView)
        categoryCollectionView.fillSuperview()
        
        categoryCollectionView.addSubview(addCategoryButton)
        addCategoryButton.anchor(bottom: safeAreaLayoutGuide.bottomAnchor,
                                 right: rightAnchor,
                                 paddingBottom: 130, paddingRight: 30)
        addCategoryButton.setDimensions(height: 50, width: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func didTapAddButton() {
        delegate?.didTapAddCategoryButton()
    }
    
    // MARK: - Helpers
}

// MARK: - UICollectionViewDataSource

extension StudyCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CategoryView
        
        if let categories = categories {
            cell.viewmodel = CategoryViewModel(category: categories[indexPath.row])
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension StudyCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTapCategory(indexPath: indexPath, collectionView: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.25, delay: 0.05 * Double(indexPath.row)) {
            cell.alpha = 1
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension StudyCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


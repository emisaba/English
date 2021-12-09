import UIKit

protocol MenuBarDelegate {
    func didSelectMenu(indexPath: IndexPath)
}

class MenuBar: UIView {
    
    // MARK: - Properties
    
    private let identifier = "identifier"
    private let titles = ["card", "calendar"]
    public var delegate: MenuBarDelegate?
    
    public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    public let underBar: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 2.5
        return view
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        configureCollecionView()
        underBar.frame = CGRect(x: 0, y: frame.height - 5, width: frame.width / 2, height: 5)
        addSubview(underBar)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureCollecionView() {
        collectionView.backgroundColor = .white
        collectionView.register(MenuBarCell.self, forCellWithReuseIdentifier: identifier)
        addSubview(collectionView)
        collectionView.fillSuperview()
    }
}

// MARK: - UICollectionViewDataSource

extension MenuBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! MenuBarCell
        cell.titleLabel.text = titles[indexPath.row]
        cell.titleLabel.font = indexPath.row == 0 ? .lexendDecaBold(size: 20) : .lexendDecaRegular(size: 16)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension MenuBar: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectMenu(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MenuBarCell else { return }
        cell.titleLabel.font = .lexendDecaRegular(size: 16)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MenuBar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 2, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


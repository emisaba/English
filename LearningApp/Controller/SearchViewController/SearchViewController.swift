import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchTextField.backgroundColor = .lightColor()
        searchBar.searchTextField.textColor = .white
        searchBar.setImage(#imageLiteral(resourceName: "search"), for: .search, state: .normal)
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        searchBar.tintColor = .white.withAlphaComponent(0.5)
        searchBar.delegate = self
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.lightGray, .font: UIFont.senobiMedium(size: 14)]
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "検索", attributes: attributes)
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "キャンセル"
        return searchBar
    }()
    
    private let identifier = "identifier"
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.register(SearchViewCell.self, forCellWithReuseIdentifier: identifier)
        cv.backgroundColor = UIColor.darkColor()
        cv.contentInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        return cv
    }()
    
    private var collections: [AllCollection] = [] {
        didSet { collectionView.reloadData() }
    }
    
    private var filteredCollections: [AllCollection] = [] {
        didSet { collectionView.reloadData() }
    }
    
    private var isSearchMode: Bool {
        return searchBar.isFirstResponder && searchBar.text!.count > 0
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllCollection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureUI()
    }
    
    // MARK: - API
    
    func fetchAllCollection() {
        CardService.fetchAllCollection { collections in
            self.collections = collections
        }
    }
    
    func downloadCollection(cellNumber: Int, categoryId: String) {
        
        let downloadCollection = isSearchMode ? filteredCollections[cellNumber] : collections[cellNumber]
        
        let collectionInfo = DownloadCollectionInfo(categoryID: categoryId,
                                                    collectionID: downloadCollection.collectionID,
                                                    collectionTitle: downloadCollection.collectionTitle,
                                                    collectionImageUrl: downloadCollection.collectionImageUrl,
                                                    userName: downloadCollection.userName,
                                                    userImageUrl: downloadCollection.userImageUrl,
                                                    sentenceCount: downloadCollection.sentenceCount,
                                                    wordCount: downloadCollection.wordCount)
        
        CardService.downloadCollection(collectionInfo: collectionInfo) { error in
            if let error = error {
                print("failed to download: \(error.localizedDescription)")
                return
            }
            
            print("success to download!!!")
        }
    }
    
    // MARK: - Helper
    
    func configureUI() {
        view.backgroundColor = .darkColor()
        
        view.addSubview(searchBar)
        searchBar.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingLeft: 10,
                         paddingRight: 10,
                         height: 70)
        
        let attribute: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemGray]
        UIBarButtonItem.appearance().setTitleTextAttributes(attribute, for: .normal)

        view.addSubview(collectionView)
        collectionView.anchor(top: searchBar.bottomAnchor,
                              left: view.leftAnchor,
                              bottom: view.bottomAnchor,
                              right: view.rightAnchor)
    }
}

// MARK: - UICollectionViewDataSource

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearchMode ? filteredCollections.count : collections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! SearchViewCell
        
        let collection = isSearchMode ? filteredCollections[indexPath.row] : collections[indexPath.row]
        cell.viewModel = SearchCollectionViewModel(collection: collection, cellNumber: indexPath.row)
        cell.delegate = self
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension SearchViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 20, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCollections = []
        filteredCollections = collections.filter { $0.collectionTitle.contains(searchText) }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white, .font: UIFont.lexendDecaRegular(size: 16)]
        searchBar.searchTextField.attributedText = NSAttributedString(string: searchBar.text ?? "", attributes: attributes)
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
}

// MARK: - SearchViewCellDelegate

extension SearchViewController: SearchViewCellDelegate {
    func download(cellNumber: Int) {
        
        let vc = SelectedCategoryViewController(cellNumber: cellNumber)
        vc.completion = { categoryId in
            self.downloadCollection(cellNumber: cellNumber, categoryId: categoryId)
            vc.dismiss(animated: true, completion: nil)
        }
        
        present(vc, animated: true, completion: nil)
    }
}

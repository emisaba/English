import UIKit

class SelectedCategoryViewController: UIViewController {
    
    // MARK: - Properties
    
    private let identifier = "identifier"
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(SelectedCategoryViewCell.self, forCellReuseIdentifier: identifier)
        tv.rowHeight = 60
        tv.separatorInset = .zero
        return tv
    }()
    
    public var categories: [UserCategory] = [] {
        didSet { tableView.reloadData() }
    }
    
    private var downloadCellNumber: Int
    
    public var completion: ((String) -> Void)?
    
    // MARK: - LifeCycle
    
    init(cellNumber: Int) {
        downloadCellNumber = cellNumber
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCategory()
        
        view.addSubview(tableView)
        tableView.fillSuperview()
    }
    
    // MARK: - API
    
    func fetchCategory() {
        CardService.fetchUserCategories { categories in
            self.categories = categories
        }
    }
}

// MARK: - UITableViewDataSource

extension SelectedCategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! SelectedCategoryViewCell
        cell.category = categories[indexPath.row].categoryTitle
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SelectedCategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categoryID = categories[indexPath.row].categoryID
        completion?(categoryID)
    }
}


import UIKit

class SelectedCategoryViewController: UIViewController {
    
    // MARK: - Properties
    
    private let identifier = "identifier"
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(SelectedCategoryViewCell.self, forCellReuseIdentifier: identifier)
        tv.rowHeight = 120
        tv.separatorInset = .zero
        tv.tableHeaderView = createHeader()
        tv.separatorStyle = .none
        tv.backgroundColor = .clear
        return tv
    }()
    
    private let blurEffectView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blur)
        view.alpha = 0.9
        return view
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
        
        view.addSubview(blurEffectView)
        blurEffectView.fillSuperview()
        view.addSubview(tableView)
        tableView.fillSuperview()
    }
    
    // MARK: - API
    
    func fetchCategory() {
        CardService.fetchUserCategories { categories in
            self.categories = categories
        }
    }
    
    // MARK: - Helper
    
    func createHeader() -> UILabel {
        let attrubutes: [NSAttributedString.Key: Any] = [.font: UIFont.senobiBold(size: 22),
                                                         .foregroundColor: UIColor.white,
                                                         .kern: 2,]
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 120))
        label.attributedText = NSAttributedString(string: "カテゴリを選択", attributes: attrubutes)
        label.textAlignment = .center
        return label
    }
}

// MARK: - UITableViewDataSource

extension SelectedCategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! SelectedCategoryViewCell
        cell.viewModel = CategoryViewModel(category: categories[indexPath.row])
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


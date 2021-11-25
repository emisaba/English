//import UIKit
//
//class SearchViewController: UITableViewController {
//
//    // MARK: - Properties
//
//    private let identifier = "identifier"
//
//    private let searchController = UISearchController(searchResultsController: nil)
//
//    // MARK: - Lifecycle
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        configureSearchController()
//        configureTableView()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        navigationController?.navigationBar.isHidden = false
//    }
//
//    // MARK: - Actions
//
//    // MARK: - Helpers
//
//    func configureTableView() {
//        tableView.register(SearchCell.self, forCellReuseIdentifier: identifier)
//        tableView.rowHeight = 64
//    }
//
//    func configureSearchController() {
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = "Search"
//        navigationController?.navigationItem.searchController = searchController
//        navigationController?.navigationItem.hidesSearchBarWhenScrolling = false
//    }
//}
//
//
//// MARK: - UITableViewDataSource
//
//extension SearchViewController {
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! SearchCell
//        return cell
//    }
//}

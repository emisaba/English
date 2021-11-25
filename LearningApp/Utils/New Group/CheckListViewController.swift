//import UIKit
//import WCLShineButton
//
//class CheckListViewController: UITableViewController {
//
//    // MARK: - Properties
//
//    private let identifier = "identifier"
//
//    private lazy var  shineButton: WCLShineButton = {
//        var params = WCLShineParams()
//        params.bigShineColor = .systemYellow
//        params.smallShineColor = .systemPink
//        params.shineSize = 8
//
//        let button = WCLShineButton(frame: CGRect(x: 18, y: 0, width: 30, height: 30), params: params)
//        button.params = params
//        button.color = .clear
//        button.fillColor = .clear
//        button.addTarget(self, action: #selector(didTapCheck), for: .valueChanged)
//        return button
//    }()
//
//    // MARK: - Lifecycle
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        configureTableView()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        navigationController?.navigationBar.isHidden = false
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        tableView.addSubview(shineButton)
//    }
//
//    // MARK: - Actions
//
//    @objc func didTapCheck() {
//
//    }
//
//    // MARK: - Helpers
//
//    func configureTableView() {
//        tableView.register(CheckListCell.self, forCellReuseIdentifier: identifier)
//        tableView.rowHeight = 76
//        tableView.separatorInset = .zero
//    }
//}
//
//
//// MARK: - UITableViewDataSource
//
//extension CheckListViewController {
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CheckListCell
//        return cell
//    }
//}
//
//// MARK: - UITableViewDelegate
//
//extension CheckListViewController {
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        shineButton.setClicked(true)
//
//        guard let cell = tableView.cellForRow(at: indexPath) else { return }
//        shineButton.center.y = cell.frame.origin.y + 38
//    }
//}

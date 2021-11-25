//import UIKit
//import ViewAnimator
//
//class BigCategoryViewController: UIViewController {
//
//    // MARK: - Properties
//
//    private let segment = CustomSegmentControl()
//
//    private lazy var collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.dataSource = self
//        cv.delegate = self
//        return cv
//    }()
//
//    private lazy var calenderView: CalenderView = {
//        let view = CalenderView()
////        view.delegate = self
//        return view
//    }()
//
//    private let identifier = "identifier"
//
//    private lazy var addCategoryButton: UIButton = {
//        let button = UIButton()
//        button.backgroundColor = .systemPink
//        button.clipsToBounds = true
//        button.layer.cornerRadius = 25
//        button.layer.shadowOffset = CGSize(width: 5, height: 5)
//        button.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
//        button.layer.shadowRadius = 5
//        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
//        return button
//    }()
//
//    private lazy var alert: CustomAlertView = {
//        let view = CustomAlertView()
////        view.delegate = self
//        return view
//    }()
//
//    private let backgroundView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .black
//        view.alpha = 0
//        return view
//    }()
//
//    private var selectedImage: UIImage?
//    private var bigCategoryTitle: String?
//
//    let dammyImages = [UIImage(named: "avichi"), UIImage(named: "pooh"), UIImage(named: "back")]
//    let dammyTitle = ["avichi", "winnie the pooh", "back to the future"]
//
//    // MARK: - Lifecycle
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
////        configureCollectionView()
//        configureUI()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        navigationController?.navigationBar.isHidden = true
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        let fromAnimation = AnimationType.from(direction: .top, offset: 300)
//        UIView.animate(views: self.collectionView.visibleCells, animations: [fromAnimation], duration: 1)
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        segment.frame = CGRect(x: 0, y: view.safeAreaInsets.top + 8, width: 250, height: 50)
//        segment.center.x = view.frame.width / 2
//        view.addSubview(segment)
//
//        view.addSubview(calenderView)
//        calenderView.anchor(top: segment.bottomAnchor,
//                            left: view.leftAnchor,
//                            bottom: view.safeAreaLayoutGuide.bottomAnchor,
//                            right: view.rightAnchor,
//                            paddingTop: 10)
//    }
//
//    // MARK: - Helpers
//
//    func configureUI() {
//        view.backgroundColor = .white
//
//        view.addSubview(addCategoryButton)
//        addCategoryButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
//                         right: view.rightAnchor,
//                         paddingBottom: 30, paddingRight: 30)
//        addCategoryButton.setDimensions(height: 50, width: 50)
//
//        view.addSubview(backgroundView)
//        backgroundView.fillSuperview()
//
//        view.addSubview(alert)
//        alert.frame = CGRect(x: 0, y: -350, width: view.frame.width - 40, height: 350)
//        alert.center.x = view.frame.width / 2
//    }
//
//    func configureCollectionView() {
//        view.addSubview(collectionView)
//        collectionView.fillSuperview()
//        collectionView.backgroundColor = .white
//        collectionView.register(CategoryView.self, forCellWithReuseIdentifier: identifier)
//    }
//
//    // MARK: - Actions
//
//    @objc func didTapAddButton() {
//        UIView.animate(withDuration: 0.3) {
//            self.backgroundView.alpha = 0.5
//        } completion: { _ in
//            UIView.animate(withDuration: 0.3) {
//                self.alert.frame.origin.y = self.view.center.y - 400
//            }
//        }
//    }
//}
//
//// MARK: - UICollectionViewDataSource
//
//extension BigCategoryViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return dammyImages.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CategoryView
//        cell.imageView.image = dammyImages[indexPath.row]
//        cell.titleLabel.text = dammyTitle[indexPath.row]
//        return cell
//    }
//}
//
//// MARK: - UICollectionViewDelegate
//
////extension BigCategoryViewController: UICollectionViewDelegate {
////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
////        return CGSize(width: view.frame.width, height: 100)
////    }
////
////    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
////        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
////        let frameSize = cell.frame
////
////        if let categories = categories {
////            let category = categories[indexPath.row]
////
////            let vc = CollectionViewController(category: category, frame: frameSize)
////            vc.modelPresentationStyle = .fullScreen
////            present(vc, animated: false)
////        }
////    }
////}
//
//// MARK: - UICollectionViewDelegateFlowLayout
//
//extension BigCategoryViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//}
//
//// MARK: - UIImagePickerControllerDelegate
//
//extension BigCategoryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        guard let image = info[.editedImage] as? UIImage else { return }
//        selectedImage = image
//        alert.plusPhotoButton.setImage(image, for: .normal)
//
//        dismiss(animated: true, completion: nil)
//    }
//}
//
//// MARK: - CustomAlertViewDelegate
//
////extension BigCategoryViewController: CustomAlertViewDelegate {
////    func showNextPage(title: String) {
//
////        CreateCardService.createNewCategory(categoryInfo: title) { error in
////            if let error = error {
////                print(error.localizedDescription)
////                return
////            }
//
////        let vc = SmallCategoryViewController(bigCategoryInfo: cardInfo)
////            vc.modelPresentationStyle = .fullScreen
////            self.present(vc, animated: true)
////        }
////    }
//
////    func imagePicker() {
////        let imagePicker = UIImagePickerController()
////        imagePicker.delegate = self
////        imagePicker.allowsEditing = true
////        present(imagePicker, animated: true)
////    }
////}
//
//// MARK: - CalenderViewDelegate
//
////extension BigCategoryViewController: CalenderViewDelegate {
////    func search() {
////        let vc = SearchViewController()
////        navigationController?.pushViewController(vc, animated: true)
////    }
////
////    func checkList() {
////        let vc = CheckListViewController()
////        navigationController?.pushViewController(vc, animated: true)
////    }
////}

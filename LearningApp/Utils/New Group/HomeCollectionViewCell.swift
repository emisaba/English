//import UIKit
//import SDWebImage
//
//class HomeViewCollectionViewCell: UICollectionViewCell {
//    
//    var viewmodel: CategoryViewModel? {
//        didSet { configureUI() }
//    }
//    
//    private let imageView: UIImageView = {
//        let iv = UIImageView()
//        iv.contentMode = .scaleAspectFill
//        iv.clipsToBounds = true
//        return iv
//    }()
//    
//    var indexPath: Int?
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        addSubview(imageView)
//        imageView.fillSuperview()
//    }
//    
//    func configureUI() {
//        guard let viewmodel = viewmodel else { return }
//        imageView.sd_setImage(with: viewmodel.imageUrl)
//        
//        let imageData: [String: Any] = ["imageURL": viewmodel.imageUrl ?? URL(fileURLWithPath: ""), "indexPath": indexPath ?? 0]
////        guard let imageUrl = viewmodel.imageUrl else { return }
//        NotificationCenter.default.post(name: Notification.Name("image"), object: imageData)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}

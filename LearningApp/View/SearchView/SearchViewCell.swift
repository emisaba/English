import UIKit
import SDWebImage

protocol SearchViewCellDelegate {
    func download(cellNumber: Int)
}

class SearchViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    public var delegate: SearchViewCellDelegate?
    
    public var viewModel: SearchCollectionViewModel? {
        didSet { configureViewModel() }
    }
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 15
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "pooh")
        return iv
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "ユーザー"
        label.font = .lexendDecaRegular(size: 12)
        return label
    }()
    
    private let cardImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 5
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "back")
        return iv
    }()
    
    private let sentenceCountLabel: UILabel = {
        let label = UILabel()
        label.text = "フレーズ: 12"
        label.textAlignment = .center
        label.textColor = .white
        label.font = .lexendDecaBold(size: 16)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "タイトル"
        label.textAlignment = .center
        label.textColor = .white
        label.font = .lexendDecaBold(size: 16)
        return label
    }()
    
    private let wordCountLabel: UILabel = {
        let label = UILabel()
        label.text = "単語: 12"
        label.textAlignment = .center
        label.textColor = .white
        label.font = .lexendDecaBold(size: 16)
        return label
    }()
    
    private lazy var downloadButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "pooh"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.backgroundColor = .systemYellow
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(didTapDownloadButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Action
    
    @objc func didTapDownloadButton() {
        guard let cellNumber = viewModel?.cellNumber else { return }
        delegate?.download(cellNumber: cellNumber)
    }
    
    // MARK: - Helper
    
    func configureUI() {
        
        addSubview(iconImageView)
        iconImageView.anchor(top: topAnchor,
                             left: leftAnchor,
                             paddingTop: 10,
                             paddingLeft: 10)
        iconImageView.setDimensions(height: 30, width: 30)
        
        addSubview(userNameLabel)
        userNameLabel.anchor(left: iconImageView.rightAnchor,
                             paddingLeft: 10)
        userNameLabel.centerY(inView: iconImageView)
        
        addSubview(cardImageView)
        cardImageView.anchor(top: iconImageView.bottomAnchor,
                             left: leftAnchor,
                             bottom: bottomAnchor, right: rightAnchor,
                             paddingTop: 10)
        
        addSubview(downloadButton)
        downloadButton.anchor(bottom: bottomAnchor,
                              paddingBottom: -30)
        downloadButton.centerX(inView: self)
        downloadButton.setDimensions(height: 60, width: 60)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, sentenceCountLabel, wordCountLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        
        addSubview(stackView)
        stackView.centerY(inView: cardImageView)
        stackView.centerX(inView: cardImageView)
    }
    
    func configureViewModel() {
        guard let viewModel = viewModel else { return }
        
        titleLabel.text = viewModel.title
        userNameLabel.text = viewModel.userName
        iconImageView.sd_setImage(with: viewModel.userImageUrl, completed: nil)
        cardImageView.sd_setImage(with: viewModel.cardImageUrl, completed: nil)
    }
}

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
    
    private lazy var cardImageView = createImageView(cornerRadius: 5)
    
    private let effectView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blur)
        view.alpha = 0.5
        return view
    }()
    
    private lazy var titleLabel = createLabel(firstText: "", secondText: "", size: 28)
    
    private lazy var sentenceCountLabel = createLabel(firstText: "センテンス\n", secondText: "12", size: 28)
    private lazy var wordCountLabel = createLabel(firstText: "単語\n", secondText: "12", size: 28)
    
    private lazy var downloadButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "import"), for: .normal)
        button.backgroundColor = UIColor.darkColor()
        button.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(didTapDownloadButton), for: .touchUpInside)
        button.layer.borderColor = UIColor.white.withAlphaComponent(0.8).cgColor
        button.layer.borderWidth = 2
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
        
        addSubview(cardImageView)
        cardImageView.anchor(top: topAnchor,
                             left: leftAnchor,
                             bottom: bottomAnchor,
                             right: rightAnchor,
                             paddingTop: 10,
                             paddingRight: 30)
        
        cardImageView.addSubview(effectView)
        effectView.fillSuperview()
        
        cardImageView.addSubview(titleLabel)
        titleLabel.anchor(top: cardImageView.topAnchor, paddingTop: 20)
        titleLabel.centerX(inView: cardImageView)
        
        createStackView()
        
        addSubview(downloadButton)
        downloadButton.anchor(right: rightAnchor)
        downloadButton.centerY(inView: cardImageView)
        downloadButton.setDimensions(height: 60, width: 60)
    }
    
    func configureViewModel() {
        guard let viewModel = viewModel else { return }
        
        titleLabel.text = viewModel.title
        cardImageView.sd_setImage(with: viewModel.cardImageUrl, completed: nil)
    }
    
    func createImageView(cornerRadius: CGFloat) -> UIImageView {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        iv.layer.borderColor = UIColor.white.withAlphaComponent(0.8).cgColor
        iv.layer.borderWidth = 1.5
        return iv
    }
    
    func createLabel(firstText: String, secondText: String, size: CGFloat) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .senobiMedium(size: size)
        label.numberOfLines = 0
        
        let firstAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.senobiMedium(size: 16)]
        let secondAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.senobiBold(size: 20)]
        
        let attributesText = NSMutableAttributedString(string: firstText, attributes: firstAttributes)
        attributesText.append(NSAttributedString(string: secondText, attributes: secondAttributes))
        
        label.attributedText = attributesText
        
        return label
    }
    
    func createStackView() {
        let stackView = UIStackView(arrangedSubviews: [sentenceCountLabel, wordCountLabel])
        stackView.spacing = 20
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        cardImageView.addSubview(stackView)
        stackView.anchor(bottom: bottomAnchor, paddingBottom: 30)
        stackView.centerX(inView: cardImageView)
        
        let stackViewFrame = UIView()
        stackViewFrame.backgroundColor = .clear
        stackViewFrame.layer.borderColor = UIColor.white.withAlphaComponent(0.8).cgColor
        stackViewFrame.layer.borderWidth = 1.5
        stackViewFrame.layer.cornerRadius = 5
        
        addSubview(stackViewFrame)
        stackViewFrame.anchor(top: stackView.topAnchor,
                              left: stackView.leftAnchor,
                              bottom: stackView.bottomAnchor,
                              right: stackView.rightAnchor,
                              paddingTop: -10,
                              paddingLeft: -10,
                              paddingBottom: -8,
                              paddingRight: -10)
        
        let stackViewDivider = UIView()
        stackViewDivider.backgroundColor = .white.withAlphaComponent(0.8)
        
        addSubview(stackViewDivider)
        stackViewDivider.anchor(top: stackViewFrame.topAnchor,
                                bottom: stackViewFrame.bottomAnchor,
                                width: 1.5)
        stackViewDivider.centerX(inView: stackViewFrame)
    }
}

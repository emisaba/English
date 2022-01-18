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
    
    private lazy var titleLabel = createLabel()
    private lazy var sentenceCountLabel = createLabel()
    private lazy var wordCountLabel = createLabel()
    
    private lazy var downloadButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "import"), for: .normal)
        button.backgroundColor = UIColor.clear
        button.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(didTapDownloadButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var downloadBackground = createBlurView(radius: 30)
    private lazy var stackBackground = createBlurView(radius: 5)
    
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
        
        addSubview(downloadBackground)
        downloadBackground.anchor(right: rightAnchor)
        downloadBackground.centerY(inView: cardImageView)
        downloadBackground.setDimensions(height: 60, width: 60)
        
        addSubview(downloadButton)
        downloadButton.centerY(inView: downloadBackground)
        downloadButton.centerX(inView: downloadBackground)
        downloadButton.setDimensions(height: 60, width: 60)
    }
    
    func configureViewModel() {
        guard let viewModel = viewModel else { return }
        
        cardImageView.sd_setImage(with: viewModel.cardImageUrl, completed: nil)
        
        titleLabel.attributedText = createAtributesText(firstText: viewModel.title,
                                                        secondText: "",
                                                        size: 22,
                                                        isTitle: true)
        sentenceCountLabel.attributedText = createAtributesText(firstText: "センテンス\n",
                                                                secondText: viewModel.sentenceCount,
                                                                size: 16,
                                                                isTitle: false)
        wordCountLabel.attributedText = createAtributesText(firstText: "単語\n",
                                                            secondText: viewModel.wordCount,
                                                            size: 18, isTitle: false)
    }
    
    func createImageView(cornerRadius: CGFloat) -> UIImageView {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        iv.layer.borderColor = UIColor.white.withAlphaComponent(0.15).cgColor
        iv.layer.borderWidth = 1.5
        return iv
    }
    
    func createLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }
    
    func createStackView() {
        
        cardImageView.addSubview(stackBackground)
        stackBackground.anchor(bottom: bottomAnchor, paddingBottom: 22)
        stackBackground.centerX(inView: cardImageView)
        stackBackground.setDimensions(height: 68, width: 230)
        
        let stackView = UIStackView(arrangedSubviews: [sentenceCountLabel, wordCountLabel])
        stackView.spacing = 20
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        cardImageView.addSubview(stackView)
        stackView.anchor(bottom: bottomAnchor, paddingBottom: 30)
        stackView.centerX(inView: cardImageView)
        stackView.setDimensions(height: 50, width: 210)

        let stackViewDivider = UIView()
        stackViewDivider.backgroundColor = .white.withAlphaComponent(0.2)

        addSubview(stackViewDivider)
        stackViewDivider.anchor(top: stackBackground.topAnchor,
                                bottom: stackBackground.bottomAnchor,
                                paddingTop: 10,
                                paddingBottom: 10,
                                width: 1.5)
        stackViewDivider.centerX(inView: stackBackground)
    }
    
    func createBlurView(radius: CGFloat) -> UIVisualEffectView {
        let blur = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blur)
        view.layer.cornerRadius = radius
        view.clipsToBounds = true
        view.alpha = 0.8
        return view
    }
    
    func createAtributesText(firstText: String, secondText: String, size: CGFloat, isTitle: Bool) -> NSAttributedString {
        let font = isTitle ? UIFont.lexendDecaBold(size: size) : UIFont.senobiMedium(size: size)
        let kern = isTitle ? 2 : 0
        
        let firstAttributes: [NSAttributedString.Key: Any] = [.font: font, .kern: kern]
        let secondAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.senobiBold(size: size)]
        
        let attributesText = NSMutableAttributedString(string: firstText, attributes: firstAttributes)
        attributesText.append(NSAttributedString(string: secondText, attributes: secondAttributes))
        
        return attributesText
    }
}

import UIKit
import AVFoundation

enum QuestionType {
    case all
    case inCorrect
    case correct
}

protocol ItemViewCellDelegate {
    func shoudShowJapanese(show: Bool)
    func questionType(type: QuestionType)
}

class ItemViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    public var delegate: ItemViewCellDelegate?
    
    public var viewModel: ItemViewModel? {
        didSet { configureViewModel() }
    }
    
    private var japaneseOptionLabel: UILabel = {
        let label = UILabel()
        label.font = .lexendDecaRegular(size: 16)
        label.textColor = .white
        let attrubutes: [NSAttributedString.Key: Any] = [.font: UIFont.lexendDecaRegular(size: 14), .kern: 5]
        label.attributedText = NSAttributedString(string:  "Japanese", attributes: attrubutes)
        return label
    }()
    
    private lazy var japaneseOffSwitch: UISwitch = {
        let sw = UISwitch()
        sw.addTarget(self, action: #selector(didSwitch), for: .touchUpInside)
        sw.tintColor = .white
        sw.onTintColor = .systemGray
        return sw
    }()
    
    private lazy var questionTypeSegment: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["全て", "未正解のみ", "正解のみ"])
        sc.tintColor = .white
        sc.backgroundColor = .white
        sc.selectedSegmentTintColor = .systemGray
        sc.addTarget(self, action: #selector(didChangeSegment), for: .valueChanged)
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    public let borderFrame: UIView = {
        let view = UIView()
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func didSwitch(sender: UISwitch) {
        
        if sender.isOn {
            delegate?.shoudShowJapanese(show: true)
        } else {
            delegate?.shoudShowJapanese(show: false)
        }
    }
    
    @objc func didChangeSegment(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            delegate?.questionType(type: .all)
        case 1:
            delegate?.questionType(type: .inCorrect)
        case 2:
            delegate?.questionType(type: .correct)
        default:
            break
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        
        backgroundColor = .clear
        clipsToBounds = true
        
        borderFrame.frame = CGRect(x: 0, y: -10, width: frame.width + 20, height: 100)
        addSubview(borderFrame)
        
        japaneseOptionLabel.frame = CGRect(x: 20, y: 0, width: frame.width, height: frame.height)
        addSubview(japaneseOptionLabel)
        
        japaneseOffSwitch.frame = CGRect(x: frame.width - 50, y: 0, width: 0, height: frame.height)
        contentView.addSubview(japaneseOffSwitch)
        
        questionTypeSegment.frame = CGRect(x: 0, y: 0, width: frame.width - 20, height: frame.height)
        questionTypeSegment.center.x = frame.width / 2 + 5
        contentView.addSubview(questionTypeSegment)
    }
    
    func configureViewModel() {
        guard let viewModel = viewModel else { return }
        
        japaneseOptionLabel.isHidden = viewModel.shouldHideJapanse
        japaneseOffSwitch.isHidden = viewModel.shouldHideJapanse
        
        questionTypeSegment.isHidden = viewModel.shouldHideSegment
        
        borderFrame.isHidden = viewModel.shoudlHideBorder
        borderFrame.layer.cornerRadius = viewModel.borderCornerRadius
        borderFrame.frame = CGRect(x: 0, y: viewModel.borderY,
                                   width: frame.width, height: viewModel.borderHeight)
    }
}

import UIKit

class DictionaryViewController: UIReferenceLibraryViewController {
    
    // MARK: - Properties
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    private let createCardView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    private let EnglishLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 5
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var inputJapaneseTextField: CustomTextField = {
        let tf = CustomTextField(placeholderText: "")
        tf.textColor = .black
        tf.backgroundColor = .clear
        tf.tintColor = .lightGray
        tf.attributedPlaceholder = NSAttributedString(string:  " 意味を入力",
                                                   attributes: [.font: UIFont.senobiMedium(size: 16),
                                                                .foregroundColor: UIColor.lightGray])
        return tf
    }()
    
    private lazy var createCardButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightColor()
        button.addTarget(self, action: #selector(createCardButton(sender:)), for: .touchUpInside)
        
        let attrubutes: [NSAttributedString.Key: Any] = [.font: UIFont.senobiBold(size: 20), .foregroundColor: UIColor.white]
        let attributeTitle = NSAttributedString(string: "カードを作成", attributes: attrubutes)
        button.setAttributedTitle(attributeTitle, for: .normal)
        
        return button
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        
        let attrubutes: [NSAttributedString.Key: Any] = [.font: UIFont.senobiBold(size: 18), .foregroundColor: UIColor.darkGray, .kern: 2]
        let attributeTitle = NSAttributedString(string: "登録", attributes: attrubutes)
        button.setAttributedTitle(attributeTitle, for: .normal)
        return button
    }()
    
    private let blurEffectView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blur)
        view.alpha = 0.15
        return view
    }()
    
    public var completion: (([String]?) -> Void)?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoader(false)
        
        configureUI()
    }
    
    // MARK: - Actions
    
    @objc func createCardButton(sender: UIButton) {
        UIView.animate(withDuration: 0.25) {
            self.backgroundView.alpha = 0.3
            
        } completion: { done in
            if done {
                UIView.animate(withDuration: 0.25) {
                    self.createCardView.layer.cornerRadius = 25
                    self.createCardView.frame.origin.y = 150
                    self.createCardButton.setDimensions(height: 70, width: self.createCardView.frame.width)
                }
            }
        }
    }
    
    @objc func didTapDoneButton(sender: UIButton) {
        
        guard let english = EnglishLabel.text else { return }
        guard let japanese = inputJapaneseTextField.text else { return }
        
        completion?([english, japanese])
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.addSubview(backgroundView)
        backgroundView.fillSuperview()
        
        view.addSubview(createCardView)
        createCardView.frame = CGRect(x: 0,
                                      y: view.frame.height - 90,
                                      width: view.frame.width,
                                      height: view.frame.height)
        
        createCardView.addSubview(createCardButton)
        createCardButton.anchor(top: createCardView.topAnchor,
                      left: view.leftAnchor,
                      right: view.rightAnchor,
                      height: 90)
        
        createCardView.addSubview(EnglishLabel)
        EnglishLabel.anchor(top: createCardButton.bottomAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingTop: 30,
                         height: 50)
        
        createCardView.addSubview(inputJapaneseTextField)
        inputJapaneseTextField.anchor(top: EnglishLabel.bottomAnchor,
                                 left: view.leftAnchor,
                                 right: view.rightAnchor,
                                 paddingTop: 20,
                                 paddingLeft: 30,
                                 paddingRight: 30,
                                 height: 50)
        
        let inputJapaneseFieldLine = UIView()
        inputJapaneseFieldLine.backgroundColor = .darkGray
        inputJapaneseTextField.addSubview(inputJapaneseFieldLine)
        inputJapaneseFieldLine.anchor(left: inputJapaneseTextField.leftAnchor,
                                     bottom: inputJapaneseTextField.bottomAnchor,
                                     right: inputJapaneseTextField.rightAnchor,
                                     height: 0.5)
        
        view.addSubview(blurEffectView)
        blurEffectView.anchor(top: inputJapaneseTextField.bottomAnchor,
                              left: view.leftAnchor,
                              right: view.rightAnchor,
                              paddingTop: 40,
                              paddingLeft: 30,
                              paddingRight: 30,
                              height: 60)
        
        view.addSubview(doneButton)
        doneButton.anchor(top: inputJapaneseTextField.bottomAnchor,
                          left: view.leftAnchor,
                          right: view.rightAnchor,
                          paddingTop: 40,
                          paddingLeft: 30,
                          paddingRight: 30,
                          height: 60)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
        UIView.animate(withDuration: 0.25) {
            self.backgroundView.alpha = 0
            
        } completion: { done in
            if done {
                UIView.animate(withDuration: 0.25) {
                    self.createCardView.layer.cornerRadius = 0
                    self.createCardView.frame.origin.y = self.view.frame.height - 90
                    self.createCardButton.setDimensions(height: 90, width: self.createCardView.frame.width)
                }
            }
        }
    }
    
    func setEnglishWord(text: String) {
        let attrubutes: [NSAttributedString.Key: Any] = [.font: UIFont.lexendDecaBold(size: 22), .foregroundColor: UIColor.black, .kern: 2]
        let attributeText = NSAttributedString(string: text, attributes: attrubutes)
        EnglishLabel.attributedText = attributeText
    }
}

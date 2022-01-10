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
        return view
    }()
    
    let inputEnglishView: UITextView = {
        let view = UITextView()
        view.layer.cornerRadius = 5
        view.font = .lexendDecaBold(size: 22)
        view.textColor = .darkGray
        view.textAlignment = .center
        return view
    }()
    
    private lazy var inputJapaneseView: UITextField = {
        let view = UITextField()
        view.backgroundColor = .lightGray.withAlphaComponent(0.3)
        view.layer.cornerRadius = 5
        view.font = .lexendDecaRegular(size: 18)
        view.textColor = .black
        
        let attrubutes: [NSAttributedString.Key: Any] = [.font: UIFont.senobiBold(size: 16), .foregroundColor: UIColor.lightGray]
        view.attributedPlaceholder = NSAttributedString(string: "意味を入力してください", attributes: attrubutes)
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: view.frame.height))
        view.leftView = leftView
        view.leftViewMode = .always
        
        return view
    }()
    
    private lazy var createCardButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemPink
        button.addTarget(self, action: #selector(createCardButton(sender:)), for: .touchUpInside)
        
        let attrubutes: [NSAttributedString.Key: Any] = [.font: UIFont.senobiBold(size: 20), .foregroundColor: UIColor.white]
        let attributeTitle = NSAttributedString(string: "カードを作成", attributes: attrubutes)
        button.setAttributedTitle(attributeTitle, for: .normal)
        return button
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapDoneButton(sender:)), for: .touchUpInside)
        button.layer.cornerRadius = 30
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.darkGray.cgColor
        
        let attrubutes: [NSAttributedString.Key: Any] = [.font: UIFont.senobiBold(size: 18), .foregroundColor: UIColor.darkGray, .kern: 2]
        let attributeTitle = NSAttributedString(string: "登録", attributes: attrubutes)
        button.setAttributedTitle(attributeTitle, for: .normal)
        return button
    }()
    
    public var completion: (([String]?) -> Void)?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoader(false)
        
        view.addSubview(backgroundView)
        backgroundView.fillSuperview()
        
        view.addSubview(createCardView)
        createCardView.frame = CGRect(x: 0,
                                      y: view.frame.height - 90,
                                      width: view.frame.width,
                                      height: view.frame.height)
        createCardView.backgroundColor = .white
        
        createCardView.addSubview(createCardButton)
        createCardButton.anchor(top: createCardView.topAnchor,
                      left: view.leftAnchor,
                      right: view.rightAnchor,
                      height: 90)
        
        createCardView.addSubview(inputEnglishView)
        inputEnglishView.anchor(top: createCardButton.bottomAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingTop: 30,
                         height: 50)
        
        createCardView.addSubview(inputJapaneseView)
        inputJapaneseView.anchor(top: inputEnglishView.bottomAnchor,
                                 left: view.leftAnchor,
                                 right: view.rightAnchor,
                                 paddingTop: 20,
                                 paddingLeft: 20,
                                 paddingRight: 20,
                                 height: 50)
        
        createCardView.addSubview(doneButton)
        doneButton.anchor(top: inputJapaneseView.bottomAnchor,
                          paddingTop: 40)
        doneButton.setDimensions(height: 60, width: 100)
        doneButton.centerX(inView: view)
    }
    
    // MARK: - Actions
    
    @objc func createCardButton(sender: UIButton) {
        UIView.animate(withDuration: 0.25) {
            self.backgroundView.alpha = 0.5
            
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
        
        guard let english = inputEnglishView.text else { return }
        guard let japanese = inputJapaneseView.text else { return }
        
        completion?([english, japanese])
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
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
}

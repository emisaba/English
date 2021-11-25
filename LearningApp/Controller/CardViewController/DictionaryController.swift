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
        view.font = .lexendDecaBold(size: 20)
        view.textColor = .black
        view.textAlignment = .center
        return view
    }()
    
    private let inputJapaneseView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.3)
        view.layer.cornerRadius = 5
        view.font = .lexendDecaRegular(size: 18)
        view.textColor = .black
        view.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return view
    }()
    
    private lazy var createCardButton: UIButton = {
        let button = UIButton()
        button.setTitle("カードを作成", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemPink
        button.addTarget(self, action: #selector(createCardButton(sender:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemPink
        button.addTarget(self, action: #selector(didTapDoneButton(sender:)), for: .touchUpInside)
        button.layer.cornerRadius = 30
        return button
    }()
    
    public var completion: (([String]?) -> Void)?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                          left: view.leftAnchor,
                          right: view.rightAnchor,
                          paddingTop: 40,
                          paddingLeft: 60,
                          paddingRight: 60,
                          height: 60)
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

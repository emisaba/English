//import UIKit
//import AVFoundation
//
//let SAMPLE_RATE = 16000
//
//protocol TapNextDelegate: AnyObject {
//    func didTapNextButton()
//}
//
//protocol TapFunctionDelegate: AnyObject {
//    func didTapCameraButton()
//    func didTapMicButton()
//}
//
////class CreateCardView: UIView {
//
//    // MARK: - Properties
//
//    var textView: UITextView = {
//        let textView = UITextView()
//        textView.backgroundColor = .systemGray
//        return textView
//    }()
//
//    private lazy var cameraButton = createButton(image: #imageLiteral(resourceName: "camera"), selector: #selector(didTapCameraButton))
//    private lazy var micButton = createButton(image: #imageLiteral(resourceName: "camera"), selector: #selector(didTapMicButton))
//    private lazy var nextPageButton = createButton(title: "next", selector: #selector(didTapNext))
//
//    weak var tapFunctionDelegate: TapFunctionDelegate?
//    weak var tapNextDelegate: TapNextDelegate?
//
//    // MARK: - Lifecycle
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        backgroundColor = .white
//        configureUI()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // MARK: - Actions
//
//    @objc func didTapCameraButton() {
//        tapFunctionDelegate?.didTapCameraButton()
//    }
//
//    @objc func didTapMicButton(_ sender: UIButton) {
//        tapFunctionDelegate?.didTapMicButton()
//    }
//
//    @objc func didTapNext(sender: UIButton) {
//        tapNextDelegate?.didTapNextButton()
//    }
//
//    // MARK: - Helpers
//
//    func configureUI() {
//
//        addSubview(nextPageButton)
//        nextPageButton.anchor(left: leftAnchor,
//                               bottom: safeAreaLayoutGuide.bottomAnchor,
//                               right: rightAnchor,
//                               paddingLeft: 25,
//                               paddingBottom: 25,
//                               paddingRight: 25)
//        
//        let buttonStackView = UIStackView(arrangedSubviews: [UIView(),
//                                                             cameraButton,
//                                                             UIView(),
//                                                             micButton,
//                                                             UIView()])
//        buttonStackView.distribution = .fillEqually
//
//        addSubview(buttonStackView)
//        buttonStackView.anchor(left: leftAnchor,
//                               bottom: nextPageButton.topAnchor,
//                               right: rightAnchor,
//                               paddingLeft: 25,
//                               paddingBottom: 25,
//                               paddingRight: 25)
//
//        addSubview(textView)
//        textView.anchor(top: safeAreaLayoutGuide.topAnchor,
//                        left: leftAnchor,
//                        bottom: buttonStackView.topAnchor,
//                        right: rightAnchor,
//                        paddingTop: 20,
//                        paddingLeft: 20,
//                        paddingBottom: 20,
//                        paddingRight: 20)
//    }
//
//    func createButton(image: UIImage? = nil, title: String? = nil, selector: Selector) -> UIButton {
//        let button = UIButton(type: .system)
//        button.setImage(image, for: .normal)
//        button.setTitle(title, for: .normal)
//        button.addTarget(self, action: selector, for: .touchUpInside)
//        return button
//    }
//}

import UIKit
import AVFoundation
import Firebase
import MLKitTextRecognition
import MLImage
import MLKit

class CameraViewController: UIViewController {
    
    // MARK: - Properties
    
    public var captureSession: AVCaptureSession?
    public let output = AVCaptureVideoDataOutput()
    
    public let previewLayer = AVCaptureVideoPreviewLayer()
    public let targetAreaView = UIImageView()
    
    private lazy var captureButton = createButton(selector: #selector(didTapCaptureButton), image: #imageLiteral(resourceName: "circle"), isCapture: true)
    private lazy var resetButton = createButton(selector: #selector(didTapResetButton), image: #imageLiteral(resourceName: "refresh"), isCapture: false)
    private lazy var closeButton = createButton(selector: #selector(didTapCloseButton), image: #imageLiteral(resourceName: "arrow-down"), isCapture: false)
    
    private lazy var capturedTextView: CustomTextView = {
        let tv = CustomTextView()
        tv.textColor = .white
        tv.delegate = self
        tv.keyboardDelegate = self
        tv.isScrollEnabled = false
        tv.backgroundColor = .clear
        tv.font = .lexendDecaRegular(size: 16)
        return tv
    }()
    
    private lazy var translatedTextView: UITextView = {
        let tv = UITextView()
        tv.textColor = .white
        tv.delegate = self
        tv.isScrollEnabled = false
        tv.backgroundColor = .blue
        return tv
    }()
    
    public let backgroundImageView = UIImageView()
    
    private lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = view.bounds
        visualEffectView.alpha = 0.95
        return visualEffectView
    }()
    
    private var textRecognizer = TextRecognizer.textRecognizer()
    
    private var capturedWords = [String]()
    private var isWords = false
    
    private var wordInfos = [WordInfo]()
    
    private var cardInfo: CategoryInfo?
    private var category: UserCategory?
    
    private lazy var targetViewframeWidth = view.frame.width - 40
    private var targetViewframeHeight: CGFloat = 30
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkCameraPermissions()
        configureUI()
        configureGesture()
    }
    
    // MARK: - Actions
    
    @objc func didTapCaptureButton() {
        captureSession?.stopRunning()
        
        guard let inputImage = targetAreaView.image else { return }
        let visionImage = VisionImage(image: inputImage)
        
        textRecognizer.process(visionImage, completion: { features, error in

            guard let features = features else { return }

            for block in features.blocks {
                for line in block.lines {
                    for element in line.elements {
                        self.capturedWords.append(element.text)
                        self.isWords = true
                    }
                }
            }
            self.capturedTextView.text = self.capturedWords.joined(separator: " ")
        })
        captureSession?.startRunning()
    }
    
    @objc func didTapResetButton() {
        capturedWords = []
        isWords = false
        capturedTextView.text = ""
        translatedTextView.text = ""
    }
    
    @objc func didTapCloseButton() {
        NotificationCenter.default.post(name: Notification.Name("capturedWords"), object: capturedWords)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleTargetAreaSize(sender: UIPinchGestureRecognizer) {
        let scale = sender.scale
        
        switch sender.state {
        case .changed:
            targetAreaView.frame = CGRect(x: 0, y: 200,
                                          width: targetViewframeWidth,
                                          height: targetViewframeHeight * scale)
            targetAreaView.center.x = view.frame.width / 2
            
        case .ended:
            targetViewframeHeight = targetViewframeHeight * scale
            
        default:
            break
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.addSubview(backgroundImageView)
        backgroundImageView.frame = view.bounds
    
        view.addSubview(blurView)

        view.addSubview(captureButton)
        captureButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                             paddingBottom: 20)
        captureButton.setDimensions(height: 80, width: 80)
        captureButton.centerX(inView: view)
        
        view.addSubview(resetButton)
        resetButton.anchor(right: view.rightAnchor,
                           paddingRight: 30)
        resetButton.setDimensions(height: 30, width: 30)
        resetButton.centerY(inView: captureButton)
        
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                           right: view.rightAnchor,
                           paddingRight: 20)
        closeButton.setDimensions(height: 40, width: 40)
        
        view.addSubview(targetAreaView)
        targetAreaView.frame = CGRect(x: 0, y: 200,
                                      width: targetViewframeWidth,
                                      height: targetViewframeHeight)
        targetAreaView.center.x = view.frame.width / 2
        targetAreaView.contentMode = .scaleAspectFit
        
        view.addSubview(capturedTextView)
        capturedTextView.anchor(top: targetAreaView.bottomAnchor,
                        left: view.leftAnchor,
                        right: view.rightAnchor,
                        paddingTop: 30,
                        paddingLeft: 20,
                        paddingRight: 20,
                        height: 150)
    }
    
    func createButton(selector: Selector, image: UIImage, isCapture: Bool) -> UIButton {
        let button = UIButton()
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.setImage(image, for: .normal)
        
        if isCapture {
            button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.cornerRadius = 40
        }
        
        return button
    }
    
    func configureGesture() {
        let panGesture = UIPinchGestureRecognizer(target: self, action: #selector(handleTargetAreaSize))
        view.addGestureRecognizer(panGesture)
    }
}

// MARK: - UITextViewDelegate

extension CameraViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)

        textView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.capturedTextView.resignFirstResponder()
    }
}

// MARK: - CustomTextViewDelegate

extension CameraViewController: CustomTextViewDelegate {
    
    func keyboardWillHide() {
        UIView.animate(withDuration: 0.25) {
            self.view.frame.origin.y = 0
        }
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        self.capturedWords = textView.text.components(separatedBy: " ")
    }
}

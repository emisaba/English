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
    
    private lazy var captureButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(didTapCaptureButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var resetButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPurple
        button.addTarget(self, action: #selector(didTapResetButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPurple
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }()
    
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
    
    private var sentenceInfo: SentenceInfo = SentenceInfo(sentence: "", transratedSentence: "", sentenceArray: [""])
    
    private var cardInfo: CategoryInfo?
    private var category: Category?
    
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
                             right: view.rightAnchor,
                             paddingBottom: 20,
                             paddingRight: 20)
        captureButton.setDimensions(height: 50, width: 50)
        captureButton.layer.cornerRadius = 25
        
        view.addSubview(resetButton)
        resetButton.anchor(left: view.leftAnchor,
                          bottom: view.safeAreaLayoutGuide.bottomAnchor,
                          paddingLeft: 20,
                          paddingBottom: 20)
        resetButton.setDimensions(height: 50, width: 50)
        resetButton.layer.cornerRadius = 25
        
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                           right: view.rightAnchor,
                           paddingTop: 20,
                           paddingRight: 20)
        closeButton.setDimensions(height: 50, width: 50)
        closeButton.layer.cornerRadius = 25
        
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

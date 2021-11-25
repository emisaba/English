import UIKit
import Speech

class SpeakingCardView: CardView {
    
    // MARK: - Properties
    
    private lazy var micButton = createButton(image: #imageLiteral(resourceName: "camera"), selector: #selector(didTapMicButton))
    public lazy var speakingLabel = createLabel(language: nil)
    
    public let speechRecognizer = SFSpeechRecognizer()
    public let request = SFSpeechAudioBufferRecognitionRequest()
    public let audioEngine = AVAudioEngine()
    public var task: SFSpeechRecognitionTask?
    
    // MARK: - Lifecycle
    
    override init(viewmodel: CardViewmodel, type: CardType, shouldHideJapanese: Bool) {
        super.init(viewmodel: viewmodel, type: type, shouldHideJapanese: shouldHideJapanese)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func didTapMicButton() {
        startRecording()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        
        englishLabel.font = .lexendDecaRegular(size: 18)
        addSubview(englishLabel)
        englishLabel.anchor(top: topAnchor,
                                    left: leftAnchor,
                                    right: rightAnchor,
                                    paddingTop: 30,
                                    paddingLeft: 20,
                                    paddingRight: 20,
                                    height: 80)
        englishLabel.centerX(inView: self)
        englishLabel.text = viewmodel.sentenceEnglish
        
        addSubview(showAnswerView)
        showAnswerView.anchor(top: englishLabel.bottomAnchor,
                                   left: leftAnchor,
                                   right: rightAnchor,
                                   paddingTop: 30,
                                   paddingLeft: 20,
                                   paddingRight: 20,
                                   height: 150)
        showAnswerView.centerX(inView: self)
        showAnswerView.englishArray = viewmodel.englishArray
        
        addSubview(micButton)
        micButton.anchor(top: showAnswerView.bottomAnchor,
                         paddingTop: 30)
        micButton.centerX(inView: self)
        micButton.setDimensions(height: 80, width: 80)
        
        speakingLabel.font = .lexendDecaBold(size: 20)
        speakingLabel.backgroundColor = .lightGray.withAlphaComponent(0.3)
        speakingLabel.layer.cornerRadius = 5
        addSubview(speakingLabel)
        speakingLabel.anchor(top: micButton.bottomAnchor,
                             left: leftAnchor,
                             bottom: bottomAnchor,
                             right: rightAnchor,
                             paddingTop: 30,
                             paddingLeft: 20,
                             paddingBottom: 30,
                             paddingRight: 20)
    }
}

import UIKit
import AVFoundation

class ShadowingCardView: CardView {
    
    // MARK: - Properties
    
    private lazy var stepper : CustomStepper = {
        let stepper = CustomStepper()
        stepper.setDimensions(height: 50, width: 200)
        stepper.delegate = self
        return stepper
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.text = "\(setValue)"
        label.textColor = .black
        label.font = .lexendDecaBold(size: 18)
        return label
    }()
    
    private var setValue: Int = 0
    private lazy var playCount: Int = setValue
    
    private var shadowingCount: Int?
    
    // MARK: - Lifecycle
    
    override init(viewmodel: CardViewmodel, type: CardType, shouldHideJapanese: Bool) {
        super.init(viewmodel: viewmodel, type: type, shouldHideJapanese: shouldHideJapanese)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc override func didTapStartButton() {
        prepareToSpeech()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        
        addSubview(englishLabel)
        englishLabel.textAlignment = .center
        englishLabel.anchor(top: topAnchor,
                            left: leftAnchor,
                            right: rightAnchor,
                            paddingTop: 50,
                            paddingLeft: 10,
                            paddingRight: 10)
        
        addSubview(japaneseLabel)
        japaneseLabel.isHidden = shouldHideJapanese
        japaneseLabel.textAlignment = .center
        japaneseLabel.anchor(top: englishLabel.bottomAnchor,
                            left: leftAnchor,
                            right: rightAnchor,
                            paddingTop: 30,
                            paddingLeft: 10,
                            paddingRight: 10)
        
        let stackView = UIStackView(arrangedSubviews: [countLabel, stepper])
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: japaneseLabel.bottomAnchor,
                         paddingTop: 50)
        stackView.setDimensions(height: 50, width: 300)
        stackView.centerX(inView: self)
        
        addSubview(startButton)
        startButton.anchor(top: stackView.bottomAnchor,
                           paddingTop: 50)
        startButton.centerX(inView: self)
    }
    
    func prepareToSpeech() {
        TextToSpeechService.speechSynthesizer.delegate = self
        
        if playCount > 0 {
            TextToSpeechService.startSpeech(text: self.viewmodel.sentenceEnglish)
        } else {
            playCount = setValue
        }
    }
}

// MARK: - CustomStepperDelegate

extension ShadowingCardView: CustomStepperDelegate {
    
    func setMinus() {
        setValue -= 1
        
        let value = max(0, setValue)
        countLabel.text = "\(value)"
    }
    
    func setPlus() {
        setValue += 1
        
        let value = min(10, setValue)
        countLabel.text = "\(value)"
    }
}

// MARK: - AVSpeechSynthesizerDelegate

extension ShadowingCardView: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        playCount -= 1
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
            self.prepareToSpeech()
        }
    }
}

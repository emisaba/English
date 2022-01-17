import UIKit
import AVFoundation

class ShadowingCardView: CardView {
    
    // MARK: - Properties
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.text = "\(setValue)"
        label.textColor = .white
        label.font = .lexendDecaBold(size: 18)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var minusButton = createButton(symbol: "-")
    private lazy var plusButton = createButton(symbol: "+")
    
    private var setValue: Int = 0
    private lazy var playCount: Int = setValue
    
    private var shadowingCount: Int?
    
    // MARK: - Lifecycle
    
    override init(viewModel: CardViewModel, type: CardType, shouldHideJapanese: Bool, id: ID) {
        super.init(viewModel: viewModel, type: type, shouldHideJapanese: shouldHideJapanese, id: id)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc override func didTapStartButton() {
        prepareToSpeech()
    }
    
    @objc func didChangeValue(sender: UIButton) {
        
        switch sender {
        case minusButton:
            setValue -= 1
            
            let value = max(0, setValue)
            countLabel.text = "\(value)"
            
        case plusButton:
            setValue += 1
            
            let value = min(10, setValue)
            countLabel.text = "\(value)"
            
        default:
            break
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        
        let stackView = UIStackView(arrangedSubviews: [minusButton, countLabel, plusButton])
        stackView.spacing = 10
        stackView.distribution = .fillEqually

        addSubview(stackView)
        stackView.setDimensions(height: 50, width: 170)
        stackView.centerX(inView: self)
        stackView.centerY(inView: self)
        
        addSubview(englishLabel)
        englishLabel.textAlignment = .center
        englishLabel.anchor(left: leftAnchor,
                            bottom: stackView.topAnchor,
                            right: rightAnchor,
                            paddingLeft: 20,
                            paddingBottom: 50,
                            paddingRight: 20)
        
        addSubview(startButton)
        startButton.anchor(top: stackView.bottomAnchor,
                           paddingTop: 50)
        startButton.centerX(inView: self)
    }
    
    func prepareToSpeech() {
        TextToSpeechService.speechSynthesizer.delegate = self
        
        if playCount > 0 {
            TextToSpeechService.startSpeech(text: self.viewModel.sentenceEnglish)
        } else {
            playCount = setValue
        }
    }
    
    func createButton(symbol: String) -> UIButton {
        let button = UIButton()
        button.setTitle(symbol, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray.withAlphaComponent(0.3)
        button.addTarget(self, action: #selector(didChangeValue(sender:)), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
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

import UIKit

class DictationCardView: CardView {
    
    // MARK: - Properties
    
    private lazy var dictationTextView = createTextView()
    
    private lazy var answerCollectionView: DictationAnswerView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let cv = DictationAnswerView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    // MARK: - Lifecycle
    
    override init(viewModel: CardViewModel, type: CardType, shouldHideJapanese: Bool, id: ID) {
        super.init(viewModel: viewModel, type: type, shouldHideJapanese: shouldHideJapanese, id: id)
        
        configureUI()
        dictationTextView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        
        addSubview(startButton)
        startButton.anchor(top: topAnchor,
                           paddingTop: 60)
        startButton.centerX(inView: self)
        startButton.setDimensions(height: 80, width: 80)
        
        addSubview(japaneseLabel)
        japaneseLabel.anchor(top: startButton.bottomAnchor,
                             left: leftAnchor,
                             right: rightAnchor,
                             paddingTop: 30,
                             paddingLeft: 10,
                             paddingRight: 10)
        japaneseLabel.centerX(inView: self)
        japaneseLabel.text = viewModel.sentenceJapanese
        
        addSubview(dictationTextView)
        dictationTextView.anchor(top: japaneseLabel.bottomAnchor,
                                 left: leftAnchor,
                                 right: rightAnchor,
                                 paddingTop: 30,
                                 paddingLeft: 20,
                                 paddingRight: 20,
                                 height: 250)
        
        addSubview(answerCollectionView)
        answerCollectionView.anchor(top: japaneseLabel.bottomAnchor,
                                    left: leftAnchor,
                                    right: rightAnchor,
                                    paddingTop: 30,
                                    paddingLeft: 20,
                                    paddingRight: 20,
                                    height: 250)
        answerCollectionView.isHidden = true
    }
    
    func showAnswer() {
        if textViewTextCount > 0 { return }

        let answerArray = self.viewModel.sentenceEnglish.lowercased().components(separatedBy: " ")
        self.answerCollectionView.answerArray = answerArray
        self.answerCollectionView.correctInputNumbers = []

        self.answerCollectionView.isHidden = false
        self.dictationTextView.isHidden = true
    }
}

// MARK: - UITextViewDelegate

extension DictationCardView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        changeTextColorIfCorrect(textView: textView)
        didTapAnswerButton(textView: textView)
    }
    
    func changeTextColorIfCorrect(textView: UITextView) {
        if textView.text.lowercased() == viewModel.sentenceEnglish.lowercased() {
            textView.textColor = .systemGreen
        }
    }
    
    func didTapAnswerButton(textView: UITextView) {
        NotificationCenter.default.addObserver(forName: Notification.Name("didTapAnswerButton"), object: nil, queue: .main) { _ in
            textView.isHidden = true
            
            if textView.text.count > 0 {
                self.searchCorrctWordInInputArray(textView: textView)
            }
        }
    }
    
    func searchCorrctWordInInputArray(textView: UITextView) {
        
        let inputTextArray = textView.text.lowercased().components(separatedBy: " ")
        let answerArray = self.viewModel.sentenceEnglish.lowercased().components(separatedBy: " ")
        
        var correctWordNumber = 0
        var correctWordNumbers = [Int]()
        
        answerArray.forEach { word in
            correctWordNumber += 1
            
            inputTextArray.forEach { inputWord in
                if word == inputWord {
                    correctWordNumbers.append(correctWordNumber)
                }
            }
        }
        
        self.answerCollectionView.answerArray = answerArray
        self.answerCollectionView.correctInputNumbers = correctWordNumbers
        self.answerCollectionView.isHidden = false
    }
}

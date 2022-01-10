import UIKit

class ShowAnswerView: UICollectionView {
    
    // MARK: - Properties
    
    private let identifier = "identifier"
    
    public var englishArray = [String]()  {
        didSet { reloadData() }
    }
    
    private var modifiedWordArray = [String]()
    private var correctInputWord = ""
    
    public var shouldShowAnswer = false {
        didSet { reloadData() }
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        layer.cornerRadius = 5
        backgroundColor = .lightGray.withAlphaComponent(0.3)
        dataSource = self
        register(ShowAnswerViewCell.self, forCellWithReuseIdentifier: identifier)
        
        ditectSpeech()
        
        NotificationCenter.default.addObserver(forName: Notification.Name("targetWord"), object: nil, queue: .main) { notification in
            
            guard let targetWord = notification.object as? String else { return }
            
            self.englishArray.forEach { word in
                if word.lowercased() == targetWord.lowercased() {
                    self.modifiedWordArray.append(word)
                    self.reloadData()
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func ditectSpeech() {
        NotificationCenter.default.addObserver(forName: Notification.Name("speach"), object: nil, queue: .main) { notification in
            guard let correctInputWord = notification.object as? String else { return }
            
            self.englishArray.forEach { word in
                let modifiedWord = word.replacingOccurrences(of: "?", with: "")
                    .replacingOccurrences(of: ",", with: "")
                    .replacingOccurrences(of: ".", with: "")
                
                if modifiedWord == correctInputWord {
                    self.modifiedWordArray.append(word)
                    self.reloadData()
                }
            }
        }
    }
    
    func showAnswerIfInputIsCorrect(cell: ShowAnswerViewCell) {
        modifiedWordArray.forEach { word in
            if cell.label.text == word {
                cell.label.isHidden = false
                
                let attrubutes: [NSAttributedString.Key: Any] = [.font: UIFont.lexendDecaRegular(size: 16),
                                                                 .foregroundColor: UIColor.white,
                                                                 .kern: 1]
                
                cell.label.attributedText = NSAttributedString(string: word, attributes: attrubutes)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ShowAnswerView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return englishArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ShowAnswerViewCell
        
        cell.label.text = englishArray[indexPath.row]
        cell.label.isHidden = shouldShowAnswer ? false : true
        cell.label.textColor = .systemRed
        
        showAnswerIfInputIsCorrect(cell: cell)
        
        return cell
    }
}

import UIKit

class InputAnswerView: UICollectionView {
    
    // MARK: - Properties
    
    private let identifier = "identifier"
    
    private var checkWord = 0
    public var englishArray = [String]() {
        didSet {
            shuffledArray = englishArray.shuffled()
            reloadData()
        }
    }
    
    private var shuffledArray = [String]()
    public var cardType: CardType?
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        backgroundColor = .lightGray.withAlphaComponent(0.3)
        contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layer.cornerRadius = 5
        
        delegate = self
        dataSource = self
        register(InputAnswerViewCell.self, forCellWithReuseIdentifier: identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func shakeCellIfInputWordIsIncorrect(cell: UICollectionViewCell) {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: cell.center.x - 5, y: cell.center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: cell.center.x + 5, y: cell.center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        cell.layer.add(shake, forKey: nil)
    }
    
    func checkIfAnswerIsCorrect(targetCell: InputAnswerViewCell, targetCellNumber: Int) {
        let targetWord = shuffledArray[targetCellNumber]
        
        if targetWord == englishArray[checkWord] {
            NotificationCenter.default.post(name: Notification.Name("targetWord"), object: targetWord)
            targetCell.backgroundColor = .white
            targetCell.label.textColor = .lightGray
            
            checkWord += 1
        } else {
            shakeCellIfInputWordIsIncorrect(cell: targetCell)
        }
    }
    
    func showDictionaryView(targetCellNumber: Int) {
        NotificationCenter.default.post(name: Notification.Name("targetWord"), object: englishArray[targetCellNumber])
    }
}

// MARK: - UICollectionViewDataSource

extension InputAnswerView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shuffledArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! InputAnswerViewCell
        
        if cardType == .listening || cardType == .writing {
            cell.labelText = shuffledArray[indexPath.row]
        } else {
            cell.labelText = englishArray[indexPath.row]
        }
        
        return cell
    }
}


// MARK: - UICollectionViewDelegate

extension InputAnswerView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? InputAnswerViewCell else { return }
        
        switch cardType {
        case .listening, .writing:
            checkIfAnswerIsCorrect(targetCell: cell, targetCellNumber: indexPath.row)
            
        case .speaking:
            TextToSpeechService.startSpeech(text: englishArray[indexPath.row])
            
        case .capture:
            showDictionaryView(targetCellNumber: indexPath.row)
            
        default:
            break
        }
        
    }
}

// MARK: UICollectionViewDelegateFlowlayout

extension InputAnswerView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

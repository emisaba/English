import UIKit

class DictationAnswerView: UICollectionView {
    
    // MARK: - Properties
    
    public var answerArray: [String] = [] {
        didSet { reloadData() }
    }
    
    public var correctInputNumbers: [Int]  = [] {
        didSet { reloadData() }
    }
    
    private var identifier = "identifier"
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        layer.cornerRadius = 5
        backgroundColor = .systemGray.withAlphaComponent(0.3)
        contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        register(DictationAnswerViewCell.self, forCellWithReuseIdentifier: identifier)
        dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
}

// MARK: - UICollectionViewDataSource

extension DictationAnswerView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return answerArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! DictationAnswerViewCell
        cell.textLabel.text = answerArray[indexPath.row]
        searchCorrctTextInAnswerArray(cell: cell, indexPath: indexPath.row)
        return cell
    }
    
    func searchCorrctTextInAnswerArray(cell: DictationAnswerViewCell, indexPath: Int) {
        correctInputNumbers.forEach { correctInputNumber in
            if cell.textLabel.textColor == .systemGray { return }
            let answerArrayNumber = indexPath + 1
            
            if correctInputNumber == answerArrayNumber {
                cell.textLabel.textColor = .systemGray
            } else {
                cell.textLabel.textColor = .systemRed
            }
        }
    }
}

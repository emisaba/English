import UIKit

extension CardView {
    
    func createLabel(language: String? = nil) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .lexendDecaRegular(size: 16)
        label.textColor = .systemGray
        label.textAlignment = cardType == .shadowing ? .left : .center
        label.text = cardType == .speaking ? nil : language
        return label
    }
    
    func createButton(image: UIImage, selector: Selector) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .systemPurple
        button.layer.cornerRadius = 25
        button.setDimensions(height: 50, width: 50)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
    
    func createTextView() -> UITextView {
        let textView = UITextView()
        textView.backgroundColor = .lightGray.withAlphaComponent(0.3)
        textView.layer.cornerRadius = 5
        textView.font = .lexendDecaRegular(size: 16)
        textView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        if cardType == .capture {
            textView.setDimensions(height: 200, width: 100)
        } else {
            textView.setDimensions(height: cardType == .dictation ? 230 : 150, width: 100)
        }
        
        textView.inputAccessoryView = createToolBar()
        
        return textView
    }
    
    func createToolBar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneButton))
        toolBar.items = [spacer, doneButton]
        
        return toolBar
    }
}

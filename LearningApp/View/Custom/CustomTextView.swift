import UIKit

protocol CustomTextViewDelegate {
    func keyboardWillHide()
}

class CustomTextView: UITextView {
    
    // MARK: - Properties
    
    public var keyboardDelegate: CustomTextViewDelegate?
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func keyboardWillHide(notification: Notification) {
        keyboardDelegate?.keyboardWillHide()
    }
}

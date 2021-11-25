//import UIKit
//
//// MARK: - CalenderViewDelegate
//
//extension TopViewController: CalenderViewDelegate {
//
//    func didTapToday() {
//        UIView.animate(withDuration: 0.25) {
//            self.diaryView.frame.origin.y = 0
//            self.diaryView.diaryTextView.isEditable = true
//            self.diaryView.diaryTextView.becomeFirstResponder()
//        }
//    }
//
//    func didTapOtherDay(dateForURL: Date) {
//
//        UIView.animate(withDuration: 0.25) {
//            self.diaryBackgroundView.backgroundColor = .black.withAlphaComponent(0.7)
//            self.diaryView.frame.origin.y = 100
//            self.diaryView.selectedDate = dateForURL
//            self.diaryView.diaryTextView.isEditable = false
//        }
//    }
//
//    func showMenuBar() {
//        UIView.animate(withDuration: 0.25) {
//            self.diaryBackgroundView.backgroundColor = .black.withAlphaComponent(0)
//        }
//    }
//
//    func hideMenuBar() {
////        UIView.animate(withDuration: 0.25) {
////            self.blackView.backgroundColor = .black.withAlphaComponent(0.7)
////        }
//    }
//
//    func search() {
////        let vc = SearchViewController()
////        navigationController?.pushViewController(vc, animated: true)
//    }
//}
//
//// MARK: - DiaryViewDelegate
//
//extension TopViewController: DiaryViewDelegate {
//
//    func didTapSave(textView: UITextView) {
//
//        UIView.animate(withDuration: 0.25) {
//            self.diaryBackgroundView.backgroundColor = .black.withAlphaComponent(0)
//            self.diaryView.frame.origin.y = self.view.frame.height + 100
//            textView.resignFirstResponder()
//        }
//    }
//}

import UIKit

struct UserCollection {
    let categoryID: String
    let collectionID: String
    let collectionTitle: String
    let collectionImageUrl: String
    let userName: String
    let usesrImageUrl: String
    let currentUid: String
    let sentenceCount: Int
    let wordCount: Int
    
    init(data: [String: Any]) {
        self.categoryID = data["categoryID"] as? String ?? ""
        self.collectionID = data["collectionID"] as? String ?? ""
        self.collectionTitle = data["collectionTitle"] as? String ?? ""
        self.collectionImageUrl = data["collectionImageUrl"] as? String ?? ""
        self.userName = data["userName"] as? String ?? ""
        self.usesrImageUrl = data["usesrImageUrl"] as? String ?? ""
        self.currentUid = data["currentUid"] as? String ?? ""
        self.sentenceCount = data["sentenceCount"] as? Int ?? 0
        self.wordCount = data["wordCount"] as? Int ?? 0
    }
}

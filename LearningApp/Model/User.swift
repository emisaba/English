import UIKit

struct User {
    let name: String
    let iconImageUrl: String
    let uid: String
    
    init(data: [String: Any]) {
        self.name = data["name"] as? String ?? ""
        self.iconImageUrl = data["iconImageUrl"] as? String ?? ""
        self.uid = data["uid"] as? String ?? ""
    }
}

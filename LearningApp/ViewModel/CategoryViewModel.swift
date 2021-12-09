import UIKit

struct CategoryViewModel {
    let category: UserCategory
    
    var categoryTitle: String? {
        return self.category.categoryTitle
    }
    
    var imageUrl: URL? { return URL(string: self.category.imageUrl) }
    
    init(category: UserCategory) {
        self.category = category
    }
}

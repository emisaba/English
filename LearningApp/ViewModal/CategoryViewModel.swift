import UIKit

struct CategoryViewmodel {
    let category: Category
    
    var categoryTitle: String? {
        return self.category.categoryTitle
    }
    
    var collectionTitle: String? {
        return self.category.collectionTitle
    }
    
    var imageUrl: URL? { return URL(string: self.category.imageUrl) }
    
    init(category: Category) {
        self.category = category
    }
}

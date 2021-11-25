import UIKit
import Firebase

struct CreateCardService {
    
    static func createNewCategory(categoryInfo: CategoryInfo, completioin: @escaping((Error?) -> Void)) {
        
        let categoryTitle = categoryInfo.categoryTitle
        let collectionTitle = categoryInfo.collectionTitle
        guard let image = categoryInfo.image else { return }
        
        ImageUploader.uploadCategoryImage(image: image) { imageUrl in
            
            let categoryData: [String: Any] = ["categoryTitle": categoryTitle,
                                               "imageUrl": imageUrl]
            
            let collectionData: [String: Any] = ["collectionTitle": collectionTitle,
                                                 "imageUrl": imageUrl]
            
            let ref = COLLECTION_CATEGORIES.document(categoryTitle)
            
            ref.setData(categoryData) { _ in
                ref.collection(categoryTitle)
                    .document(collectionTitle)
                    .setData(collectionData, completion: completioin)
            }
        }
    }
    
    static func createCollection(categoryInfo: CategoryInfo, completion: @escaping((Error?) -> Void)) {
        
        let categoryTitle = categoryInfo.categoryTitle
        let collectionTitle = categoryInfo.collectionTitle
        guard let image = categoryInfo.image else { return }
        
        ImageUploader.uploadCollectionImage(image: image) { imageUrl in
            
            let data: [String: Any] = ["collectionTitle": collectionTitle,
                                       "imageUrl": imageUrl]
            
            COLLECTION_CATEGORIES.document(categoryTitle)
                .collection(categoryTitle)
                .document(collectionTitle)
                .setData(data, completion: completion)
        }
    }
    
    static func registerNewCards(categoryInfo: CategoryInfo, completion: @escaping ((Error?) -> Void )) {
        
        let categoryTitle = categoryInfo.categoryTitle
        let collectionTitle = categoryInfo.collectionTitle
        guard let sentence = categoryInfo.sentence?.sentence else { return }
        guard let transratedSentence = categoryInfo.sentence?.transratedSentence else { return }
        guard let sentenceArray = categoryInfo.sentence?.sentenceArray else { return }
        
        let sentenceData: [String: Any] = ["sentence": sentence,
                                           "translatedSentence": transratedSentence,
                                           "sentenceArray": sentenceArray]
        
        let path = COLLECTION_CATEGORIES.document(categoryTitle).collection(categoryTitle).document(collectionTitle)
        
        path.collection("sentence").addDocument(data: sentenceData) { _ in
            
            guard let words = categoryInfo.word else { return }
            
            words.forEach { word in
                let wordData: [String: Any] = ["word": word.word,
                                               "translatedWord": word.translatedWord]
                
                path.collection("word").addDocument(data: wordData, completion: completion)
            }
        }
    }
    
    static func saveSentenceTestResult(categoryInfo: CategoryInfo, cardID: String, correct: Bool, completion: @escaping((Error?) -> Void)) {
        
        let categoryTitle = categoryInfo.categoryTitle
        let collectionTitle = categoryInfo.collectionTitle
        let data: [String: Any] = ["correct": correct]
        
        let path = COLLECTION_CATEGORIES.document(categoryTitle).collection(categoryTitle).document(collectionTitle)
        path.collection("sentence").document(cardID).updateData(data, completion: completion)
    }
    
    static func saveWordTestResult(categoryInfo: CategoryInfo, cardID: String, correct: Bool, completion: @escaping((Error?) -> Void)) {
        
        let categoryTitle = categoryInfo.categoryTitle
        let collectionTitle = categoryInfo.collectionTitle
        let data: [String: Any] = ["correct": correct]
        
        let path = COLLECTION_CATEGORIES.document(categoryTitle).collection(categoryTitle).document(collectionTitle)
        path.collection("word").document(cardID).updateData(data, completion: completion)
    }
    
    static func fetchSentence(categoryInfo: CategoryInfo, completion: @escaping([Sentence]) -> Void) {
        
        let categoryTitle = categoryInfo.categoryTitle
        let collectionTitle = categoryInfo.collectionTitle
        
        COLLECTION_CATEGORIES.document(categoryTitle)
            .collection(categoryTitle).document(collectionTitle)
            .collection("sentence").getDocuments { snapshot, error in
                
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            let sentences = documents.map { Sentence(sentenceID: $0.documentID, dictionary: $0.data()) }
            completion(sentences)
        }
    }
    
    static func fetchWord(categoryInfo: CategoryInfo, completion: @escaping(([Word]) -> Void)) {
        let categoryTitle = categoryInfo.categoryTitle
        let collectionTitle = categoryInfo.collectionTitle
        
        COLLECTION_CATEGORIES.document(categoryTitle)
            .collection(categoryTitle).document(collectionTitle)
            .collection("word").getDocuments { snapshot, error in
                
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let documents = snapshot?.documents else { return }
            let words = documents.map { Word(wordID: $0.documentID, dictionary: $0.data()) }
                
            completion(words)
        }
    }
    
    static func fetchCategories(completion: @escaping(([Category]) -> Void)) {
        
        COLLECTION_CATEGORIES.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            
            let categories = documents.map { Category(dictionary: $0.data()) }
            completion(categories)
        }
    }
    
    static func fetchCollections(categoryTitle: String, completion: @escaping (([Collection]) -> Void)) {
        
        COLLECTION_CATEGORIES.document(categoryTitle)
            .collection(categoryTitle).getDocuments { snapshot, error in
                
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            let collections = documents.map { Collection(dictionary: $0.data() ) }
            
            completion(collections)
        }
    }
}

import UIKit
import Firebase

struct ID {
    let category: String
    let collection: String
}

struct CardService {
    
    static func createUserCategory(categoryInfo: CategoryInfo, completion: @escaping((ID) -> Void)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let categoryTitle = categoryInfo.categoryTitle
        let collectionTitle = categoryInfo.collectionTitle
        guard let image = categoryInfo.image else { return }
        
        ImageUploader.uploadCategoryImage(image: image) { imageUrl in
            
            let categoryRef = COLLECTION_CATEGORIES.document()
            let categoryID = categoryRef.documentID
            
            let collectionRef = COLLECTION_COLLECTIONS.document()
            let collectionID = collectionRef.documentID
            
            COLLECTION_USERS.document(currentUid).getDocument { snapshot, _ in
                guard let userName = snapshot?.get("userName") else { return }
                guard let usesrImageUrl = snapshot?.get("imageUrl") else { return }
                
                let collectionData: [String: Any] = ["categoryID": categoryID,
                                                     "collectionID": collectionID,
                                                     "collectionTitle": collectionTitle,
                                                     "collectionImageUrl": imageUrl,
                                                     "userName": userName,
                                                     "usesrImageUrl": usesrImageUrl]
            
                collectionRef.setData(collectionData) { error in
                    
                    let categoryData: [String: Any] = ["categoryID": categoryID,
                                                       "categoryTitle": categoryTitle,
                                                       "imageUrl": imageUrl,
                                                       "currentUid": currentUid]
                    
                    categoryRef.setData(categoryData) { _ in
                        
                        let id = ID(category: categoryID, collection: collectionID)
                        completion(id)
                    }
                }
            }
            
//            collectionRef.setData(collectionData) { _ in
//
//                let categoryData: [String: Any] = ["categoryID": categoryID,
//                                                   "categoryTitle": categoryTitle,
//                                                   "imageUrl": imageUrl,
//                                                   "currentUid": currentUid]
//
//                categoryRef.collection(collectionID).addDocument(data: [:]) { _ in
//                    categoryRef.setData(categoryData) { _ in
//
//                        let id = ID(category: categoryID, collection: collectionID)
//                        completion(id)
//                    }
//                }
//            }
        }
    }
    
    static func fetchUserCategories(completion: @escaping(([UserCategory]) -> Void)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_CATEGORIES.whereField("currentUid", isEqualTo: currentUid).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            
            let categories = documents.map { UserCategory(dictionary: $0.data()) }
            completion(categories)
        }
    }
    
    static func createUserCollection(collectionInfo: CollectionInfo, completion: @escaping(String) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let image = collectionInfo.image
        
        ImageUploader.uploadCollectionImage(image: image) { imageUrl in
            
            let collectionRef = COLLECTION_COLLECTIONS.document()
            let collectionID = collectionRef.documentID
            
            COLLECTION_USERS.document(currentUid).getDocument { snapshot, _ in
                guard let userName = snapshot?.get("userName") else { return }
                guard let usesrImageUrl = snapshot?.get("imageUrl") else { return }
                
                let collectionData: [String: Any] = ["categoryID": collectionInfo.categoryID,
                                                     "collectionID": collectionID,
                                                     "collectionTitle": collectionInfo.collectionTitle,
                                                     "collectionImageUrl": imageUrl,
                                                     "userName": userName,
                                                     "usesrImageUrl": usesrImageUrl]
                
                collectionRef.setData(collectionData) { error in
                    COLLECTION_CATEGORIES
                        .document(collectionInfo.categoryID)
                        .collection(collectionID)
                        .addDocument(data: collectionData)
                    
                    completion(collectionID)
                }
            }
        }
    }
    
    static func fetchUserCollections(categoryID: String, completion: @escaping (([UserCollection]) -> Void)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_COLLECTIONS.whereField("currentUid", isEqualTo: currentUid)
            .whereField("categoryID", isEqualTo: categoryID)
            .getDocuments { snapshot, _ in
                
            guard let documents = snapshot?.documents else { return }
            let collections = documents.map { UserCollection(data: $0.data()) }
            completion(collections)
        }
    }
    
    static func fetchAllCollection(completion: @escaping([AllCollection]) -> Void) {
        
        COLLECTION_COLLECTIONS.getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            
            let collections = documents.map { AllCollection(data: $0.data()) }
            completion(collections)
        }
    }
    
    static func createSentence(sentenceInfo: SentenceInfo, completion: @escaping (Error?) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let ref = COLLECTION_SENTENCES.document()
        let sentenceID = ref.documentID
        
        let data : [String: Any] = ["currentUid": currentUid,
                                    "categoryID": sentenceInfo.categoryID,
                                    "collectionID": sentenceInfo.collectionID,
                                    "sentenceID": sentenceID,
                                    "sentence": sentenceInfo.sentence,
                                    "transratedSentence": sentenceInfo.transratedSentence,
                                    "sentenceArray": sentenceInfo.sentenceArray]
        
        ref.setData(data, completion: completion)
    }
    
    static func createWord(wordInfo: WordInfo, completion: @escaping (Error?) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let ref = COLLECTION_WORDS.document()
        let wordID = ref.documentID
        
        let data : [String: Any] = ["currentUid": currentUid,
                                    "categoryID": wordInfo.categoryID,
                                    "collectionID": wordInfo.collectionID,
                                    "wordID": wordID,
                                    "word": wordInfo.word,
                                    "translatedWord": wordInfo.translatedWord]
        
        ref.setData(data, completion: completion)
    }
    
    static func fetchSentences(accessID: ID, completion: @escaping([Sentence]) -> Void) {
        COLLECTION_SENTENCES
            .whereField("categoryID", isEqualTo: accessID.category)
            .whereField("collectionID", isEqualTo: accessID.collection).getDocuments { snapshot, _ in
                
                guard let documents = snapshot?.documents else { return }
                let sentences = documents.map { Sentence(dictionary: $0.data()) }
                completion(sentences)
            }
    }
    
    static func fetchWords(accessID: ID, completion: @escaping([Word]) -> Void) {
        COLLECTION_WORDS
            .whereField("categoryID", isEqualTo: accessID.category)
            .whereField("collectionID", isEqualTo: accessID.collection).getDocuments { snapshot, _ in
                
                guard let documents = snapshot?.documents else { return }
                let words = documents.map { Word(dictionary: $0.data()) }
                completion(words)
            }
    }
}
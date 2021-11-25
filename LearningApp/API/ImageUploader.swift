import FirebaseStorage

struct ImageUploader {
    
    static func uploadCategoryImage(image: UIImage, completion: @escaping((String) -> Void)) {
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath:"/category_image/\(filename)")
        
        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            ref.downloadURL { url, error in
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
        }
    }
    
    static func uploadCollectionImage(image: UIImage, completion: @escaping((String) -> Void)) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let fileName = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/collection_image/\(fileName)")
        
        ref.putData(imageData, metadata: nil) { metaData, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            ref.downloadURL { url, error in
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
        }
    }
}

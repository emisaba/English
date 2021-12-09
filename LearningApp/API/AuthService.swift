import Firebase

struct AuthCredentials {
    let email: String
    let password: String
    let userName: String
    let iconImage: UIImage
}

struct AuthService {
    
    static func logUserIn(with email: String, password: String, completion: @escaping AuthDataResultCallback) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func registerUser(withCredentials credential: AuthCredentials, completion: @escaping(Error?) -> Void) {
        
        ImageUploader.uploadUserIconImage(image: credential.iconImage) { url in
            Auth.auth().createUser(withEmail: credential.email, password: credential.password) { result, _ in
                guard let uid = result?.user.uid else { return }
                
                let data = ["email": credential.email,
                            "userName": credential.userName,
                            "imageUrl": url]
                
                COLLECTION_USERS.document(uid).setData(data, completion: completion)
            }
        }
    }
}

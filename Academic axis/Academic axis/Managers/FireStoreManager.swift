 
import UIKit
import FirebaseFirestore
import FirebaseStorage
import Firebase
import FirebaseFirestoreSwift
import UserNotifications

class FireStoreManager {

    var departments = [String]()
    
    public static let shared = FireStoreManager()
  
    var dbRefUsers : CollectionReference!
    var db: Firestore!
    let imageStorage : StorageReference!
   
    init() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        dbRefUsers = db.collection("Users")
        imageStorage = Storage.storage().reference().child("ConferenceImages")
    }
    
    
    func signUp(userType: UserType,name:String,email:String,password:String , department:String,course:String) {
       
        self.checkAlreadyExistAndSignup(userType: userType, name: name, email: email.lowercased(), password: password,department:department,course:course)
    }
    
    func checkAlreadyExistAndSignup(userType:UserType,name:String,email:String,password:String,department:String,course:String) {
        
        if(email.lowercased() == Constant.Super_ADMIN_EMAIL) {
            showAlertAnyWhere(message: AlertMessages.EmailAlreadyExist)
            return
        }else {
            
          showLoading()
            
            getQueryFromFirestore(field: "email", compareValue: email) { querySnapshot in
                 
                
                if(querySnapshot.count > 0) {
                    hideLoading()
                    showAlertAnyWhere(message: AlertMessages.EmailAlreadyExist)
                }else {
                    
                    // Signup
                    
                    let data = ["userType" : userType.rawValue,"name":name , "email" : email ,"password" : password.encrypt() , "department":department, "course":course]
                    
                    self.addDataToFireStore(data: data) { _ in
                        hideLoading()
                        
                        showOkAlertAnyWhereWithCallBack(message: "Registration Success!!") {
                           
                            SceneDelegate.shared?.checkLogin()
                            
                        }
                        
                    }
                   
                }
            }
            
        }
        

}

}


extension FireStoreManager {
    
    
    func getPassword(email:String,password:String,completion: @escaping (String)->()) {
        let  query = dbRefUsers.whereField("email", isEqualTo: email)
        
        query.getDocuments { (querySnapshot, err) in
            
            if(querySnapshot?.count == 0) {
                showAlertAnyWhere(message: "Email id not found!!")
            }else {
                
                for document in querySnapshot!.documents {
                    
                    UserDefaults.standard.setValue("\(document.documentID)", forKey: "documentId")
                    if let pwd = document.data()["password"] as? String{
                        completion(pwd)
                    }else {
                        showAlertAnyWhere(message: "Something went wrong!!")
                    }
                }
            }
        }
    }
    
    
    func updatePassword(documentid:String, userData: [String:String] ,completion: @escaping (Bool)->()) {
        let  query = dbRefUsers.document(documentid)
        
        query.updateData(userData) { error in
            if let error = error {
                print("Error updating Firestore data: \(error.localizedDescription)")
                // Handle the error
            } else {
                print("Profile data updated successfully")
                completion(true)
                // Handle the success
            }
        }
    }
    
    
    func login(email:String,password:String) {
        
        let password = password.encrypt()
        showLoading()
        
        getQueryFromFirestore(field: "email", compareValue: email) { querySnapshot in
             hideLoading()
         
            if(querySnapshot.count == 0) {
                showAlertAnyWhere(message: "Email id not found!!")
            }else {
                
                let document = querySnapshot.documents.first!
                
                    if let pwd = document.data()["password"] as? String{
                    
                        if(pwd == password) {
                            
                            let name = document.data()["name"] as? String ?? ""
                            let email = document.data()["email"] as? String ?? ""
                            let userType = document.data()["userType"] as? String ?? ""
                            let department = document.data()["department"] as? String ?? ""
                            let course = document.data()["course"] as? String ?? ""
                
                            let documentID = document.documentID
                            
                            UserDefaultsManager.shared.saveData(documentID: documentID, name: name, email: email, userType: userType , department: department,course: course)

                            SceneDelegate.shared?.checkLogin()
                            
                            
                        }else {
                            showAlertAnyWhere(message: "Password doesn't match")
                        }
                    }
                
            }
         
        }
                   
    }
                
}

extension FireStoreManager {
    
    
    
    func addDataToFireStore(data:[String:Any] ,completionHandler:@escaping (Any) -> Void){
        
        dbRefUsers.addDocument(data: data) { err in
                   if let err = err {
                       showAlertAnyWhere(message: "Error adding document: \(err)")
                   } else {
                       completionHandler("success")
        }
     }
    }
    
    
 
    
    
    
}

extension FireStoreManager {
    
    
  
    func updateProfile(name:String,completion: @escaping ()->()) {
        
        showLoading()
        
        let data = ["name" : name]
        
        dbRefUsers.document(UserDefaultsManager.shared.getKey()).updateData(data) { err in
            
            hideLoading()
            
                   if let err = err {
                       showAlertAnyWhere(message: "Error adding document: \(err)")
                   } else {
                       showOkAlertAnyWhereWithCallBack(message: "Updated!!") {
                          
                          completion()
                           
            }
        }
      }
    }
    
    func getQueryFromFirestore(field:String,compareValue:String,completionHandler:@escaping (QuerySnapshot) -> Void){
         
        dbRefUsers.whereField(field, isEqualTo: compareValue).getDocuments { querySnapshot, err in
            
            if let err = err {
                
                showAlertAnyWhere(message: "Error getting documents: \(err)")
                            return
            }else {
                
                if let querySnapshot = querySnapshot {
                    return completionHandler(querySnapshot)
                }else {
                    showAlertAnyWhere(message: "Something went wrong!!")
                }
               
            }
        }
        
    }
     
    func saveImage(image: UIImage,completion: @escaping (String)->()) {
        
        showLoading()
        
        let imageName = "\(Int(Date().timeIntervalSince1970)).jpg"
        
        if let data = image.jpegData(compressionQuality: 0.3) {
            let storageRef = Storage.storage().reference().child("images/\(imageName)")
        
            let _ = storageRef.putData(data, metadata: nil) { (metadata, error) in
                hideLoading()
                if let error = error {
                    print(error)
                } else {
                    storageRef.downloadURL { (url, error) in
                        if let _ = error {
                           completion("")
                        } else {
                            print(url!.path)
                            print(url!.description)
                            completion(url!.description)
                        }
                    }
                }
            }
        }
        
    }
   

}
 

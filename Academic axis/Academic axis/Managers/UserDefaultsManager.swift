 
import Foundation

class UserDefaultsManager  {
    
    static  let shared =  UserDefaultsManager()
     
    func clearUserDefaults() {
        UserDefaults.standard.removeObject(forKey: "email")
    }

    
    func getHaveCsvRecords() -> Bool {
        return UserDefaults.standard.bool(forKey: "haveCsvRecords")
    }

    func isLoggedIn() -> Bool{
        
        let email = getEmail()
        
        if(email.isEmpty) {
            return false
        }else {
           return true
        }
      
    }
     
    func getEmail()-> String {
        
        let email = UserDefaults.standard.string(forKey: "email") ?? ""
        
        print(email)
        return email
    }
    
    
   
    func getKey()-> String {
        let documentID = UserDefaults.standard.string(forKey: "documentID") ?? ""
        return documentID
    }
    
    func getName()-> String {
       return UserDefaults.standard.string(forKey: "name") ?? ""
    }
    
    
    func getDepartment()-> String {
       return UserDefaults.standard.string(forKey: "department") ?? ""
    }
    func getCourses()-> String {
       return UserDefaults.standard.string(forKey: "course") ?? ""
    }

    func getUserType()-> UserType {
        if(UserDefaults.standard.string(forKey: "userType") == UserType.FACULTY.rawValue)  {
            return .FACULTY
        }else if(UserDefaults.standard.string(forKey: "userType") == UserType.SUPER_ADMIN.rawValue)  {
            return .SUPER_ADMIN
        }else {
            return .ADMIN
        }
    }

    func saveData(documentID:String,name:String,email:String,userType:String,department:String,course:String) {
        UserDefaults.standard.setValue(name, forKey: "name")
        UserDefaults.standard.setValue(email, forKey: "email")
        UserDefaults.standard.setValue(userType, forKey: "userType")
        UserDefaults.standard.setValue(documentID, forKey: "documentID")
        UserDefaults.standard.setValue(Date(), forKey: "lastLoginTime")
        UserDefaults.standard.setValue(department, forKey: "department")
        UserDefaults.standard.setValue(course, forKey: "course")
    }
    
    func updateName(name:String) {
        UserDefaults.standard.setValue(name, forKey: "name")
    }
  
    
}
 

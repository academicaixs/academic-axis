import Foundation
import CryptoKit

extension String {
    
   
    static let encryptionKey = "4s7v9y$B&E)H@McQfTjWnZr4u7x!A%D*"
    static let initializationVector = "y$B?E(H+MbQeThW"

  
    
    func encrypt() -> String {
        return self
        // Generate password hash using SHA256
//           let passwordData = Data(self.utf8)
//           let hash = SHA256.hash(data: passwordData)
//           let passwordHash = hash.compactMap { String(format: "%02x", $0) }.joined()
//        
//          print(passwordHash)
//          return passwordHash
    }
    
    
}

 
extension String {
    var isValidName: Bool {
        let nameRegex = "^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegex)
        return nameTest.evaluate(with: self)
    }
}


func generateRandomPassword() -> String {
    let passwordLength = 5
    let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    var password = ""
    
    for _ in 0..<passwordLength {
        let randomIndex = Int(arc4random_uniform(UInt32(characters.count)))
        let character = characters[characters.index(characters.startIndex, offsetBy: randomIndex)]
        password.append(character)
    }
    
    return password
}

 
import UIKit

class UpdatePasswordVC: UIViewController {
    
    var password = ""
    @IBOutlet weak var newpassword: UITextField!
    @IBOutlet weak var oldpassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        FireStoreManager.shared.getPassword(email: UserDefaultsManager.shared.getEmail(), password: "") { getpassword in
            self.password = getpassword
        }
        
    }
    
    @IBAction func onChangePassword(_ sender: Any) {
        
        if UserDefaultsManager.shared.getEmail() == Constant.Super_ADMIN_EMAIL {
            
            showAlert(message: "super admin password can't change")
            
            return
        }
        if checkValidData(){
            if(self.oldpassword.text! != self.password) {
                showAlert(message: "Please enter correct current password")
                return
            }
            else {
                let documentid = UserDefaults.standard.string(forKey: "documentId") ?? ""
                let userdata = ["password": (self.newpassword.text ?? "")]
                FireStoreManager.shared.updatePassword(documentid: documentid, userData: userdata) { success in
                    if success {
                        self.showAlert(message: "Password Updated Successfully.")
                    
                        self.navigationController?.popViewController(animated: true)
                        
                        // uncomment for logout
                       //UserDefaultsManager.shared.clearUserDefaults()
                       // SceneDelegate.shared?.checkLogin()
                    }
                }
            }
        }
    }
    
  
    
    @IBAction func onShowHidePassword(_ sender: UIButton) {
        
        if(sender.tag == 1) {
            let buttonImageName = oldpassword.isSecureTextEntry ? "eye" : "eye.slash"
                if let buttonImage = UIImage(systemName: buttonImageName) {
                    sender.setImage(buttonImage, for: .normal)
            }
            self.oldpassword.isSecureTextEntry.toggle()
        }
       
        if(sender.tag == 2) {
            let buttonImageName = newpassword.isSecureTextEntry ? "eye" : "eye.slash"
                if let buttonImage = UIImage(systemName: buttonImageName) {
                    sender.setImage(buttonImage, for: .normal)
            }
            self.newpassword.isSecureTextEntry.toggle()
        }
        
        if(sender.tag == 3) {
            let buttonImageName = confirmPassword.isSecureTextEntry ? "eye" : "eye.slash"
                if let buttonImage = UIImage(systemName: buttonImageName) {
                    sender.setImage(buttonImage, for: .normal)
            }
            self.confirmPassword.isSecureTextEntry.toggle()
        }
       
    }
    
    
}


extension UpdatePasswordVC {
    
    
    func checkValidData() ->Bool {
        
        if(self.oldpassword.text!.isEmpty) {
            showAlert(message: "Please enter current temporary password.")
            return false
        }
        if(self.newpassword.text!.isEmpty) {
            showAlert(message: "Please enter new password.")
            return false
        }
        if(self.confirmPassword.text!.isEmpty) {
            showAlert(message: "Please enter confirm password.")
            return false
        }
        
           if(self.newpassword.text! != self.confirmPassword.text!) {
               showAlert(message: "Password doesn't match")
            return false
        }
        
        
        return true
    }
    
}

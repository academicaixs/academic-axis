
import UIKit

class ProfileVC: UIViewController {
   
   @IBOutlet weak var loginType: UILabel!
   @IBOutlet weak var name: UITextField!
   @IBOutlet weak var email: UITextField!
   
   
   @IBOutlet weak var userImageView: UIImageView! {
       didSet {
           userImageView.layer.borderWidth = 1.0
           userImageView.layer.borderColor = AppColors.primary.cgColor
       }
   }
   

   
   override func viewDidLoad() {
        
       self.userImageView.layer.cornerRadius = self.userImageView.frame.width/2
       self.name.text = UserDefaultsManager.shared.getName()
       self.email.text = UserDefaultsManager.shared.getEmail()
       
       if( UserDefaultsManager.shared.getUserType() == .SUPER_ADMIN) {
           self.loginType.text = "Super Admin"
       }else {
           self.loginType.text = UserDefaultsManager.shared.getUserType().rawValue.capitalized
       }
      
   }
   
   
   
   @IBAction func onLogout(_ sender: Any) {
       UserDefaultsManager.shared.clearUserDefaults()
       SceneDelegate.shared!.checkLogin()
   }
   
       
    
   }

 
import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var lockButton: UIButton!
    @IBOutlet weak var password: UITextField!
    
    
    let walkthroughs = [
      ATCWalkthroughModel(title: "Welcome", subtitle: "", icon: "northwest1"),
      ATCWalkthroughModel(title: "Welcome", subtitle: "", icon: "northwest2"),
      ATCWalkthroughModel(title: "Welcome", subtitle: "", icon: "northwest3"),
    ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let walkthroughVC = self.walkthroughVC()
//        walkthroughVC.delegate = self
//        self.addChildViewControllerWithView(walkthroughVC)
        email.isEnabled = true
        password.isEnabled = true
    }
    
    @IBAction func onLogin(_ sender: Any) {
        
        let email = email.text!.lowercased()
        
        
        if(!isValidEmail(testStr: email)) {
             showAlertAnyWhere(message: "Please enter valid email.")
            return
        }
        
        if(password.text!.isEmpty) {
             showAlertAnyWhere(message: "Please enter password.")
            return
        }
        
        
        
        if( email == Constant.Super_ADMIN_EMAIL) {
            
            if(password.text! != Constant.Super_ADMIN_PASS) {
                self.showAlert(message: AlertMessages.WrongPassword)
            }else {
                
                UserDefaultsManager.shared.saveData(documentID: "Head", name: Constant.Super_ADMIN_Name, email: Constant.Super_ADMIN_EMAIL, userType: UserType.SUPER_ADMIN.rawValue,department: "X" , course: "X")
                SceneDelegate.shared?.checkLogin()
            }
        }else {

            FireStoreManager.shared.login(email: email, password: self.password.text!)
        }
        
        
              
    }
    

    func showSessionExpireAlert() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showAlert(message:  "Session expired")
        }
        
    }
   
    
}




extension LoginVC {
    
    
    func setLockImage() {
        
        self.password.isSecureTextEntry =  !self.password.isSecureTextEntry
        
        if(self.password.isSecureTextEntry) {
            self.lockButton.setImage(UIImage(systemName: "lock"), for: .normal)
        }else {
            self.lockButton.setImage(UIImage(systemName: "lock.open"), for: .normal)
        }
    }
   
    @IBAction func onLockUnlock(_ sender: Any) {
        
        setLockImage()
    }
    
}
 

extension LoginVC :  ATCWalkthroughViewControllerDelegate{
 
  
  func walkthroughViewControllerDidFinishFlow(_ vc: ATCWalkthroughViewController) {
   /* UIView.transition(with: self.view, duration: 1, options: .transitionFlipFromLeft, animations: {
      vc.view.removeFromSuperview()
      let viewControllerToBePresented = UIViewController()
      self.view.addSubview(viewControllerToBePresented.view)
    }, completion: nil)*/
    UIView.transition(with: self.view, duration: 1, options: .transitionCrossDissolve, animations: {
      vc.view.removeFromSuperview()
      let viewControllerToBePresented = UIViewController()
      self.view.addSubview(viewControllerToBePresented.view)
    }, completion: nil)
  }
  
    fileprivate func walkthroughVC() -> ATCWalkthroughViewController {
        let viewControllers = walkthroughs.map {
            let viewController = ATCClassicWalkthroughViewController(model: $0, nibName: "ATCClassicWalkthroughViewController", bundle: nil)
            viewController.modalPresentationStyle = .fullScreen // Set modal presentation style to full screen
            return viewController
        }
        
        let vc = ATCWalkthroughViewController(nibName: "ATCWalkthroughViewController",
                                              bundle: nil,
                                              viewControllers: viewControllers)
        vc.modalPresentationStyle = .fullScreen // Set modal presentation style to full screen for the main view controller
        return vc
    }

}


import UIKit

class BackButton : UIButton {
    
    
    override func awakeFromNib() {
        
        self.addTarget(self, action:#selector(self.handleRegister), for: .touchUpInside)
        
    }
    
    @objc func handleRegister(sender: UIButton){
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            topController.dismiss(animated: true, completion: nil)
            
            topController.navigationController?.popViewController(animated: true)
            
        }
    }
    
}

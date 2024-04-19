import UIKit

 
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt32 = 0
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}


extension UITableView {
    
    func registerCells(_ cells : [UITableViewCell.Type]) {
        for cell in cells {
            self.register(UINib(nibName: String(describing: cell), bundle: Bundle.main), forCellReuseIdentifier: String(describing: cell))
        }
    }
}


extension UIApplication {
    
    var keyWindow: UIWindow? {
        // Get connected scenes
        return UIApplication.shared.connectedScenes
            // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
            // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
            // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
            // Finally, keep only the key window
            .first(where: \.isKeyWindow)
    }
    
}


extension UIApplication {
    
    var keyWindowPresentedController: UIViewController? {
        var viewController = self.keyWindow?.rootViewController
        
        // If root `UIViewController` is a `UITabBarController`
        if let presentedController = viewController as? UITabBarController {
            // Move to selected `UIViewController`
            viewController = presentedController.selectedViewController
        }
        
        // Go deeper to find the last presented `UIViewController`
        while let presentedController = viewController?.presentedViewController {
            // If root `UIViewController` is a `UITabBarController`
            if let presentedController = presentedController as? UITabBarController {
                // Move to selected `UIViewController`
                viewController = presentedController.selectedViewController
            } else {
                // Otherwise, go deeper
                viewController = presentedController
            }
        }
        
        return viewController
    }
    
}


extension UIViewController {
    
    func presentInKeyWindow(animated: Bool = true, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController?
                .present(self, animated: animated, completion: completion)
        }
    }
    
    func presentInKeyWindowPresentedController(animated: Bool = true, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            UIApplication.shared.keyWindowPresentedController?
                .present(self, animated: animated, completion: completion)
        }
    }
    
}

extension UIViewController {
    func presentImagePickerController(sourceType: UIImagePickerController.SourceType, completion: @escaping (UIImage?) -> Void) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        imagePickerController.completion = completion
        present(imagePickerController, animated: true, completion: nil)
    }
}

extension UIImagePickerController {
    private struct AssociatedKeys {
        static var completion = "completion"
    }
    
    var completion: ((UIImage?) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.completion) as? ((UIImage?) -> Void)
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.completion, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        let image = info[.originalImage] as? UIImage
        picker.completion?(image)
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        picker.completion?(nil)
    }
}




import UIKit

extension UIViewController {

   
   func showAlert(message:String,completion: ((_ success:Bool)->Void)?){
       let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
       let action = UIAlertAction(title: "Ok", style: .default) { (alert) in
           completion?(true)
       }
       alert.addAction(action)
       present(alert, animated: true, completion: nil)
   }
   
   func showAlert(message:String){
       let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
       let action = UIAlertAction(title: "Ok", style: .default) { (alert) in
           
          // completion?(true)
       }
       alert.addAction(action)
       present(alert, animated: true, completion: nil)
   }
    
    func showOkAlertWithCallBack(message:String,completion:@escaping () -> Void){
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (alert) in
            completion()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
   
   
   func restartApp() {
       print("f")
       // get a reference to the app delegate
       let appDelegate = UIApplication.shared.delegate as! AppDelegate
       
       // call didFinishLaunchWithOptions ... why?
       appDelegate.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
   }
   
   
   func  closeAllAndMoveHome() { // main
       self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
       
   }

   

       func pushVC(viewConterlerId : String)     {
           
           let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewConterlerId)
           vc.modalPresentationStyle = .fullScreen
          // vc.navigationController?.isNavigationBarHidden = true
           self.navigationController?.pushViewController(vc, animated: true)
           
           
       }
   
  
}



func showAlertAnyWhere(message:String){
   DispatchQueue.main.async {
   let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
   let action = UIAlertAction(title: "Ok", style: .default) { (alert) in
      // completion?(true)
   }
   alert.addAction(action)
   UIApplication.topViewController()!.present(alert, animated: true, completion: nil)
   }
}

func showOkAlertAnyWhereWithCallBack(message:String,completion:@escaping () -> Void){
   DispatchQueue.main.async {
   let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
   let action = UIAlertAction(title: "Ok", style: .default) { (alert) in
       completion()
   }
   alert.addAction(action)
   UIApplication.topViewController()!.present(alert, animated: true, completion: nil)
   }
  
}

func showConfirmationAlert(message: String, yesHandler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: yesHandler)
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        UIApplication.topViewController()!.present(alertController, animated: true, completion: nil)
}


extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}




func getTodayDate()->String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM d YYYY"
    return dateFormatter.string(from: Date())
}



 
 
extension UICollectionView {
    
    func registerCells(_ cells : [UICollectionViewCell.Type]) {
        for cell in cells {
            self.register(UINib(nibName: String(describing: cell), bundle: Bundle.main), forCellWithReuseIdentifier: String(describing: cell))
        }
    }
}


extension String {
    
    func hasSpecialCharacters() -> Bool {
        
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: .caseInsensitive)
            if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, self.count)) {
                return true
            }
            
        } catch {
            debugPrint(error.localizedDescription)
            return false
        }
        
        return false
    }
}

extension UIViewController {
    
    func showEditTextAlert(placeHolder:String,preString: String, completion: @escaping (String) -> Void) {
        let alert = UIAlertController(title: placeHolder, message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = placeHolder
            textField.text = preString
        }
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
            if let name = alert.textFields?.first?.text {
                
                if(name.count > 1) {
                    completion(name)
                }
                // Call the completion closure with the text field value
              
            } else {
                // Call the completion closure with nil if the text field is empty
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}

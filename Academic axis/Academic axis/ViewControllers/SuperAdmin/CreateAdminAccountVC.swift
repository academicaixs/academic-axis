import UIKit

class CreateAdminAccountVC: UIViewController {
   
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var department: UITextField!
    var globalPicker = GlobalPicker()
    
    override func viewDidLoad() {
       super.viewDidLoad()
       
   }

    
    @IBAction func onDepartment(_ sender: Any) {
        
        let departmentList = Array(courses.keys)
        self.globalPicker.stringArray = departmentList
        
        self.globalPicker.modalPresentationStyle = .overCurrentContext
        self.globalPicker.onDone = { [self] index in
        self.department.text =  globalPicker.stringArray[index]
        }
        self.present(self.globalPicker, animated: true, completion: nil)
        
    }

    
    @IBAction func onSignup(_ sender: Any) {
        self.view.endEditing(true)
        if(self.validate()) {
            
            let password = generateRandomPassword()
            FireStoreManager.shared.signUp(userType: .ADMIN, name: self.name.text!, email:  self.email.text!, password: password , department: self.department.text!, course: "")
        
    }
    
}
    
    func validate() ->Bool {
        
        if(self.name.text!.isEmpty) {
             showAlertAnyWhere(message: "Please enter name.")
            return false
        }
        
        if !(self.name.text!.isValidName) {
            showAlertAnyWhere(message: "Please enter valid name.")
            return false
        }
        
        if(!isValidEmail(testStr: email.text!)) {
             showAlertAnyWhere(message: "Please enter valid email.")
            return false
        }
        
        
        if(self.department.text!.isEmpty) {
             showAlertAnyWhere(message: "Please select department")
            return false
        }
        
        return true
    }
}


 

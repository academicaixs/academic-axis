import UIKit

class CreateFacultyAccountVC: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var course: UILabel!
    var checkboxDialogViewController : CheckboxDialogViewController!
    var selectedValues = [String]()
    
    override func viewDidLoad() {
       super.viewDidLoad()
       
   }
    
    @IBAction func onCourses(_ sender: Any) {
        let department = UserDefaultsManager.shared.getDepartment()
        
        guard let departmentCourses = courses[department] else {
            
            return
        }
        
        var tableData: [(name: String, translated: String)] = []
        
        for course in departmentCourses {
            tableData.append((course, course))
        }
        
        self.checkboxDialogViewController = CheckboxDialogViewController()
        self.checkboxDialogViewController.titleDialog = "Courses"
        self.checkboxDialogViewController.tableData = tableData
        self.checkboxDialogViewController.componentName = DialogCheckboxViewEnum.courses
        self.checkboxDialogViewController.componentName = DialogCheckboxViewEnum.courses
        self.checkboxDialogViewController.delegateDialogTableView = self
        self.checkboxDialogViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(self.checkboxDialogViewController, animated: false, completion: nil)
    }


    
    
    @IBAction func onSignup(_ sender: Any) {
        
        self.view.endEditing(true)
        if(self.validate()) {
            
            
            let selectedValuesString: String
            if selectedValues.count == 1 {
                selectedValuesString = selectedValues[0]
            } else {
                selectedValuesString = selectedValues.joined(separator: ",")
            }
        
            
            let password = generateRandomPassword()
            let department = UserDefaultsManager.shared.getDepartment()
            
            FireStoreManager.shared.signUp(userType: .FACULTY, name: self.name.text!, email:  self.email.text!, password: password , department: department, course: selectedValuesString)
 
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
        
        
        if(self.course.text!.isEmpty || self.course.text == "Select Courses") {
             showAlertAnyWhere(message: "Please select course.")
            return false
        }
    
        return true
    }
}


extension CreateFacultyAccountVC:CheckboxDialogViewDelegate {
    
    
    func onCheckboxPickerValueChange(_ component: DialogCheckboxViewEnum, values: TranslationDictionary) {
        
        self.selectedValues = values.map{$0.value}
        for item in values {
            self.course.text! +=  " \(item.value)"
        }
        
        }
    }

    

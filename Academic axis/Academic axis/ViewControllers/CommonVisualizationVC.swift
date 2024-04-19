import UIKit

class CommonVisualizationVC: UIViewController {
    
    @IBOutlet weak var department: UITextField?
    @IBOutlet weak var assignment: UITextField!
    var globalPicker = GlobalPicker()
    @IBOutlet weak var learningOutCome: UITextField!
    @IBOutlet weak var course: UITextField!

    override func viewDidLoad() {
       super.viewDidLoad()
       
        if let fetchedFiles = CoreDataHelper.shared.getFiles() {
            
            if(fetchedFiles.isEmpty){showAlert(message: "No Record Found Please upload csv")}
             
        }
        
        if(UserDefaultsManager.shared.getUserType() == .ADMIN || UserDefaultsManager.shared.getUserType() == .FACULTY) {
            self.department?.text = UserDefaultsManager.shared.getDepartment()
        }
   }
    
    var outComes = ["critical thinking", "communicating","managing information","leadership"]
  
    func resetValues() {
        self.course.text = ""
        self.learningOutCome.text = ""
        self.assignment.text = ""
    }

    
    @IBAction func onDepartment(_ sender: Any) {
    
        if(UserDefaultsManager.shared.getUserType() == .ADMIN || UserDefaultsManager.shared.getUserType() == .FACULTY) {
           return // bcz admin can't select department
        }
        
        resetValues()
        
        // Get the department list from the courses dictionary keys
        let departmentList = Array(courses.keys)
        self.globalPicker.stringArray = departmentList
        
        self.globalPicker.modalPresentationStyle = .overCurrentContext
        self.globalPicker.onDone = { [self] index in
          self.department?.text =  globalPicker.stringArray[index]
        }
        self.present(self.globalPicker, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func onCourse(_ sender: Any) {

        self.learningOutCome.text = ""
        self.assignment.text = ""
        
        if let department = department,department.text!.isEmpty{
            showAlert(message: "Please Select Department First")
            return
        }
        
        let globalPicker = GlobalPicker()
        
        self.course.text = ""

        let selectedDepartment = self.department?.text ??  UserDefaultsManager.shared.getDepartment()

          var departmentCourses = courses[selectedDepartment]!
        
        
           if(UserDefaultsManager.shared.getUserType() == .FACULTY) {
             
            departmentCourses = UserDefaultsManager.shared.getCourses().components(separatedBy: ",")
               
           }
        
        
            globalPicker.stringArray = departmentCourses
            globalPicker.modalPresentationStyle = .overCurrentContext
        
             globalPicker.onDone = { [self] index in
                self.course.text = departmentCourses[index]
             }
        
            self.present(globalPicker, animated: true, completion: nil)
            
    }
    
    @IBAction func onLearningOutCome(_ sender: Any) {
           
        self.assignment.text = ""
        
        if self.course.text!.isEmpty {
            showAlert(message: "Please Select Course")
            return
        }
        let globalPicker = GlobalPicker()

        globalPicker.stringArray = outComes
            globalPicker.modalPresentationStyle = .overCurrentContext
            globalPicker.onDone = { [self] index in
                self.learningOutCome.text = outComes[index]
        }
        self.present(globalPicker, animated: true, completion: nil)
        
    }

    
    @IBAction func onAssignment(_ sender: Any) {
        
        if( (self.learningOutCome.text!.isEmpty)) {
            showAlert(message: "Please fill all information")
            return
        }else {
            self.showAssignmentList()
        }
    }
    
   
    @IBAction func onSubmit(_ sender: Any) {
        
        if( (self.assignment.text!.isEmpty)) {
            showAlert(message: "Please fill all information")
            return
        }else {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowVisualizationVC") as! ShowVisualizationVC
            vc.department = self.department?.text ?? UserDefaultsManager.shared.getDepartment()
            vc.course = self.course.text!
            vc.outcome = self.learningOutCome.text!
            vc.assignment =  self.assignment.text!
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
}


extension CommonVisualizationVC {
    
    func showAssignmentList() {
        guard let selectedCourse = course.text else {
            showAlert(message: "Please select a learning outcome first")
            return
        }
        
        CoreDataHelper.shared.fetchAssignments(forCourse: selectedCourse) { [weak self] (assignments, error) in
            if let error = error {
                print("Error fetching assignments: \(error.localizedDescription)")
                self?.showAlert(message: "Error fetching assignments")
            } else if let assignments = assignments {
                
                if(assignments.isEmpty) {
                    self!.showAlert(message: "No Assignment Found For Selected Course")
                    return
                }
                let globalPicker = GlobalPicker()
                globalPicker.stringArray = assignments
                    globalPicker.modalPresentationStyle = .overCurrentContext
                    globalPicker.onDone = { [self] index in
                        self?.assignment.text = globalPicker.stringArray[index]
                }
                self?.present(globalPicker, animated: true, completion: nil)
                
            }
        }
    }
}



import UIKit

class StudentHomeVC: UIViewController {
   
    @IBAction func onVisul(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonVisualizationVC") as! CommonVisualizationVC
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
}

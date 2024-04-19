

import UIKit

class AdminHomeVC: UIViewController {
    
    @IBAction func onSeeVisul(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommonVisualizationVC") as! CommonVisualizationVC
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

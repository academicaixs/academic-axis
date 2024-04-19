import UIKit

class HistoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var files: [Files] = [] // Array to hold files data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
        
        // Register cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellIdentifier")
        
        // Fetch files data
        if let fetchedFiles = CoreDataHelper.shared.getFiles() {
            files = fetchedFiles
            if(files.isEmpty){showAlert(message: "No Record Found")}
            tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        
        let file = files[indexPath.row]
        
        // Customize title and description using file data
        cell.textLabel?.text = "CSV \(indexPath.row + 1)"
        cell.detailTextLabel?.text = "File Name: \(file.fileName ?? "")"
        
        return cell
    }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HistoryDetailsVC") as! HistoryDetailsVC
        vc.selectedFileName = self.files[indexPath.row].fileName!
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let fileName = files[indexPath.row].fileName
            CoreDataHelper.shared.deleteAllRecordsFromTable(with: fileName!)
            
            let fileToDelete = files[indexPath.row]
            CoreDataHelper.shared.deleteFile(file: fileToDelete)
            files.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
           
        }
    }
    
}

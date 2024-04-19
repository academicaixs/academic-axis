import UIKit

class HistoryDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedFileName = ""
    var records: [StudentRecord] = []
    var assignments: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
        
        // Register cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellIdentifier")
        
        // Add filter button to the navigation bar
        let filterButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(filterButtonTapped))
        navigationItem.rightBarButtonItem = filterButton
        
        // Fetch records for the selected file name
        CoreDataHelper.shared.fetchFileRecord(forFileName: selectedFileName) { records, error in
            self.records = records ?? []
            if self.records.isEmpty {
                self.showAlert(message: "No Record Found")
            }else {
                
                for item in self.records {
                    if(!self.assignments.contains(item.assessmentTitle!)){
                        self.assignments.append(item.assessmentTitle ?? "" )
                    }
                    
                }
               
            }
            self.tableView.reloadData()
        }
    }
    
    // MARK: - UITableView DataSource and Delegate methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
            
            let record = records[indexPath.row]
            
            // Construct the text to display in the cell, with each attribute on a new line
            let displayText = """
            Account Name: \(record.accountName ?? "")
            Course Name: \(record.courseName ?? "")
            Assessment Title: \(record.assessmentTitle ?? "")
            Learning Outcome Name: \(record.learningOutcomeName ?? "")
            Learning Outcome Rating: \(record.learningOutcomeRating ?? "")
            Created On: \(record.fileName ?? "")
            """
            
            // Set the text of the cell
            cell.textLabel?.numberOfLines = 0 // Allow multiple lines
            cell.textLabel?.attributedText = attributedText(for: displayText)
            
            return cell
        }
    
    // MARK: - Filter Button Action
    
    @objc func filterButtonTapped() {
        
        if(assignments.isEmpty) {return}
        
        let globalPicker = GlobalPicker()
        globalPicker.stringArray = assignments
        globalPicker.modalPresentationStyle = .overCurrentContext
        globalPicker.onDone = { [weak self] index in
            guard let self = self else { return }
            let selectedAssignment = self.assignments[index]
           
            let filteredRecords = self.records.filter { $0.assessmentTitle == selectedAssignment }
            
            self.records = filteredRecords
            self.tableView.reloadData()
        }
        present(globalPicker, animated: true, completion: nil)
    }
    
    private func attributedText(for text: String) -> NSAttributedString {
           let attributedString = NSMutableAttributedString(string: text)
           
           // Find the range of "Learning Outcome Rating" text
           if let range = text.range(of: "Learning Outcome Rating: ") {
               let nsRange = NSRange(range, in: text)
               attributedString.addAttribute(.foregroundColor, value: UIColor.green, range: nsRange)
           }
           
           return attributedString
       }
}

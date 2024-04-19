import UIKit
import DGCharts

class ShowVisualizationVC: UIViewController {
    
    var department = ""
    var course = ""
    var outcome = ""
    var assignment = ""
    let coreDataHelper = CoreDataHelper.shared
    
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var barChartView: BarChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showRatings()
    }
    
    func showRatings() {
        
        self.coreDataHelper.fetchLearningOutcomeRatings(forAssessmentTitle: assignment, learningOutcome: outcome) { (proficient, notProficient, highlyProficientStudents, meetsExpectationsStudents, notMeetsExpectationsStudents, emergingProficientStudents, error) in
            if let error = error {
                print("Error fetching ratings for \(self.title): \(error.localizedDescription)")
                return
            }
            
            // Now you have the ratings for each assessment title
            // Update the pie chart with the fetched ratings
            self.updatePieChart(proficientCount: proficient?.count ?? 0,
                                highlyProficientCount: highlyProficientStudents?.count ?? 0,
                                emergingProficientCount: emergingProficientStudents?.count ?? 0,
                                notProficientCount: notProficient?.count ?? 0,
                                meetsExpectationsCount: meetsExpectationsStudents?.count ?? 0,
                                notMeetsExpectationsCount: notMeetsExpectationsStudents?.count ?? 0)
            
            // Update the bar chart with the fetched ratings
            self.updateBarChart(proficientCount: proficient?.count ?? 0,
                                highlyProficientCount: highlyProficientStudents?.count ?? 0,
                                emergingProficientCount: emergingProficientStudents?.count ?? 0,
                                notProficientCount: notProficient?.count ?? 0,
                                meetsExpectationsCount: meetsExpectationsStudents?.count ?? 0,
                                notMeetsExpectationsCount: notMeetsExpectationsStudents?.count ?? 0)
        }
    }
    
    func updatePieChart(proficientCount: Int, highlyProficientCount: Int, emergingProficientCount: Int, notProficientCount: Int, meetsExpectationsCount: Int, notMeetsExpectationsCount: Int) {
        // Create an array of PieChartDataEntry objects with counts for each proficiency level
        let entries = [
            PieChartDataEntry(value: Double(proficientCount), label: "Proficient"),
            PieChartDataEntry(value: Double(highlyProficientCount), label: "Highly Proficient"),
            PieChartDataEntry(value: Double(emergingProficientCount), label: "Emerging Proficient"),
            PieChartDataEntry(value: Double(notProficientCount), label: "Not Proficient"),
            PieChartDataEntry(value: Double(meetsExpectationsCount), label: "Meets Expectations"),
            PieChartDataEntry(value: Double(notMeetsExpectationsCount), label: "Not Meets Expectations")
        ]
        
        // Create a PieChartDataSet object using the entries
        let dataSet = PieChartDataSet(entries: entries, label: "Proficiency Levels")
        
        // Set up colors for each slice of the pie chart
        dataSet.colors = ChartColorTemplates.vordiplom()
        
        // Create a PieChartData object with the dataSet
        let data = PieChartData(dataSet: dataSet)
        
        // Set up additional properties for the pie chart
        pieChartView.data = data
        pieChartView.noDataText = "No data available"
        pieChartView.drawEntryLabelsEnabled = false
        pieChartView.drawCenterTextEnabled = true
        pieChartView.centerText = "Proficiency Levels"
        pieChartView.holeColor = UIColor.clear
    }
    
    func updateBarChart(proficientCount: Int, highlyProficientCount: Int, emergingProficientCount: Int, notProficientCount: Int, meetsExpectationsCount: Int, notMeetsExpectationsCount: Int) {
        // Create an array of BarChartDataEntry objects with counts for each proficiency level
        let entries = [
            BarChartDataEntry(x: 0, y: Double(proficientCount), data: "Proficient"),
            BarChartDataEntry(x: 1, y: Double(highlyProficientCount), data: "Highly Proficient"),
            BarChartDataEntry(x: 2, y: Double(emergingProficientCount), data: "Emerging Proficient"),
            BarChartDataEntry(x: 3, y: Double(notProficientCount), data: "Not Proficient"),
            BarChartDataEntry(x: 4, y: Double(meetsExpectationsCount), data: "Meets Expectations"),
            BarChartDataEntry(x: 5, y: Double(notMeetsExpectationsCount), data: "Not Meets Expectations")
        ]
        
        // Create a BarChartDataSet object using the entries
        let dataSet = BarChartDataSet(entries: entries, label: "Proficiency Levels")
        
        // Set up colors for each bar of the bar chart
        dataSet.colors = ChartColorTemplates.vordiplom()
        
        // Create a BarChartData object with the dataSet
        let data = BarChartData(dataSet: dataSet)
        
        // Set up additional properties for the bar chart
        barChartView.data = data
        barChartView.noDataText = "No data available"
    }
}

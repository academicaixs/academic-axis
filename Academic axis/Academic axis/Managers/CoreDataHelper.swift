import Foundation
import CoreData

class CoreDataHelper {
    
    static let shared = CoreDataHelper()
    
    // MARK: - Core Data stack
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Academic_axis")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Data Saving
    
    func saveStudentRecord(accountName: String, courseName: String, assessmentTitle: String, learningOutcomeName: String, learningOutcomeRating: String,fileName:String) {
        let studentRecord = StudentRecord(context: context)
        studentRecord.accountName = accountName.lowercased()
        studentRecord.courseName = courseName.lowercased()
        studentRecord.assessmentTitle = assessmentTitle.lowercased()
        studentRecord.learningOutcomeName = learningOutcomeName.lowercased()
        studentRecord.learningOutcomeRating = learningOutcomeRating.lowercased()
        studentRecord.fileName = fileName
        saveContext()
    }
    
    
    
    func saveFileName( fileName:String) {
        let studentRecord = Files(context: context)
        studentRecord.fileName = fileName
        saveContext()
    }
    
    func deleteFile(file: Files) {
            context.delete(file)
            saveContext()
    }
    
    
    func getFiles() -> [Files]? {
            let fetchRequest: NSFetchRequest<Files> = Files.fetchRequest()
            do {
                let files = try context.fetch(fetchRequest)
                return files
            } catch {
                print("Error fetching files: \(error.localizedDescription)")
                return nil
            }
   }
}


extension CoreDataHelper {
    
    
    
    func deleteAllRecordsFromTable(with fileName: String) {
            let fetchRequest: NSFetchRequest<StudentRecord> = StudentRecord.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "fileName ==[cd] %@", fileName)

            do {
                let recordsToDelete = try context.fetch(fetchRequest)
                for record in recordsToDelete {
                    context.delete(record)
                }
                saveContext()
            } catch {
                print("Error deleting records from table: \(error.localizedDescription)")
            }
        }
    
    
    func fetchAssignments(forCourse course: String, completion: @escaping ([String]?, Error?) -> Void) {
        showLoading()
        
        let fetchRequest: NSFetchRequest<StudentRecord> = StudentRecord.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "courseName CONTAINS[cd] %@", course)
        
        do {
            let assignments = try context.fetch(fetchRequest)
            
            // Get all assessment titles and convert them to lowercase
            let assessmentTitles = assignments.compactMap { $0.assessmentTitle?.lowercased() }
            
            // Remove duplicate assessment titles using Set
            let uniqueAssessmentTitles = Array(Set(assessmentTitles))
            
            completion(uniqueAssessmentTitles, nil)
            hideLoading()
        } catch {
            hideLoading()
            print("Error fetching assignments: \(error.localizedDescription)")
            completion(nil, error)
        }
    }


     func fetchFileRecord(forFileName fileName: String, completion: @escaping ([StudentRecord]?, Error?) -> Void) {
        
        showLoading()
        
        
        let fetchRequest: NSFetchRequest<StudentRecord> = StudentRecord.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "fileName CONTAINS[cd] %@", fileName)
        
        do {
            let assignments = try context.fetch(fetchRequest)
            completion(assignments, nil)
            hideLoading()
        } catch {
            hideLoading()
            print("Error fetching assignments: \(error.localizedDescription)")
            completion(nil, error)
        }
    }
    
    


    func fetchAllStudentRecords(completion: @escaping ([StudentRecord]?, Error?) -> Void) {
            let fetchRequest: NSFetchRequest<StudentRecord> = StudentRecord.fetchRequest()
            
            do {
                let records = try context.fetch(fetchRequest)
                completion(records, nil)
            } catch {
                print("Error fetching records: \(error.localizedDescription)")
                completion(nil, error)
            }
    }

    
    
    func showAllRecords() {
        
        self.fetchAllStudentRecords { (records, error) in
            if let error = error {
                print("Error fetching records: \(error.localizedDescription)")
            } else if let records = records {
                for record in records {
                    print("Account Name: \(record.accountName ?? ""), Course Name: \(record.courseName ?? ""), Assessment Title: \(record.assessmentTitle ?? ""), Learning Outcome Name: \(record.learningOutcomeName ?? ""), Learning Outcome Rating: \(record.learningOutcomeRating ?? ""), File Name: \(record.fileName ?? "")")
                }
            }
        }
        
    }
    
    
    
    
    
}


extension CoreDataHelper {
    
    
    
    func fetchLearningOutcomeRatings(forAssessmentTitle assessmentTitle: String, learningOutcome: String, completion: @escaping ([String]?, [String]?, [String]?, [String]?, [String]?, [String]?, Error?) -> Void) {
        showLoading()

    
        let fetchRequest: NSFetchRequest<StudentRecord> = StudentRecord.fetchRequest()
           fetchRequest.predicate = NSPredicate(format: "assessmentTitle ==[cd] %@ AND learningOutcomeName CONTAINS[cd] %@", assessmentTitle, learningOutcome)
          
    
        do {
            let records = try context.fetch(fetchRequest)
            
            var proficient: [String] = []
            var notProficient: [String] = []
            var highlyProficientStudents: [String] = []
            var meetsExpectationsStudents: [String] = []
            var notMeetsExpectationsStudents: [String] = []
            var emergingProficientStudents: [String] = []
            
            // Process the learning outcome ratings
            for record in records {
                if let rating = record.learningOutcomeRating {
                    let rating = rating.lowercased()
                    
                    if !rating.contains("not") && rating.contains("proficient") && !rating.contains("highly") {
                        proficient.append(record.accountName ?? "")
                    }
                    
                    if rating.contains("not") && rating.contains("proficient") && !rating.contains("highly") {
                        notProficient.append(record.accountName ?? "")
                    }
                    
                    if !rating.contains("not") && rating.contains("proficient") && rating.contains("highly") {
                        highlyProficientStudents.append(record.accountName ?? "")
                    }
                    
                    if !rating.contains("not") && rating.contains("meets") && rating.contains("expectations") {
                        meetsExpectationsStudents.append(record.accountName ?? "")
                    }
                    
                    if rating.contains("not") && rating.contains("meets") && rating.contains("expectations") {
                        notMeetsExpectationsStudents.append(record.accountName ?? "")
                    }
                    
                    if rating.contains("emerging") {
                        emergingProficientStudents.append(record.accountName ?? "")
                    }
                }
            }
            
            completion(proficient, notProficient, highlyProficientStudents, meetsExpectationsStudents, notMeetsExpectationsStudents, emergingProficientStudents,nil)
            hideLoading()
        } catch {
            hideLoading()
            completion(nil, nil, nil, nil, nil,nil, error)
        }
    }

    
}

import Foundation

class ScholarYearManager: PersistenceManager {
    
    func delete(schoolYear: SchoolYear) {
        managedObjectContext.delete(schoolYear)
        saveContext()
    }
}

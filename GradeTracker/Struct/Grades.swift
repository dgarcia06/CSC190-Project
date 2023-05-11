import Foundation

class GradeItemManager : PersistenceManager {
    
    func addGradeItem(fromDummy dummy: GradeItemDummy) {
        addGradeItem(withSubject: dummy.subject, schoolYear: dummy.schoolYear, timeStamp: dummy.timeStamp, value: dummy.value, comments: dummy.comments)
    }
    
    func addGradeItem(withSubject subject: String, schoolYear: SchoolYear?, timeStamp : Date, value: Double, comments: String) {
        let gradeItem = GradeItem(context: managedObjectContext)
        gradeItem.subject = subject
        gradeItem.schoolYear = schoolYear
        gradeItem.timeStamp = timeStamp
        gradeItem.value = value
        gradeItem.comments = comments
        saveContext()
    }
    
    func delete (gradeItem: GradeItem) {
        managedObjectContext.delete(gradeItem)
        saveContext()
    }
}

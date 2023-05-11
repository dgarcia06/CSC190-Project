import CoreData

class PersistenceManager: ObservableObject {
    var managedObjectContext: NSManagedObjectContext
    
    init(usePreview: Bool = false) {
        self.managedObjectContext = usePreview ?
            PersistenceController.preview.managedObjectContext :
            PersistenceController.shared.managedObjectContext
    }
    
    func saveContext() {
        try? managedObjectContext.save()
    }
}

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = GradeItem(context: viewContext)
            newItem.subject = "TestSubject"
            let newSchoolYear = SchoolYear(context: viewContext)
            newSchoolYear.name = "TestSubject"
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    static let testGradeItem: GradeItem = {
        let testGradeItem = GradeItem(context: PersistenceController.preview.container.viewContext)
        testGradeItem.subject = "TestGrade"
        testGradeItem.timeStamp = Date()
        return testGradeItem
    }()

    let container: NSPersistentContainer
    
    var managedObjectContext: NSManagedObjectContext {
        container.viewContext
    }

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "GradeTracker")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}

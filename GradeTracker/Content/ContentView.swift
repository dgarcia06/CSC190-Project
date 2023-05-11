import SwiftUI

struct ContentView: View {
    var gradeItemManager = GradeItemManager()
    
    var ScholarYear = ScholarYearManager()
    
    var body: some View {
        TabView {
            GradeItemsListNavigationView()
                .environmentObject(gradeItemManager)
                .tabItem {
                    Text("Grades")
                    Image(systemName: "book")
                }
            Semesters()
                .environmentObject(ScholarYear)
                .tabItem {
                    Text("Semesters")
                    Image(systemName: "calendar.badge.plus")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
            ContentView(
                gradeItemManager: GradeItemManager(usePreview: true),
                ScholarYear: ScholarYearManager(usePreview: true)
            )
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

import SwiftUI

struct Semesters: View {
    var body: some View {
        NavigationView {
            SchoolYearsList()
        }
    }
}

struct SchoolYearsList: View {
    @FetchRequest(
        entity: SchoolYear.entity(),
        sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]
    )
    private var schoolYears: FetchedResults<SchoolYear>
    
    @State private var showAddSchoolYearView = false
    
    @EnvironmentObject var schoolYearsManager: ScholarYearManager
    
    var body: some View {
        List {
            ForEach(schoolYears) { schoolYear in
                SchoolYearCell(schoolYear: schoolYear)
            }
        }
        .navigationTitle("Semesters")
        .sheet(isPresented: $showAddSchoolYearView) {
            AddSchoolYearView(showAddSchoolYearView: $showAddSchoolYearView, schoolYearsManager: schoolYearsManager) 
        }
        .toolbar {
            ToolbarItem (placement: .navigationBarTrailing) {
                Button(action: {
                    showAddSchoolYearView = true
                }){
                    Image(systemName: "plus").imageScale(.large)
                }
            }
        }
    }
}

struct SchoolYearCell: View {
    @ObservedObject var schoolYear: SchoolYear
    
    var body: some View {
        NavigationLink(schoolYear.name ?? "", destination: EditSchoolYearView(schoolYear: schoolYear))
    }
}

struct SchoolYearsListNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        Semesters()
            .environment(\.managedObjectContext, PersistenceController.preview.managedObjectContext)
            .environmentObject(ScholarYearManager(usePreview: true))
    }
}

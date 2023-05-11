import SwiftUI

struct SchoolYearView: View {
    @ObservedObject var schoolYear: SchoolYear
    
    var body: some View {
    Form {
        Section(header: Text("Semester")) {
            TextField("Semester", text: $schoolYear.name.toNonOptionalString())
        }
        Section(header: Text("Details")) {
            TextEditor(text: .constant(""))
                .frame(height: 300)
        }
    }
    }
    
}

struct EditSchoolYearView: View {
    @ObservedObject var schoolYear: SchoolYear
    
    @EnvironmentObject var schoolYearManager: ScholarYearManager
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        SchoolYearView(schoolYear: schoolYear)
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        schoolYearManager.saveContext()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(!schoolYear.hasChanges)
                }
            }
            .onDisappear {
                if schoolYear.hasChanges {
                    schoolYearManager.managedObjectContext.refresh(schoolYear, mergeChanges: false)
                }
            }
    }
}

struct AddSchoolYearView: View {
    private var newSchoolYear: StateObject<SchoolYear>
    
    @State private var didDisappearWithButton = false
    
    var showAddSchoolYearView: Binding<Bool>
    
    let schoolYearsManager: ScholarYearManager
    
    init(showAddSchoolYearView: Binding<Bool>, schoolYearsManager: ScholarYearManager) {
        self.showAddSchoolYearView = showAddSchoolYearView
        self.schoolYearsManager = schoolYearsManager
        newSchoolYear = StateObject<SchoolYear>(wrappedValue: SchoolYear(context: schoolYearsManager.managedObjectContext))
    }
    
    var body: some View {
        NavigationView {
            SchoolYearView(schoolYear: newSchoolYear.wrappedValue)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            hideAddSchoolYearView(shouldSaveNewSchoolYear: false)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            hideAddSchoolYearView(shouldSaveNewSchoolYear: true)
                        }
                    }
                }
    }
        .onDisappear {
            if !didDisappearWithButton {
                hideAddSchoolYearView(shouldSaveNewSchoolYear: false)
            }
        }
    }
    
    private func hideAddSchoolYearView(shouldSaveNewSchoolYear: Bool) {
        didDisappearWithButton = true
        if shouldSaveNewSchoolYear {
            schoolYearsManager.saveContext()
        } else {
            schoolYearsManager.delete(schoolYear: newSchoolYear.wrappedValue)
        }
        showAddSchoolYearView.wrappedValue = false
    }
}

struct AddSchoolYearView_Previews: PreviewProvider {
    static var previews: some View {
        AddSchoolYearView(showAddSchoolYearView: .constant(true), schoolYearsManager: ScholarYearManager(usePreview: true))
    }
}

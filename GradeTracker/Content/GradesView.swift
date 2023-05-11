import SwiftUI

struct GradeItemView: View {
    @Binding var subject: String
    @Binding var schoolYear: SchoolYear?
    @Binding var timeStamp: Date
    @Binding var value: Double
    @Binding var comments: String
    
    var body: some View {
        Form {
            Section (header: Text("Course Name")){
                TextField("Course", text: $subject)
            }
            Section(header: Text("Year")) {
                SchoolYearPicker(schoolYear: $schoolYear)
                if schoolYear != nil {
                Button("Remove") {
                    schoolYear = nil
                }
                .foregroundColor(.red)
                }
            }
            Section (header: Text("Details")) {
                DatePicker("Date", selection: $timeStamp, displayedComponents: .date)
                    .environment(\.locale, Locale.init(identifier: "en"))
                Stepper(value: $value, in: 1...100) {
                Text("Grade: \(value)")
                }
            }
            Section {
                TextField("Comments", text: $comments)
            }
        }
    }
}

struct SchoolYearPicker : View {
    @FetchRequest(entity: SchoolYear.entity(),
                  sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]
    ) private var schoolYears: FetchedResults<SchoolYear>
    
    @Binding var schoolYear: SchoolYear?
    var body: some View {
        Picker("Year", selection: $schoolYear) {
            ForEach(schoolYears) { schoolYear in
                Text(schoolYear.name ?? "")
                    .tag(schoolYear as SchoolYear?)
            }
        }
    }
}

struct GradeItemDummy {
    var subject = ""
    var schoolYear: SchoolYear? = nil
    var timeStamp = Date()
    var value: Double = 100
    var comments = ""
}

struct AddGradeItemView: View {
    @State private var gradeItemDummy = GradeItemDummy()
    
    @Binding var showAddGradeView: Bool
    
    @EnvironmentObject var gradeItemManager: GradeItemManager
    
    var gradeOptions = [1...100]
    
    var body: some View {
        NavigationView {
            GradeItemView(
                subject: $gradeItemDummy.subject,
                schoolYear: $gradeItemDummy.schoolYear,
                timeStamp: $gradeItemDummy.timeStamp,
                value: $gradeItemDummy.value,
                comments: $gradeItemDummy.comments
            )
        .navigationTitle("New Grade")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        showAddGradeView = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        gradeItemManager.addGradeItem(fromDummy: gradeItemDummy)
                        showAddGradeView = false
                    }
                }
            }
        }
    }
}

struct EditGradeItemView : View {
    @ObservedObject var gradeItem: GradeItem
    
    @EnvironmentObject var gradeItemManager: GradeItemManager
    
    var body: some View {
        GradeItemView(
            subject: $gradeItem.subject.toNonOptionalString(),
            schoolYear: $gradeItem.schoolYear,
            timeStamp: $gradeItem.timeStamp.toNonOptionalDate(),
            value: $gradeItem.value,
            comments: $gradeItem.comments.toNonOptionalString())
        .navigationTitle("Edit Grade")
        .onDisappear {
            gradeItemManager.saveContext()
        }
    }
}

struct AddGradeItemButton: View {
    @Binding var showAddGradeView: Bool
    
    @Environment(\.editMode) var editMode
    
    var body: some View {
        Button(action: {
            showAddGradeView = true
        }){
            Image(systemName: "plus").imageScale(.large)
        }
        .disabled(editMode?.wrappedValue.isEditing ?? false)
    }
}

struct GradeItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddGradeItemView(showAddGradeView: .constant(false))
            .environmentObject(GradeItemManager(usePreview: true))
    }
}

import SwiftUI

struct GradeItemsListNavigationView: View {
    @State private var showAddGradeView = false
    
    var body: some View {
    NavigationView {
        GradesList(showAddGradeView: $showAddGradeView)
    }
    }
}

struct GradesList: View {
    @FetchRequest(
        entity: GradeItem.entity(), sortDescriptors:[NSSortDescriptor(key: "timeStamp", ascending: false)]
    )
    private var gradeItems: FetchedResults<GradeItem>
    
    @Binding var showAddGradeView: Bool
    
    @Environment(\.editMode) var editMode
    
    @EnvironmentObject var gradeItemManager: GradeItemManager
    
    var body: some View {
        List {
            ForEach(gradeItems) { gradeItem in
                GradeNavigationCell(gradeItem: gradeItem)
            }
            .onDelete(perform: { indexSet in
                for index in indexSet {
                    let gradeItemToDelete = gradeItems[index]
                    gradeItemManager.delete(gradeItem: gradeItemToDelete)
                }
            })
            Text("\(gradeItems.count) Grades Added")
        }
        .navigationTitle("My Grades")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                CustomEditButton()
                    .disabled(gradeItems.isEmpty)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                AddGradeItemButton(showAddGradeView: $showAddGradeView)
            }
        }
        .sheet(isPresented: $showAddGradeView, content: {
            AddGradeItemView(showAddGradeView: $showAddGradeView)
                .environmentObject(gradeItemManager)
        })
    }
}

struct GradeNavigationCell: View {
    let gradeItem: GradeItem
    
    var body: some View {
        NavigationLink(destination: EditGradeItemView(gradeItem: gradeItem)) {
            GradeCell(gradeItem:  gradeItem)
        }
    }
}

struct GradeCell: View {
    @ObservedObject var gradeItem: GradeItem
    
    var body: some View {
        HStack {
            Text(gradeItem.subject ?? "")
                .font(.title)
            VStack(alignment: .leading) {
                Text("Assignment")
                Text(gradeItem.timeStamp ?? Date(), style: .date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .environment(\.locale, Locale.init(identifier: "en"))
        }
            Spacer()
            Text(String(gradeItem.value))
                .font(.title)
        }
    }
}

struct GradeItemsListNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GradeItemsListNavigationView()
            .environment(\.managedObjectContext, PersistenceController.preview.managedObjectContext)
            .environmentObject(GradeItemManager(usePreview: true))
            GradeCell(gradeItem: PersistenceController.testGradeItem)
                .previewLayout(.sizeThatFits)
        }
    }
}

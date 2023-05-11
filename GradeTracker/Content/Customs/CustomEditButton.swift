import SwiftUI

struct CustomEditButton: View {
    @Environment(\.editMode) var editMode
    
    private var isEditing: Bool {
        editMode?.wrappedValue.isEditing ?? false
    }
    
    var body: some View {
        Button(action: {
            withAnimation {
                editMode?.wrappedValue = isEditing ? .inactive : .active
            }
        }, label: {
            Text(isEditing ? "Done" : "Edit")
                .multilineTextAlignment(TextAlignment.leading)
        })
    }
}

struct CustomEditButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomEditButton()
    }
}

import SwiftUI
import CoreData


struct AddExpenseView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @State private var date = Date()
    @State private var title = ""
    @State private var category = ""
    @State private var amountString = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Expense Details")) {
                    TextField("Title", text: $title)
                    TextField("Category", text: $category)
                }
            }
            .navigationTitle("Add Expense")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        addExpense()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func addExpense() {
        withAnimation {
            let newExpense = ExpenseEntity(context: viewContext)
            newExpense.date = date
            newExpense.title = title
            newExpense.category = category
            newExpense.amount = Double(amountString) ?? 0.0

            do {
                try viewContext.save()
            } catch {
                print("Error saving expense: \(error.localizedDescription)")
            }
        }
    }
}

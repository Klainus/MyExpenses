import SwiftUI
import CoreData

struct AddExpenseView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @State private var date = Date()
    @State private var title = ""
    @State private var category = ""
    @State private var amountString = ""
    
    @State private var showingErrorAlert = false
    
    let categories = ["Food", "Transport", "Shopping", "Entertainment"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Expense Details")) {
                    TextField("Title", text: $title)

                    TextField("Amount", text: $amountString)
                        .keyboardType(.decimalPad)
                    Picker("Category", selection: $category)
                    {
                        ForEach(categories, id: \.self) {
                            category in Text(category).tag(category)
                        }
                    }.pickerStyle(.menu)
                    DatePicker("Select a date", selection: $date, displayedComponents: .date)
                }
            }
            .navigationTitle("Add Expense")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        addExpense()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert(isPresented: $showingErrorAlert) {
                Alert(
                    title: Text("Invalid Input!"),
                    message: Text("Please enter a valid amount."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

    private func addExpense() {
        // Kontrollera om amountString kan konverteras till en Double
        guard let amount = Double(amountString), amount > 0 else {
            // Om inte, visa alert
            showingErrorAlert = true
            return
        }

        // Om konverteringen lyckades, skapa ny utgift och spara
        withAnimation {
            let newExpense = ExpenseEntity(context: viewContext)
            newExpense.date = date
            newExpense.title = title
            newExpense.category = category
            newExpense.amount = amount

            do {
                try viewContext.save()
                dismiss()
            } catch {
                print("Error saving expense: \(error.localizedDescription)")
            }
        }
    }
}


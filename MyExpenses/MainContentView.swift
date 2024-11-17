import SwiftUI
import CoreData


struct MainContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: ExpenseEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ExpenseEntity.date, ascending: false)],
        animation: .default)
    private var expenses: FetchedResults<ExpenseEntity>
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(expenses) { expense in
                        HStack {                            VStack(alignment: .leading) {
                                Text(expense.title ?? "Untitled")
                                    .font(.headline)
                                Text(expense.category ?? "Uncategorized")
                                    .font(.subheadline)
                            }
                            Spacer()
                            Text(String(format: "%.2f", expense.amount))
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                
              
                Text("Total budget: 100..\(calculateTotal(), specifier: "%.2f")")
                    .padding()
            }
            .navigationTitle("My Expenses")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddExpenseView()) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
    
    private func calculateTotal() -> Double {
        expenses.reduce(0) { $0 + $1.amount }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { expenses[$0] }.forEach { expense in
                viewContext.delete(expense)
            }
            do {
                try viewContext.save()
            } catch {
                print("Error saving after delete: \(error)")
            }
        }
    }
}




// Preview setup for SwiftUI preview
#Preview {
    MainContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

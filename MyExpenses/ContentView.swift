import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ExpenseEntity.date, ascending: false)],
        animation: .default)
    private var expenses: FetchedResults<ExpenseEntity>

    @State private var showingAddExpense = false

    var body: some View {
        NavigationView {
            ZStack { Color("BackgroundColor").edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                if !expenses.isEmpty {
                    List {
                        ForEach(expenses) { expense in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(expense.title ?? "Untitled")
                                        .font(.headline)
                                    Text(expense.category ?? "No category")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text(expense.amount, format: .currency(code: "USD"))
                                        .font(.headline)
                                    Text(expense.date ?? Date(), formatter: dateFormatter)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .onDelete(perform: deleteExpenses)
                    }
                } else {
                    VStack {
                        Image(systemName: "tray")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray.opacity(0.5))
                        Text("No expenses yet")
                            .font(.title2)
                            .foregroundColor(.gray)
                            .padding(.top, 8)
                    }
                }
            }
            .navigationTitle("My Expenses")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                        .disabled(expenses.isEmpty)
                }
                ToolbarItem {
                    Button(action: { showingAddExpense = true }) {
                        Label("Add Expense", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddExpenseView()
                    .environment(\.managedObjectContext, viewContext)
            }
        }
    }

    private func deleteExpenses(offsets: IndexSet) {
        withAnimation {
            offsets.map { expenses[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                print("Error deleting expense: \(error.localizedDescription)")
            }
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

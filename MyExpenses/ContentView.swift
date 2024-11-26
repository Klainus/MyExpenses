import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ExpenseEntity.date, ascending: false)],
        animation: .default)
    private var expenses: FetchedResults<ExpenseEntity>

    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var budgets: FetchedResults<BudgetEntity>

    @State private var showingAddExpense = false
    @State private var showingSetBudget = false

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.gray.opacity(0.2)]),
                    startPoint: .top,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack {
                    if let budget = budgets.first {
                        let totalSpent = expenses.reduce(0) { $0 + $1.amount }
                        let spentString = String(format: "%.2f", totalSpent)
                        let budgetString = String(format: "%.2f", budget.budget)
                        
                        Text("Spent \(spentString) / \(budgetString) (Budget)")
                            .font(.headline)
                            .padding()
                    } else {
                        Text("Set your budget")
                            .font(.headline)
                            .padding()
                    }

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
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showingSetBudget = true }) {
                        Label("Set Budget", systemImage: "dollarsign.circle")
                    }
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddExpenseView()
                    .environment(\.managedObjectContext, viewContext)
            }
            .sheet(isPresented: $showingSetBudget) {
                SetBudgetView()
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

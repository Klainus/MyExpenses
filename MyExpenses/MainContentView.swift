//
//  MainContentView.swift
//  MyExpenses
//
//  Created by Linus Karlsson on 2024-11-14.
//

import SwiftUI

struct MainContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Expense.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Expense.date, ascending: false)],
        animation: .default)
    private var expenses: FetchedResults<Expense>
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(expenses) { expense in HStack
                        VStack(alignment: .leading) {
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
            Text("Total budget: \(calculateTotal())")
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

func calculateTotal() -> Double {
    expenses.reduce(0) {$0 + $1.amount}
}

private func deleteItems(offsets: IndexSet) {
    withAnimation {
        offsets.map {expenses[$0]}.forEach {expense in
            viewContext.delete(expense)
        }
        do {
            try viewContext.save()
        } catch {
            print("Error saving after delete: \(error)")
        }
    }
}


struct AddExpenseView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var title = ""
    @State private var category = ""
    @State private var amount = ""
    @State private var date = Date()
    
    var body: some View {
        Form {
            Section(header: Text("Expense Details")){
                TextField("Title", text: $title)
                TextField("Category", text: $category)
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                DatePicker("Date", selection: $date, displayedComponents: .date)
            }
            Button("Save") {
                addExpense()
            }
        }
        .navigationTitle("Add Expense")
    }
    
    private func addExpense() {
    let newExpense = Expense(context: viewContext)
        newExpense.title = title
        newExpense.category = category
        newExpense.amount = Double(amount) ?? 0.0
        newExpense.date = date
        
        do {
            try viewContext.save()
        } catch {
            print("Error saving expense \(error)")
        }
    }
}


#Preview {
    MainContentView(\.managedObjectContext, 
                     PersistenceController
        .preview
        .container
        .viewContext)
}

//
//  SetBudgetView.swift
//  MyExpenses
//
//  Created by Linus Karlsson on 2024-11-26.
//

import Foundation
import SwiftUI
import CoreData

struct SetBudgetView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var budgetAmountString = ""
    @State private var showingErrorAlert = false
    
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var budgets: FetchedResults<BudgetEntity>
    
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("Set your budget")){
                    TextField("Enter budget", text: $budgetAmountString)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Set Budget")
            .toolbar{
                ToolbarItem(placement: .confirmationAction){
                    Button("Save"){
                        setBudget()
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
                    title: Text("Invalid input"),
                    message: Text("Plase enter a valid amount"),
                    dismissButton: .default(Text("OK")))
            }
        }
    }
    private func setBudget() {
        guard let budgetAmount = Double(budgetAmountString), budgetAmount > 0
        else {
            showingErrorAlert = true
            return
        }
        
        if let existingBudget = fetchExistingBudget() {
            existingBudget.budget = budgetAmount
        } else {
            let newBudget = BudgetEntity(context: viewContext)
            newBudget.budget = budgetAmount
        }
        
        do {
            try viewContext.save()
            dismiss()
        }
        catch{
            print("Error saving budget: \(error.localizedDescription)")
        }
    }
    
    private func fetchExistingBudget() -> BudgetEntity? {
        return budgets.first
    }
}

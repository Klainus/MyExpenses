//
//  Persistence.swift
//  MyExpenses
//
//  Created by Linus Karlsson on 2024-11-14.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        let categories = ["Food", "Transport", "Entertainemnt"]
        
        for i in 0..<10 {
            let newExpense = MyExpenses.ExpenseEntity(context: viewContext)
            newExpense.title = "Sample \(i+1)"
            newExpense.category = categories.randomElement()
            newExpense.amount = Double.random(in: 10...50)
            newExpense.date = Calendar.current.date(byAdding: .day, value: -i, to: Date())
            
        }
        do {
            try viewContext.save()
        } catch {
     
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MyExpenses")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in // check if we need to configure the error handling??
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

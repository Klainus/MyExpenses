//
//  MyExpensesApp.swift
//  MyExpenses
//
//  Created by Linus Karlsson on 2024-11-14.
//

import SwiftUI

@main
struct MyExpensesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            //change "view" to to different file name to boot into it as "main"
            MainContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

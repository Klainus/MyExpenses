//
//  Expense+CoreDataProperties.swift
//  MyExpenses
//
//  Created by Linus Karlsson on 2024-11-14.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var amount: Double
    @NSManaged public var category: String?
    @NSManaged public var date: Date?
    @NSManaged public var title: String?

}

extension Expense : Identifiable {

}

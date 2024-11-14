//
//  ExpenseEntity+CoreDataProperties.swift
//  MyExpenses
//
//  Created by Linus Karlsson on 2024-11-14.
//
//

import Foundation
import CoreData


extension ExpenseEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExpenseEntity> {
        return NSFetchRequest<ExpenseEntity>(entityName: "ExpenseEntity")
    }

    @NSManaged public var date: Date?
    @NSManaged public var amount: Double
    @NSManaged public var title: String?
    @NSManaged public var category: String?

}

extension ExpenseEntity : Identifiable {

}

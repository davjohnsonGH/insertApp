//
//  Insert+CoreDataProperties.swift
//  insert
//
//  Created by David Johnson on 1/18/17.
//  Copyright © 2017 David Johnson. All rights reserved.
//

import Foundation
import CoreData


extension Insert {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Insert> {
        return NSFetchRequest<Insert>(entityName: "Insert");
    }

    @NSManaged public var content: String?
    @NSManaged public var createdAt: Double
    @NSManaged public var favorite: Bool
    @NSManaged public var groupID: String?
    @NSManaged public var preferredIndex: Int16
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var image: NSData?
    @NSManaged public var groupedInserts: NSSet?

}

// MARK: Generated accessors for groupedInserts
extension Insert {

    @objc(addGroupedInsertsObject:)
    @NSManaged public func addToGroupedInserts(_ value: GroupedInsert)

    @objc(removeGroupedInsertsObject:)
    @NSManaged public func removeFromGroupedInserts(_ value: GroupedInsert)

    @objc(addGroupedInserts:)
    @NSManaged public func addToGroupedInserts(_ values: NSSet)

    @objc(removeGroupedInserts:)
    @NSManaged public func removeFromGroupedInserts(_ values: NSSet)

}

//
//  GroupedInsert+CoreDataProperties.swift
//  insert
//
//  Created by David Johnson on 1/18/17.
//  Copyright © 2017 David Johnson. All rights reserved.
//

import Foundation
import CoreData


extension GroupedInsert {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GroupedInsert> {
        return NSFetchRequest<GroupedInsert>(entityName: "GroupedInsert");
    }

    @NSManaged public var content: String?
    @NSManaged public var createdAt: Double
    @NSManaged public var favorite: Bool
    @NSManaged public var preferredIndex: Int16
    @NSManaged public var title: String?
    @NSManaged public var groupID: String?
    @NSManaged public var image: NSData?
    @NSManaged public var inserts: NSSet?
    @NSManaged public var isGroup: Bool

}

// MARK: Generated accessors for inserts
extension GroupedInsert {

    @objc(addInsertsObject:)
    @NSManaged public func addToInserts(_ value: Insert)

    @objc(removeInsertsObject:)
    @NSManaged public func removeFromInserts(_ value: Insert)

    @objc(addInserts:)
    @NSManaged public func addToInserts(_ values: NSSet)

    @objc(removeInserts:)
    @NSManaged public func removeFromInserts(_ values: NSSet)

}

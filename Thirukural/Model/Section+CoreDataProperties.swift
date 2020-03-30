//
//  Section+CoreDataProperties.swift
//  Thirukural
//
//  Created by Anbarasu S on 28/03/20.
//  Copyright © 2020 Uyar Valluvam. All rights reserved.
//
//

import Foundation
import CoreData
import SwiftUI


extension CDSection: Identifiable {

    @nonobjc public class func allObjectsFetchRequest() -> NSFetchRequest<CDSection> {
        let request = CDSection.fetchRequest() as! NSFetchRequest<CDSection>
        request.sortDescriptors = [NSSortDescriptor(key: "sectionIndex", ascending: true)]
        return request
    }

    @nonobjc public class func fetchSectionWithRecordName(_ recordName: String, fromMOC moc: NSManagedObjectContext) -> CDSection? {
        let request = CDSection.fetchRequest() as! NSFetchRequest<CDSection>
        request.sortDescriptors = [NSSortDescriptor(key: "sectionIndex", ascending: true)]
        request.predicate = NSPredicate(format: "recordName = %@", recordName)

        do {
          let objects = try moc.fetch(request)

            if let validObject = objects.first {
                return validObject
            } else {
                return CDSection(context: moc)
            }

        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }

    }

   
    @NSManaged public var recordName: String
    @NSManaged public var sectionIndex: Int16
    @NSManaged public var sectionTamil: String

    public var id: String {
        return recordName
    }



}

//
//  Chapter+CoreDataProperties.swift
//  Thirukural
//
//  Created by Anbarasu S on 28/03/20.
//  Copyright © 2020 Uyar Valluvam. All rights reserved.
//
//

import Foundation
import CoreData


extension CDChapter: Identifiable {

    @nonobjc public class func allObjectsFetchRequest() -> NSFetchRequest<CDChapter> {
        let request = CDChapter.fetchRequest() as! NSFetchRequest<CDChapter>
        request.sortDescriptors = [NSSortDescriptor(key: "chapterIndex", ascending: true)]
        return request
    }

    @nonobjc public class func fetchChapterWithRecordname(_ recordName: String, fromMOC moc:NSManagedObjectContext) -> CDChapter? {
        let request = CDChapter.fetchRequest() as! NSFetchRequest<CDChapter>
        request.sortDescriptors = [NSSortDescriptor(key: "chapterIndex", ascending: true)]
        request.predicate = NSPredicate(format: "recordName = %@", recordName)

        do {
          let objects = try moc.fetch(request)

            if let validObject = objects.first {
                return validObject
            } else {
                return CDChapter(context: moc)
            }

        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }

    }

    @NSManaged public var recordName: String
    @NSManaged public var chapterTamil: String
    @NSManaged public var chapterIndex: Int16
    @NSManaged public var parentSubSection: String

    public var id: String {
        return recordName
    }

}

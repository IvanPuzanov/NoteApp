//
//  Note+CoreDataProperties.swift
//  NoteApp
//
//  Created by Ivan Puzanov on 25.12.2022.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var body: String?
    @NSManaged public var createdDate: Date?
    @NSManaged public var date: Date?
    @NSManaged public var title: String?
    @NSManaged public var updatedDate: Date?

}

extension Note : Identifiable {

}

//
//  NotesAndEventsModel.swift
//  swaap
//
//  Created by Jesse Ruiz on 6/5/20.
//  Copyright © 2020 swaap. All rights reserved.
//

import Foundation
import CoreData

extension ConnectionContact {
    var noteRepresentation: NoteRepresentation? {
        guard let notes = notes else { return nil }
        return NoteRepresentation(notes: notes)
    }
    
    @discardableResult convenience init(notes: String,
                                        context: NSManagedObjectContext) {
        self.init(context: context)
        self.notes = notes
    }
    
    @discardableResult convenience init?(noteRepresentation: NoteRepresentation, context: NSManagedObjectContext) {
        self.init(notes: noteRepresentation.notes,
                  context: context)
    }
}

extension ConnectionContact {
    var eventRepresentation: EventRepresentation? {
        guard let events = events else { return nil }
        return EventRepresentation(events: events)
    }
    
    @discardableResult convenience init(events: String,
                                        context: NSManagedObjectContext) {
        self.init(context: context)
        self.events = events
    }
    
    @discardableResult convenience init?(eventRepresentation: EventRepresentation, context: NSManagedObjectContext) {
        self.init(events: eventRepresentation.events,
                  context: context)
    }
}

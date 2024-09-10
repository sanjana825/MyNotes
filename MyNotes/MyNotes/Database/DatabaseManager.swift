//
//  DatabaseManager.swift
//  MyNotes
//
//  Created by Sanjana on 09/08/24.
//

import UIKit
import CoreData

class DatabaseManager {
    private var context : NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    // MARK: - CRUD Methods

    func addNote(_ note : NoteModel) {
        let noteEntity = NoteEntity(context: context)
        noteEntity.noteBody = note.noteBody
        noteEntity.noteTitle = note.noteTitle
        noteEntity.date = note.date
        do {
            try context.save()
        } catch  {
            print("Error saving note", error)
        }
    }
    
    func fetchNotes() -> [NoteEntity] {
        var notes : [NoteEntity] = []
        do {
            notes =  try context.fetch(NoteEntity.fetchRequest())
        }
        catch  {
            print("Error fetching notes", error)
        }
        return notes
    }
    
    func updateNote(_ newNote : NoteModel, noteEntity : NoteEntity) {
        noteEntity.noteBody = newNote.noteBody
        noteEntity.noteTitle = newNote.noteTitle
        noteEntity.date = newNote.date
        do {
            try context.save()
        } catch  {
            print("Error updating note", error)
        }
    }
    
    func deleteNote(noteEntity : NoteEntity) {
        context.delete(noteEntity)
        do {
            try context.save()
            
        } catch  {
            print("Error deleting note", error)
        }
    }
    
    func searchNote(title : String) -> [NoteEntity] {
        var notesArray : [NoteEntity] = []
        let query = NoteEntity.fetchRequest()
        let titlePredicate = NSPredicate(format: "noteTitle CONTAINS[c] %@", title)
        let bodyPredicate = NSPredicate(format: "noteBody CONTAINS[c] %@", title)
        let combinedPredicate = NSCompoundPredicate(type: .or, subpredicates: [titlePredicate, bodyPredicate])
        
        // Assign the predicate to the fetch request
        query.predicate = combinedPredicate
        do{
            notesArray = try context.fetch(query)
        }catch{
            print("error")
        }
        return notesArray
    }
}

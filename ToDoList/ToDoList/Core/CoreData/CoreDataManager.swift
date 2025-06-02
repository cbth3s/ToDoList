//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by name surname on 01.06.2025.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let container: NSPersistentContainer
    let mainContext: NSManagedObjectContext
    let backgroundContext: NSManagedObjectContext
    
    private init() {
        
        container = NSPersistentContainer(name: "ItemsContainer")
        container.loadPersistentStores { _, error  in
            if let error = error {
                print("ERROR LOADING CORE DATA. \(error)")
            } else {
                print("Successfully loaded core data!")
            }
        }
        
        //Context for main flow
        mainContext = container.viewContext
        mainContext.automaticallyMergesChangesFromParent = true ///auto get changes from parent
        
        //Context for background flow
        backgroundContext = container.newBackgroundContext()
        backgroundContext.automaticallyMergesChangesFromParent = true ///auto get changes from parent
    }
    
    func saveMainContext() {
        
        guard mainContext.hasChanges else { return }
        do {
            try mainContext.save()
            print("SAVED SUCCESSFULLY")
        } catch let error {
            print("ERROR SAVING CoreData. \(error.localizedDescription)")
        }
    }
    
    func saveBackgroundContext() {
        
        guard backgroundContext.hasChanges else { return }
        do {
            try backgroundContext.save()
            print("BACKGROUND CONTEXT SAVED SUCCESSFULLY")
        } catch let error {
            print("ERROR SAVING BACKGROUND CONTEXT: \(error.localizedDescription)")
        }
    }
    
    
}

extension CoreDataManager {
    
    func getLastItemID() -> Int16 {
        
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        request.fetchLimit = 1
        
        do {
            if let lastItem = try mainContext.fetch(request).first {
                return lastItem.id
            }
        } catch {
            print("Error fetching last ID: \(error)")
        }
        return 0
    }
}


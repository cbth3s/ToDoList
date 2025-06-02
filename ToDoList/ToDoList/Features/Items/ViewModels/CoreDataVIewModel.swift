//
//  CoreDataVIewModel.swift
//  ToDoList
//
//  Created by name surname on 01.06.2025.
//

import Foundation
import CoreData

final class CoreDataViewModel: ObservableObject {
    
    let manager = CoreDataManager.shared
    
    @Published var items: [ItemEntity] = []
    @Published var searchText: String = ""
    
    init() {
        fetchItem()
    }
    
    var filteredItems: [ItemEntity] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter {
                $0.title?.range(of: searchText, options: .caseInsensitive) != nil || $0.details?.range(of: searchText, options: .caseInsensitive) != nil
            }
        }
    }
    
    func fetchItem() {
        let request = NSFetchRequest<ItemEntity>(entityName: "ItemEntity")
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            do {
                let items = try self?.manager.mainContext.fetch(request) ?? []
                DispatchQueue.main.async {
                    self?.items = items
                }
            } catch let error {
                print("FETCHING ERROR. \(error.localizedDescription)")
            }
        }
    }
    
    func addItem(title: String, id: Int16, details: String?, date: Date, completed: Bool) {
        
        ///Check that the title is not empty or consists only of spaces
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("Ошибка: название задачи не может быть пустым")
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return } 
            
            let backgroundContext = self.manager.backgroundContext
            backgroundContext.perform {
                let newItem = ItemEntity(context: backgroundContext)
                newItem.title = title
                newItem.id = self.manager.getLastItemID() + 1
                newItem.details = details
                newItem.date = date
                newItem.completed = completed
                
                do {
                    try backgroundContext.save()
                    DispatchQueue.main.async {
                        self.fetchItem()
                    }
                } catch let error {
                    print("SAVING ERROR AFTER ADDING NEW ITEM. \(error.localizedDescription)")
                }
            }
        }
    }
    
    func toggleCompletion(item: ItemEntity) {
        let itemID = item.objectID
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            let backgroundContext = self.manager.backgroundContext
            backgroundContext.perform {
                do {
                    let itemToUpdate = backgroundContext.object(with: itemID) as! ItemEntity
                    itemToUpdate.completed.toggle()
                    try backgroundContext.save()
                    
                    DispatchQueue.main.async {
                        self.fetchItem()
                    }
                } catch {
                    print("Ошибка при изменении статуса: \(error)")
                }
            }
        }
    }
    
    func deleteItem(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let itemID = items[index].objectID
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            let backgroundContext = self.manager.backgroundContext
            backgroundContext.perform {
                
                do {
                    let item = backgroundContext.object(with: itemID)
                    backgroundContext.delete(item)
                    try backgroundContext.save()
                    DispatchQueue.main.async {
                        self.fetchItem()
                    }
                } catch let error {
                    print("DELETING ERROR. \(error.localizedDescription)")
                }
            }
        }
    }
    
    func updateItem(item: ItemEntity, newTitle: String?, newDetails: String?) {
        let itemID = item.objectID
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            let backgroundContext = self.manager.backgroundContext
            backgroundContext.perform {
                
                do {
                    let itemToUpdate = backgroundContext.object(with: itemID) as? ItemEntity
                    
                    if let newTitle = newTitle {
                        itemToUpdate?.title = newTitle
                    }
                    
                    if let newDetails = newDetails {
                        itemToUpdate?.details = newDetails
                    }
                    
                    try backgroundContext.save()
                    DispatchQueue.main.async {
                        self.fetchItem()
                    }
                }catch let error {
                    print("UPDATE ERROR. \(error.localizedDescription)")
                }
            }
        }
    }
}

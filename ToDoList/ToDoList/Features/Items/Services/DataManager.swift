//
//  DataManager.swift
//  ToDoList
//
//  Created by name surname on 01.06.2025.
//

import Foundation
import CoreData

final class DataManager {
    
    static let shared = DataManager()
    private let userDefaults = UserDefaults.standard
    private let viewModel = CoreDataViewModel()
    
    private init() {}
    
    func seedDataFromAPI() {
        
        guard !userDefaults.bool(forKey: "hasSyncedInitialData") else { return }
        
        ApiManager.fetchItems { [weak self] result in
            switch result {
            case .success(let items):
                self?.saveItemsToCoreData(items: items)
                self?.userDefaults.set(true, forKey: "hasSyncedInitialData")
            case .failure(let error):
                print("Sync error: \(error.localizedDescription)")
            }
        }
    }
    
    private func saveItemsToCoreData(items: [ItemModel]) {
        
        items.forEach { item in
            self.viewModel.addItem(
                title: item.title,
                id: Int16(item.id),
                details: item.details,
                date: item.date ?? Date(),
                completed: item.completed
            )
        }
    }
}

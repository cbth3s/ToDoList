//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by name surname on 01.06.2025.
//

import SwiftUI

@main
struct ToDoListApp: App {
    
    init() {
        DataManager.shared.seedDataFromAPI()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

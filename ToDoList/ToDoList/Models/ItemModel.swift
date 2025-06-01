//
//  ItemModel.swift
//  ToDoList
//
//  Created by name surname on 01.06.2025.
//

import Foundation
import CoreData

struct ItemModel: Identifiable, Decodable {
    var id: Int
    var title: String
    var completed: Bool
    var date: Date?
    var details: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, title = "todo", completed
    }
}

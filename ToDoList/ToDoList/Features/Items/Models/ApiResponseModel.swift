//
//  ApiResponceModel.swift
//  ToDoList
//
//  Created by name surname on 01.06.2025.
//

import Foundation

struct ApiResponseModel: Decodable {
    let todos: [ItemModel]
    let total: Int
    let skip: Int
    let limit: Int
}

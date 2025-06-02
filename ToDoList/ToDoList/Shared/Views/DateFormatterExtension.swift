//
//  DateFormatterExtension.swift
//  ToDoList
//
//  Created by name surname on 02.06.2025.
//

import Foundation

extension DateFormatter {
    
    static var shortDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter
    }
}

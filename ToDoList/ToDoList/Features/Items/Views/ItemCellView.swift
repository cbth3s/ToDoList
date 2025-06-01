//
//  ItemCellView.swift
//  ToDoList
//
//  Created by name surname on 01.06.2025.
//

import SwiftUI

struct ItemCellView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var item: ItemEntity
    var onToggleCompletion: () -> Void
    
    
    var body: some View {
        HStack(alignment: .top) {
            
            Button {
                withAnimation {
                    onToggleCompletion()
                }
            } label: {
                Image(systemName: item.completed ? "checkmark.circle" : "circle")
                    .foregroundStyle(item.completed ? .yellow : .gray)
                    .font(.system(size: 25))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title ?? "Без названия")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(item.completed ? .gray : textColor)
                    .strikethrough(item.completed)
                
                if let details = item.details, !details.isEmpty {
                    Text(details)
                        .font(.subheadline)
                        .foregroundStyle(item.completed ? .gray : textColor)
                }
                
                Text(dateFormat)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private var dateFormat: String {
        let format = DateFormatter()
        format.dateFormat = "dd/MM/yy"
        return format.string(from: item.date ?? Date())
    }
    private var textColor: Color {
            colorScheme == .dark ? .white : .black
        }
}

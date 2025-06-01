//
//  ItemContextMenu.swift
//  ToDoList
//
//  Created by name surname on 01.06.2025.
//

import SwiftUI

struct ItemContextMenu: View {
    let item: ItemEntity
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onShare: () -> Void
    @State private var showShareSheet = false
    
    var body: some View {
        Button {
            onEdit()
        } label: {
            Label("Редактировать", systemImage: "pencil")
        }
        
        Button {
            onShare()
        } label: {
            Label("Поделиться", systemImage: "square.and.arrow.up")
        }
        
        Button(role: .destructive) {
            onDelete()
        } label: {
            Label("Удалить", systemImage: "trash")
        }
    }
}



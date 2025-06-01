//
//  MainView.swift
//  ToDoList
//
//  Created by name surname on 01.06.2025.
//

import SwiftUI


struct MainView: View {
    
    @StateObject private var vm = CoreDataViewModel()
    @State var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.items, id: \.self) { item in
                    ItemCellView(item: item) {
                        vm.toggleCompletion(item: item)
                    }
                    .contextMenu {
                        Button {
                            
                        } label: {
                            Label("Редактировать", systemImage: "pencil")
                        }
                        Button {
                            
                        } label: {
                            Label("Поделиться", systemImage: "square.and.arrow.up")
                        }
                        Button(role: .destructive) {
                            vm.deleteItem()
                        } label: {
                            Label("Удалить", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle("Задачи")
            .searchable(text: $searchText)
        }
    }
}

#Preview {
    MainView()
}

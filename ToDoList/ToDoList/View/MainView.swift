//
//  MainView.swift
//  ToDoList
//
//  Created by name surname on 01.06.2025.
//

import SwiftUI


struct MainView: View {
    
    @State private var activeShareItem: ItemEntity?
    @State private var isCreatingNewItem = false
    @State private var editingItem: ItemEntity?
    @StateObject private var vm = CoreDataViewModel()
    
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(vm.filteredItems, id: \.self) { item in
                        ItemCellView(item: item) {
                            vm.toggleCompletion(item: item)
                        }
                        .contextMenu {
                            ItemContextMenu(
                                item: item,
                                onEdit: { editingItem = item },
                                onDelete: {
                                    if let index = vm.items.firstIndex(of: item) {
                                        vm.deleteItem(indexSet: IndexSet(integer: index))
                                    }
                                },
                                onShare: { activeShareItem = item }
                            )
                        }
                    }
                }
                .sheet(item: $activeShareItem) { item in
                    ActivityView(activityItems: ["Моя задача: \(item.title ?? "Без названия")\n\(item.details ?? "")"])
                }
                BottomBarView(vm: vm) { isCreatingNewItem = true }
                
            }
            .listStyle(.plain)
            .navigationTitle("Задачи")
            .searchable(text: $vm.searchText)
            ///Navigation to edit task
            .navigationDestination(item: $editingItem) { item in
                ItemView(vm: vm, item: item)
            }
            ///Navigation to create new task
            .navigationDestination(isPresented: $isCreatingNewItem) {
                ItemView(vm: vm)
            }
        }
    }
}

#Preview {
    MainView()
}

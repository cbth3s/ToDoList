//
//  ItemView.swift
//  ToDoList
//
//  Created by name surname on 01.06.2025.
//

import SwiftUI

struct ItemView: View {
    
    
    @ObservedObject var vm = CoreDataViewModel()
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var date: Date =  .now
    @State private var details: String = ""
    
    private var isEditingItem: ItemEntity?
    
    init(vm: CoreDataViewModel) {
            self.vm = vm
        }
    
    init(vm: CoreDataViewModel, item: ItemEntity) {
            self.vm = vm
            self.isEditingItem = item
            _title = State(initialValue: item.title ?? "")
            _details = State(initialValue: item.details ?? "")
            _date = State(initialValue: item.date ?? .now)
        }
    
    var body: some View {
        NavigationStack {
            
            VStack(alignment: .leading) {
                
                TextField("Name", text: $title)
                    .font(.system(size: 35, weight: .bold))
                    .padding([.horizontal, .top])
                
                
                Text(dateFormat)
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                    .padding(.horizontal)
                
                TextEditor(text: $details)
                    .padding(.leading, 10)
                
                Spacer()
            }
            .padding(.horizontal, 5)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { ButtonBackView{dismiss() } }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onDisappear { saveOrUpdate() }
        .onTapGesture { hideKeyboard() }
    }
    
    
    private func saveOrUpdate() {
           if let isEditingItem = isEditingItem {
               vm.updateItem(
                   item: isEditingItem,
                   newTitle: title,
                   newDetails: details,
               )
           } else {
               vm.addItem(
                title: title,
                id: vm.manager.getLastItemID() + 1,
                details: details,
                date: date,
                completed: false
               )
           }
       }
    
    private var dateFormat: String {
        let format = DateFormatter()
        format.dateFormat = "dd/MM/yy"
        return format.string(from: date)
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    ItemView(vm: CoreDataViewModel())
}

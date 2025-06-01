//
//  BottomBarView.swift
//  ToDoList
//
//  Created by name surname on 01.06.2025.
//

import SwiftUI

struct BottomBarView: View {
    @ObservedObject var vm: CoreDataViewModel
    var addAction: () -> Void
    
    var body: some View {
        HStack {

            Text("Задач: \(vm.items.count)")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.leading, 50)
            
            Button(action: addAction) {
                Image(systemName: "square.and.pencil")
                    .font(.system(size: 32))
                    .foregroundColor(.yellow)
            }
            .padding(.trailing)
        }
        .padding(.vertical, 10)
        .background(.gray.opacity(0.6))
        .overlay(Divider(), alignment: .top)
    }
}


struct BottomBarView_Previews: PreviewProvider {
    static var previews: some View {
        let mockVM = CoreDataViewModel()
        // Добавляем тестовые данные
        mockVM.items = [ItemEntity(), ItemEntity(), ItemEntity()]
        
        return BottomBarView(vm: mockVM, addAction: {})
            .previewDisplayName("3 задачи")
            .previewLayout(.sizeThatFits)
    }
}

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
            
            Button {
                addAction()
            } label: {
                Image(systemName: "square.and.pencil")
                    .font(.system(size: 32))
                    .foregroundColor(.yellow)
            }
            .padding(.trailing)
        }
        .padding(.vertical, 10)
        .background(.gray.opacity(0.35))
        .edgesIgnoringSafeArea(.bottom)
        .overlay(Divider(), alignment: .top)
    }
}


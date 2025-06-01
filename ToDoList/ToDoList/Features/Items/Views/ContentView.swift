//
//  ContentView.swift
//  ToDoList
//
//  Created by name surname on 01.06.2025.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var ViewModel = CoreDataViewModel()
    
    @State var itemName: String = ""
    @State var itemDetail: String = ""
    @State var itemDate: Date = Date()
    @State var itemCompleted: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                TextField("Enter name for item: ", text: $itemName)
                    .font(.headline)
                    .padding(.leading)
                    .frame(height: 55)
                    .background(.gray)
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                TextField("Enter details for item: ", text: $itemDetail)
                    .font(.headline)
                    .padding(.leading)
                    .frame(height: 55)
                    .background(.gray)
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                Toggle(isOn: $itemCompleted) {
                    Text("Item completed")
                        .padding()
                }
                
                Button {
                    guard !itemName.isEmpty else { return }
                    ViewModel.addItem(title: itemName,
                                      id: 1,
                                      details: itemDetail,
                                      date: Date(),
                                      completed: itemCompleted)
                } label: {
                    Text("Save")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(.pink)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            
            List {
                ForEach(ViewModel.items) {item in
                    VStack {
                        Text(item.title ?? "No Name")
                        Text(item.details ?? "No Details")
                        Text("\(item.id)")
                    }
                }
                .onDelete(perform: ViewModel.deleteItem)
            }
        }
    }
}


#Preview {
    ContentView()
}

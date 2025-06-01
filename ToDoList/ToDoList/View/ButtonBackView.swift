//
//  ButtonBackView.swift
//  ToDoList
//
//  Created by name surname on 01.06.2025.
//

import SwiftUI

struct ButtonBackView: View {
    
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "chevron.backward")
                    .bold()
                Text("Назад")
                    .font(.title3)
            }
            .foregroundStyle(.yellow)
            .padding(.leading, -10)
        }
    }
}

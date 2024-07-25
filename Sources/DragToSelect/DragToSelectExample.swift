//
//  File.swift
//  
//
//  Created by Dave Coleman on 25/7/2024.
//

import SwiftUI


struct Item: Identifiable {
    let id = UUID()
    let title: String
}

struct DragSelectExample: View {
    
    let items = [Item(title: "Item 1"), Item(title: "Item 2"), Item(title: "Item 3")]
    
    var body: some View {
        
        DragToSelect(items: items) { item, isSelected in
            
            Text(item.title)
                .padding()
                .background(isSelected ? Color.blue.opacity(0.3) : Color.clear)
                .foregroundColor(.white)
            
        }
        .border(Color.purple.opacity(0.3))
    }
}
#Preview {
    DragSelectExample()
        .padding(40)
        .frame(width: 500, height: 700)
        .background(.black.opacity(0.6))
}

//
//  ContentView.swift
//  GroceryList
//
//  Created by JPL-ST-SPRING2022 on 4/10/23.
//

import SwiftUI


struct ContentView: View {
    @State private var selection = 0
    
    var body: some View {
        
        TabView(selection: $selection) {
            ItemsListView()
                .tabItem {
                    Image(systemName: "carrot.fill")
                        .renderingMode(.template)
                    Text("Items")
                }
                .tag(0)
            StoresView()
                .tabItem {
                    Image(systemName: "basket")
                        .renderingMode(.template)
                    Text("Stores")
                }
                .tag(1)
            ChecklistView()
                .tabItem {
                    Image(systemName: "checklist")
                        .renderingMode(.template)
                    Text("Checklist")
                }
                .tag(2)
        }.accentColor(.orange)
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

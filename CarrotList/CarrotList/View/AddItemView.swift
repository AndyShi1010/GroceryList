//
//  AddItem.swift
//  GroceryList
//
//  Created by JPL-ST-SPRING2022 on 5/8/23.
//

import SwiftUI

struct SelectableAttr: Identifiable {
    let id = UUID()
    let name: String
    var isSelected: Bool = false
}

struct AddItemView: View {
    
    
    private let store: CoreDataItemsStore = CoreDataItemsStore()
    
    @Binding var showSheet: Bool
    
    @State private var itemName: String = ""
    @State private var dollars: Int = 0
    @State private var cents: Int = 0
    @State private var selectableAttrs: [SelectableAttr] = [
        SelectableAttr(name: "Organic"),
        SelectableAttr(name: "Gluten-Free"),
        SelectableAttr(name: "Vegan"),
        SelectableAttr(name: "Non-GMO")]
    @State private var selectedAttrs: [String] = []
    
    let refresh: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section("Name") {
                    TextField("Name", text: $itemName)
                }
                Section("Price") {
                    VStack {
                        HStack{
                            Text("Price")
                            Spacer()
                            Text(formatAsCurrency(dollars, cents) ?? "")
                        }
                        
                        HStack {
                            VStack {
                                Picker(selection: $dollars, label: Text("Dollars")) {
                                    ForEach(0..<100) { dollar in
                                        Text("\(dollar)")
                                    }
                                }.pickerStyle(.wheel)
                            }
                            Text(".")
                            VStack {
                                Picker(selection: $cents, label: Text("Cents")) {
                                    ForEach(0..<100) { cent in
                                        Text("\(cent)")
                                    }
                                }.pickerStyle(.wheel)
                            }
                        }
                    }
                }
                Section("Tags") {
                    List(selectableAttrs) { attr in
                        Button(action: {
                            if let index = selectableAttrs.firstIndex(where: { $0.id == attr.id }) {
                                selectableAttrs[index].isSelected.toggle()
                            }
                        }) {
                            HStack {
                                Text(attr.name)
                                Spacer()
                                if attr.isSelected {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Add Item", displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button("Discard") {
                        showSheet = false;
                    },
                trailing:
                    Button("Save") {
                        let priceDouble: Double = Double(dollars) + Double(Double(cents) / 100)
                        let priceHistory = [Date() : priceDouble]
                        print(priceDouble)
                        print(priceHistory)
                        var selectedAttributes: [String] = [];
                        for i in selectableAttrs {
                            if (i.isSelected) {
                                selectedAttributes.append(i.name)
                                print(i.name)
                            }
                        }
                        
                        store.save(item: GroceryItem(name: itemName, price: priceDouble, priceHistory: priceHistory, attributes: selectedAttributes))
                        showSheet = false;
                        refresh()
                    }
                    .disabled(self.itemName.isEmpty)
            )
            
        }.accentColor(.orange)
    }
    func formatAsCurrency(_ main: Int, _ cents: Int) -> String? {
        let price: Double = Double(main) + Double(Double(cents) / 100)
        print(price)
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        let number = NSNumber(value: price)
        return formatter.string(from: number)
    }
}

//struct AddItem_Previews: PreviewProvider {
//
//    static var previews: some View {
//        AddItemView()
//    }
//}

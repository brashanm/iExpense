//
//  ContentView.swift
//  iExpense
//
//  Created by Мирсаит Сабирзянов on 10.11.2023.
//

import SwiftUI


struct Item: Identifiable, Codable{
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses{
    var items = [Item](){
        didSet{
            if let encoded = try? JSONEncoder().encode(items){
                UserDefaults.standard.setValue(encoded, forKey: "Items")
            }
        }
    }
    
    init(){
        if let savedItems = UserDefaults.standard.data(forKey: "Items"){
            if let decoder = try? JSONDecoder().decode([Item].self, from: savedItems){
                items = decoder
                return
            }
        }
        items = []
    }
}

struct ContentView: View {
    
    @State var expenses = Expenses()
    
    @State private var showAddPanel = false
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(expenses.items) { item in
                        if (item.type == "Personal") {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name).font(.headline)
                                    Text(item.type)
                                }
                                Spacer()
                                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "CAD"))
                                    .foregroundStyle(item.amount < 10 ? .green : (item.amount < 100 ? .yellow : .red))
                            }
                        }
                    }
                    .onDelete(perform: removeItem)
                } header: {
                    Text("Personal")
                }
                
                
                Section {
                    ForEach(expenses.items) { item in
                        if (item.type == "Business") {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name).font(.headline)
                                    Text(item.type)
                                }
                                Spacer()
                                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "CAD"))
                                    .foregroundStyle(item.amount < 10 ? .green : (item.amount < 100 ? .yellow : .red))
                            }
                        }
                    }
                    .onDelete(perform: removeItem)
                } header: {
                    Text("Business")
                }

            }
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        AddView(expenses: expenses)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationTitle("iExpense")
        }
    }
    
    func removeItem(at offsets: IndexSet){
        expenses.items.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}

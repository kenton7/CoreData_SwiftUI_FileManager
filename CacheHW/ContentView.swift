//
//  ContentView.swift
//  CacheHW
//
//  Created by Илья Кузнецов on 27.05.2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \User.name, ascending: true)],
        animation: .default)
    private var users: FetchedResults<User>
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        
        NavigationStack {
            List {
                ForEach(viewModel.users, id: \.id) { user in
                    NavigationLink {
                        DetailView(user: user)
                    } label: {
                        VStack(alignment: .center) {
                            Text(user.name ?? "")
                                .font(.title)
                            Text(user.email ?? "")
                            Text(user.phone ?? "")
                            Text(user.website ?? "")
                        }
                        
                    }
                }
                .onDelete(perform: { indexSet in
                    deleteItems(offsets: indexSet)
                })
            }
            .navigationTitle("Пользователи")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            do {
                try await viewModel.fetchData()
            } catch let error {
                print("Ошибка при попытке получения юзеров из сети: \(error.localizedDescription)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { users[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

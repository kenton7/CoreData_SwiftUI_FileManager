//
//  DetailView.swift
//  CacheHW
//
//  Created by Илья Кузнецов on 27.05.2024.
//

import SwiftUI

struct DetailView: View {
    
    let user: UserModel
    let viewModel = ViewModel()
    @State private var isAlertShowing = false
    @State private var isSuccessSaving = false
    
    var body: some View {
        VStack {
            Text("Имя: \(user.name ?? "")")
            Text("Email: \(user.email ?? "")")
            Text("Телефон: \(user.phone ?? "")")
            Text("Сайт: \(user.website ?? "")")
            
            Button(action: {
                viewModel.saveToFileManager(user) { result in
                    switch result {
                    case .success(let data):
                        isAlertShowing = true
                        isSuccessSaving = true
                    case .failure(let error):
                        isAlertShowing = true
                        isSuccessSaving = false
                        print("error \(error.localizedDescription)")
                    }
                }
            }, label: {
                Text("Скачать информацию пользователя")
            })
            .buttonStyle(.borderedProminent)
            .alert(isSuccessSaving ? "Успех" : "Ошибка", isPresented: $isAlertShowing) {
                EmptyView()
            } message: {
                isSuccessSaving ? Text("Данные о пользователе успешно сохранены") : Text("Ошибка при сохранении данных пользователя")
            }
        }
    }
}

#Preview {
    DetailView(user: UserModel(id: 1, name: "Ilya", username: "Ilya", email: "sdsd@sdsd.com", phone: "123435", website: "google"))
}

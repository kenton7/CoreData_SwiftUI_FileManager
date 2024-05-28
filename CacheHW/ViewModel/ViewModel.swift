//
//  ViewModel.swift
//  CacheHW
//
//  Created by Илья Кузнецов on 27.05.2024.
//

import Foundation

class ViewModel: ObservableObject {
    
    @Published var users = [UserModel]()
    
    func fetchData() async throws {
        let cachedUsers = CacheManager.shared.fetchUsers()
        if !cachedUsers.isEmpty {
            await updateUsers(cachedUsers)
        } else {
            try await getUsersFromNetwork()
        }
    }
    
    func getUsersFromNetwork() async throws {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            throw NSError(domain: "Incorrect URL", code: 404)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedUsers = try JSONDecoder().decode([UserModel].self, from: data)
        CacheManager.shared.saveUsers(decodedUsers)
        await updateUsers(decodedUsers)
    }
    
    @MainActor private func updateUsers(_ users: [UserModel]) {
        self.users = users
    }
    
    func download(user: UserModel) throws {
        let encoder = JSONEncoder()
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let documentURL = (directoryURL?.appendingPathComponent("user").appendingPathExtension("json"))!
        let data = try? encoder.encode(user)
        
        do {
            try data?.write(to: documentURL, options: .completeFileProtection)
            print("Download")
        } catch let error {
            print("Ошибка при сохранении пользователя на устройство: \(error.localizedDescription)")
        }
    }
    
    func saveToFileManager(_ user: UserModel, completion: @escaping (Result<UserModel, Error>) -> Void) {
        FileManagerService.shared.save(user, fileName: "\(user.name ?? "")_\(user.id ?? 0).json")
        completion(.success(user))
    }
    
    func loadFromFileManager(_ user: UserModel) -> UserModel? {
        return FileManagerService.shared.load("\(user.name ?? "")_\(user.id ?? 0).json", as: UserModel.self)
    }
}

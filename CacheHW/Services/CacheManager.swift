//
//  CacheManager.swift
//  CacheHW
//
//  Created by Илья Кузнецов on 27.05.2024.
//

import Foundation
import CoreData

protocol ICacheManager {
    func saveUsers(_ users: [UserModel])
    func fetchUsers() -> [UserModel]
    func clearCache()
}

class CacheManager: ICacheManager {
    static let shared = CacheManager()
    private let context: NSManagedObjectContext
    
    private init() {
        context = PersistenceController.shared.container.viewContext
    }
    
    func saveUsers(_ users: [UserModel]) {
        clearCache()
        
        users.forEach {
            let cachedUser = User(context: context)
            cachedUser.id = Int64($0.id ?? 0)
            cachedUser.name = $0.name ?? ""
            cachedUser.email = $0.email ?? ""
            cachedUser.phone = $0.phone ?? ""
            cachedUser.website = $0.website ?? ""
        }
        
        do {
            try context.save()
        } catch let error {
            print("Ошибка при сохранении в кеш: \(error.localizedDescription)")
        }
    }
    
    func fetchUsers() -> [UserModel] {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            return results.map { UserModel(id: Int($0.id),
                                           name: $0.name,
                                           username: $0.username,
                                           email: $0.email,
                                           phone: $0.phone,
                                           website: $0.website)
            }
        } catch let error {
            print("Ошибка при загрузке пользователей из кеша \(error.localizedDescription)")
            return []
        }
    }
    
    func clearCache() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = User.fetchRequest()
        let delete = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(delete)
            try context.save()
        } catch let error {
            print("Ошибка при удалении из кеша \(error.localizedDescription)")
        }
    }
}

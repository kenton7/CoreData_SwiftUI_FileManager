//
//  FileManagerService.swift
//  CacheHW
//
//  Created by Илья Кузнецов on 28.05.2024.
//

import Foundation

protocol IFileManagerService {
    func save<T: Codable>(_ user: T, fileName: String)
    func load<T: Codable>(_ fileName: String, as type: T.Type) -> T?
    func delete(_ fileName: String)
}

class FileManagerService: IFileManagerService {
    static let shared = FileManagerService()
    private let fileManager = FileManager.default
    private let directoryURL: URL
    
    private init() {
        directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func save<T: Codable>(_ user: T, fileName: String) {
        let fileURL = directoryURL.appending(path: fileName, directoryHint: .checkFileSystem)
        do {
            let data = try JSONEncoder().encode(user)
            try data.write(to: fileURL, options: .atomic)
            print("Данные пользователя успешно сохранены в \(fileURL)")
        } catch let error {
            print("Ошибка при сохранении данных пользователя: \(error.localizedDescription)")
        }
    }
    
    func load<T: Codable>(_ fileName: String, as type: T.Type) -> T? {
        let fileURL = directoryURL.appending(path: fileName, directoryHint: .checkFileSystem)
        
        guard fileManager.fileExists(atPath: fileURL.path(percentEncoded: true)) else {
            print("Файла по данному пути \(fileURL.path(percentEncoded: true)) не существует")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let user = try JSONDecoder().decode(T.self, from: data)
            return user
        } catch let error {
            print("Ошибка при загрузке данных пользователя: \(error.localizedDescription)")
            return nil
        }
    }
    
    func delete(_ fileName: String) {
        let fileURL = directoryURL.appending(path: fileName, directoryHint: .checkFileSystem)
        do {
            try fileManager.removeItem(at: fileURL)
            print("Файл успешно удален из: \(fileURL)")
        } catch let error {
            print("Ошибка при удалении файла: \(error.localizedDescription)")
        }
    }
    
    
}

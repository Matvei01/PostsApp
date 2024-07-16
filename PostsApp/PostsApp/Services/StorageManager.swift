//
//  StorageManager.swift
//  PostsApp
//
//  Created by Matvei Khlestov on 16.07.2024.
//

import CoreData

final class StorageManager {
    
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PostsApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    // MARK: - CRUD
    func create(_ postName: String, imageURL: URL) {
        let post = Post(context: viewContext)
        post.title = postName
        post.date = Date()
        post.imagePath = imageURL.lastPathComponent
        print("Saving image path: \(imageURL.lastPathComponent)")
        saveContext()
    }
    
    func update(_ post: Post, newName: String, imageURL: URL) {
        post.title = newName
        post.date = Date()
        post.imagePath = imageURL.lastPathComponent
        print("Updating image path: \(imageURL.lastPathComponent)")
        saveContext()
    }
    
    func delete(_ post: Post) {
        viewContext.delete(post)
        saveContext()
    }
    
    func fetchData(completion: (Result<[Post], Error>) -> Void) {
        let fetchRequest = Post.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let posts = try viewContext.fetch(fetchRequest)
            completion(.success(posts))
        } catch let error {
            completion(.failure(error))
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


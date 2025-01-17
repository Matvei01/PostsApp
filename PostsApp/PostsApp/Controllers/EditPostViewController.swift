//
//  EditPostViewController.swift
//  PostsApp
//
//  Created by Matvei Khlestov on 16.07.2024.
//

import UIKit

final class EditPostViewController: BaseViewController {
    
    // MARK: - Public Properties
    var post: Post?
    
    // MARK: - Private Properties
    private let fileManager = FileManager.default
    
    override func setupNavigationBar() {
        title = "Editing post"
        super.setupNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postTextView.text = post?.title
        if let imagePath = post?.imagePath {
            loadPostImage(from: imagePath)
        }
    }
    
    override func save() {
        guard let postName = postTextView.text, !postName.isEmpty else {
            showAlert(title: "Error", message: "Fill in all the fields")
            return
        }
        
        guard let image = postImageView.image else {
            showAlert(title: "Error", message: "No image selected")
            return
        }
        
        let imageName = UUID().uuidString
        if let imageURL = saveImage(image, withName: imageName) {
            guard let post = post else { return }
            storageManager.update(post, newName: postName, imageURL: imageURL)
            delegate?.reloadData()
            navigationController?.popToRootViewController(animated: true)
        } else {
            showAlert(title: "Error", message: "Could not save image")
        }
    }
    
    private func loadPostImage(from imagePath: String) {
        guard let documentsURL = fileManager.documentsDirectoryURL() else {
            print("Failed to get documents directory URL")
            return
        }
        let imageURL = documentsURL.appendingPathComponent(imagePath)
        if let image = UIImage(contentsOfFile: imageURL.path) {
            postImageView.image = image
        } else {
            print("Failed to load image from path: \(imageURL.path)")
            postImageView.image = UIImage(systemName: "photo")
        }
    }
}

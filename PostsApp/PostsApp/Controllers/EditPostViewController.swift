//
//  EditPostViewController.swift
//  PostsApp
//
//  Created by Matvei Khlestov on 16.07.2024.
//

import UIKit

final class EditPostViewController: BaseViewController {
    var post: Post?
    
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
    
    private func loadPostImage(from path: String) {
        if let image = UIImage(contentsOfFile: path) {
            postImageView.image = image
        } else {
            postImageView.image = UIImage(systemName: "photo")
        }
    }
}

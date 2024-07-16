//
//  AddPostViewController.swift
//  PostsApp
//
//  Created by Matvei Khlestov on 16.07.2024.
//

import UIKit

final class AddPostViewController: BaseViewController {
    
    override func setupNavigationBar() {
        title = "Adding new post"
        super.setupNavigationBar()
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
            storageManager.create(postName, imageURL: imageURL)
            delegate?.reloadData()
            navigationController?.popToRootViewController(animated: true)
        } else {
            showAlert(title: "Error", message: "Could not save image")
        }
    }
}

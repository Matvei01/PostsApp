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
        storageManager.create(postName)
        delegate?.reloadData()
        navigationController?.popToRootViewController(animated: true)
    }
}

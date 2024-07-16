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
    }
    
    override func save() {
        guard let postName = postTextView.text, !postName.isEmpty else {
            showAlert(title: "Error", message: "Fill in all the fields")
            return
        }
        
        guard let post = post else {
            showAlert(title: "Error", message: "Task not found")
            return
        }
        
        storageManager.update(post, newName: postName)
        delegate?.reloadData()
        navigationController?.popToRootViewController(animated: true)
    }
}

//
//  BaseViewController.swift
//  PostsApp
//
//  Created by Matvei Khlestov on 16.07.2024.
//

import UIKit

class BaseViewController: UIViewController {
    
    weak var delegate: PostViewControllerDelegate?
    
    let storageManager = StorageManager.shared
    
    // MARK: - UI Elements
    private lazy var backBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "arrow.backward"),
            primaryAction: backBarButtonItemTapped
        )
        return button
    }()
    
    lazy var postTextView: UITextView = {
        let textView = UITextView()
        textView.contentInset = UIEdgeInsets(
            top: 0,
            left: 15,
            bottom: 0,
            right: 15
        )
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        textView.layer.cornerRadius = 10
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 0.8
        return textView
    }()
    
    lazy var saveButton: UIButton = {
        createButton(
            withTitle: "Save",
            andColor: .appBlue,
            action: postButtonTapped,
            tag: 0
        )
    }()
    
    lazy var cancelButton: UIButton = {
        createButton(
            withTitle: "Cancel",
            andColor: .appRed,
            action: postButtonTapped,
            tag: 1
        )
    }()
    
    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        return picker
    }()
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(postImageTapped)
        )
        return tapGestureRecognizer
    }()
    
    lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .photo
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.addGestureRecognizer(tapGestureRecognizer)
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        return imageView
    }()
    
    lazy var addPostStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            postImageView, postTextView, saveButton, cancelButton
        ])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: -  Action
    private lazy var backBarButtonItemTapped = UIAction { [unowned self] _ in
        navigationController?.popToRootViewController(animated: true)
    }
    
    lazy var postButtonTapped = UIAction { [unowned self] action in
        guard let sender = action.sender as? UIButton else { return }
        
        switch sender.tag {
        case 0:
            save()
        default:
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        postTextView.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    // MARK: - Private methods
    func setupView() {
        view.backgroundColor = .white
        
        addSubviews()
        
        setupNavigationBar()
        
        setConstraints()
    }
    
    func addSubviews() {
        setupSubviews(addPostStackView)
    }
    
    func setupSubviews(_ subviews: UIView... ) {
        for subview in subviews {
            view.addSubview(subview)
        }
    }
    
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    func save() {}
    
    func createButton(withTitle title: String,
                      andColor color: UIColor,
                      action: UIAction,
                      tag: Int) -> UIButton {
        
        var attributes = AttributeContainer()
        attributes.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.baseBackgroundColor = color
        buttonConfiguration.buttonSize = .large
        buttonConfiguration.attributedTitle = AttributedString(title, attributes: attributes)
        let button = UIButton(configuration: buttonConfiguration, primaryAction: action)
        button.tag = tag
        button.widthAnchor.constraint(equalToConstant: 200).isActive = true
        return button
    }
    
    @objc func postImageTapped() {
        present(imagePicker, animated: true)
    }
}

// MARK: - Alert Controller
extension BaseViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { [unowned self] _ in
            self.postTextView.becomeFirstResponder()
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension BaseViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.editedImage] as? UIImage {
            postImageView.image = editedImage
        }
        
        picker.dismiss(animated: true)
    }
}

// MARK: - Constraints
extension BaseViewController {
    func setConstraints() {
        setConstraintsForAddStackView()
        setConstraintsForPostTextView()
    }
    
    func setConstraintsForAddStackView() {
        NSLayoutConstraint.activate([
            addPostStackView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 50
            ),
            addPostStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 30
            ),
            addPostStackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -30
            )
        ])
    }
    
    func setConstraintsForPostTextView() {
        NSLayoutConstraint.activate([
            postTextView.widthAnchor.constraint(
                equalTo: addPostStackView.widthAnchor
            ),
            postTextView.heightAnchor.constraint(
                equalTo: view.heightAnchor,
                multiplier: 0.2
            )
        ])
    }
}

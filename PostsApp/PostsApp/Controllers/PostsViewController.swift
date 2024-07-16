//
//  PostsViewController.swift
//  PostsApp
//
//  Created by Matvei Khlestov on 16.07.2024.
//

import UIKit

protocol PostViewControllerDelegate: AnyObject {
    func reloadData()
}

final class PostsViewController: UITableViewController {
    
    // MARK: - Private Properties
    private var posts: [Post] = []
    private var filteredPosts: [Post] = []
    private let reuseIdentifier = "CellId"
    private let storageManager = StorageManager.shared
    private let searchController = UISearchController(
        searchResultsController: nil
    )
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    private var searchBarIsEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    // MARK: - UI Elements
    private lazy var addBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(
            systemItem: .add,
            primaryAction: addBarButtonItemTapped
        )
        return button
    }()
    
    // MARK: -  Action
    private lazy var addBarButtonItemTapped = UIAction { [unowned self] _ in
        let addPostVC = AddPostViewController()
        addPostVC.delegate = self
        
        navigationController?.pushViewController(addPostVC, animated: true)
    }
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
}

// MARK: - Table view data source
extension PostsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFiltering ? filteredPosts.count : posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let post = isFiltering ? filteredPosts[indexPath.row] : posts[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = post.title
        if let date = post.date {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            content.secondaryText = formatter.string(from: date)
        } else {
            content.secondaryText = "No date"
        }
        cell.contentConfiguration = content
        return cell
    }
}

// MARK: - Table view delegate
extension PostsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = isFiltering ? filteredPosts[indexPath.row] : posts[indexPath.row]
        let editPostVC = EditPostViewController()
        editPostVC.delegate = self
        editPostVC.post = post
        
        navigationController?.pushViewController(editPostVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let post = getPost(at: indexPath)
            deletePost(post, at: indexPath)
        }
    }
}

// MARK: - UISearchResultsUpdating
extension PostsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
}

// MARK: - PostViewControllerDelegate
extension PostsViewController: PostViewControllerDelegate {
    func reloadData() {
        fetchData()
        tableView.reloadData()
    }
}

// MARK: - Private methods
private extension PostsViewController {
    func setupTableView() {
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: reuseIdentifier
        )
        
        fetchData()
        
        setupNavigationBar()
        
        setupSearchController()
    }
    
    func setupNavigationBar() {
        title = "Posts"
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = .appGreen
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.rightBarButtonItem = addBarButtonItem
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Tasks"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func fetchData() {
        storageManager.fetchData { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let posts):
                self.posts = posts
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredPosts = posts.filter { (post: Post) -> Bool in
            return post.title?.lowercased().contains(searchText.lowercased()) ?? false
        }
        
        tableView.reloadData()
    }
    
    func getPost(at indexPath: IndexPath) -> Post {
        isFiltering ? filteredPosts[indexPath.row] : posts[indexPath.row]
    }
    
    func deletePost(_ post: Post, at indexPath: IndexPath) {
        if isFiltering {
            filteredPosts = removePost(post, from: filteredPosts)
            posts = removePost(post, from: posts)
        } else {
            posts = removePost(post, from: posts)
            filteredPosts = removePost(post, from: filteredPosts)
        }
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
        storageManager.delete(post)
    }
    
    func removePost(_ post: Post, from list: [Post]) -> [Post] {
        var newList = list
        if let index = newList.firstIndex(of: post) {
            newList.remove(at: index)
        }
        return newList
    }
}

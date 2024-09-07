//
//  StoriesTableViewController.swift
//  HNReaderUIKit
//
//  Created by Sargis Khachatryan on 06.09.24.
//

import UIKit
import HNReaderAPI
import Combine

class StoriesTableViewController: UITableViewController {
    private let storiesViewModel = StoriesViewModel()
    private var subscriptions = Set<AnyCancellable>()
    private var stories: [Story] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private var error: API.Error? {
        willSet {
            guard let error = newValue else { return }
            
            stories = []
            
            showErrorMessage(error: error)
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupBindings()
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        view.backgroundColor = UIColor(white: 1.0, alpha: 0.9)
    }
    
    private func setupBindings() {
        storiesViewModel
            .$allStories
            .assign(to: \.stories, on: self)
            .store(in: &subscriptions)
        
        storiesViewModel
            .$error
            .assign(to: \.error, on: self)
            .store(in: &subscriptions)
    }
    
    private func showErrorMessage(error: API.Error) {
        let alertVC = UIAlertController(
            title: "Error",
            message: error.errorDescription,
            preferredStyle: .alert
        )
        
        present(alertVC, animated: true)
    }
}

// MARK: - Table view data source

extension StoriesTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        let story = stories[indexPath.row]
        
        cell.textLabel?.text = story.title
        cell.textLabel?.textColor = UIColor.orange
        cell.detailTextLabel?.text = "By \(story.by)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

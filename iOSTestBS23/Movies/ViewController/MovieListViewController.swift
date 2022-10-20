//
//  MovieListViewController.swift
//  iOSTestBS23
//
//  Created by Md. Shahed Mamun on 20/10/22.
//

import UIKit
import UIScrollView_InfiniteScroll



final class MovieListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource = self
            tableView.separatorStyle = .singleLine
            tableView.estimatedRowHeight = 200
            tableView.rowHeight = UITableView.automaticDimension
        }
    }
    let searchController = UISearchController(searchResultsController: nil)
    
    
    private let viewModel = MovieListViewModel()
    private let refreshControl = UIRefreshControl()
    private var selectedIndexPath: IndexPath?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Movie List"
        navigationController?.navigationBar.prefersLargeTitles = true

        setupSearchBar()
        addRefreshControl()
        addInfiniteScroll()
        refreshData()
    }
    
    private func setupSearchBar(){
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.placeholder = "Search Movie..."
        searchController.searchBar.setPositionAdjustment(UIOffset(horizontal: 10.0, vertical: 0.0), for: .search)
        searchController.searchBar.searchTextPositionAdjustment = UIOffset(horizontal: 10.0, vertical: 0.0)
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    private func addRefreshControl(){
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
    }
    
    @objc private func refreshData(){
        viewModel.refreshPage()
        getMovies(searchText: getSearchText())
    }
    
    private func getSearchText() -> String{
        var text = searchController.searchBar.text ?? ""
        if text.isEmpty {
            text = "marvel"
        }
        return text
    }
    
    private func loadMore(){
        viewModel.increamentPage()
        getMovies(searchText: getSearchText())
    }
    
    private func addInfiniteScroll(){
        tableView.addInfiniteScroll(handler: { (tableView) -> Void in
            self.loadMore()
            tableView.finishInfiniteScroll()
        })
    }
    
    
    private func getMovies(searchText: String){
        let url = viewModel.getMovieUrl(searchText: searchText)
        
        viewModel.getMovies(url: url) { [weak self] (error) in
            if let error = error {
                print("data fetching error: ", error)
                DispatchQueue.main.async {
                    self?.showAlert(title: "Failed to fetch data", message: "\(error)", callback: nil)
                }
                return
            }
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                if (self?.refreshControl.isRefreshing ?? false){
                    self?.refreshControl.endRefreshing()
                }
                
                if self?.viewModel.getMovieCount() ?? 0 <= 0 {
                    self?.showAlert(title: "No data found", message: "Please enter a relevant name", callback: nil)
                }
            }
        }
    }
    
}



extension MovieListViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getMovieCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell") as! MovieTableViewCell
        
                cell.image = nil
        let representedIdentifier = viewModel.getUuid(row: indexPath.row)
        cell.representedIdentifier = representedIdentifier

        cell.titleLabel.text = viewModel.getTitle(row: indexPath.row)
        cell.detailsLabel.text = viewModel.getDetails(row: indexPath.row)
        cell.selectionStyle = .none
        
        viewModel.downloadImage(for: indexPath.row) { image in
            if cell.representedIdentifier == representedIdentifier{
                DispatchQueue.main.async {
                    cell.customImageView.image = image
                }
            }
        }
        
        return cell
    }
    
}




extension MovieListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else{
            return
        }
        
        viewModel.refreshPage()
        getMovies(searchText: searchText)
    }
    
}


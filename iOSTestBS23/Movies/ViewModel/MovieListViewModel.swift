//
//  MovieListViewModel.swift
//  iOSTestBS23
//
//  Created by Md. Shahed Mamun on 20/10/22.
//

import Foundation
import UIKit


final class MovieListViewModel{
    private var movies = [Movie]()
    //    var callback: ((_ id: Int) -> ())?
    private var page = 1
    private var limit = 20
    
    
    func refreshPage(){
        page = 1
    }
    
    func increamentPage(){
        page += 1
    }
    
    private func getBaseUrl() -> String{
        return "baseUrl"
    }
    
    
    func getMovieUrl(searchText: String) -> String{
        let text = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let unsplashPhotosUrl = "https://api.themoviedb.org/3/search/movie?api_key=\(Constants.apiKey)&query=\(text)&page=\(page)"
        
        return unsplashPhotosUrl
    }
    
    func getMovieCount() -> Int{
        return movies.count
    }
    
    func getMovieList() -> [Movie]{
        return movies
    }
    
    func getTitle(row: Int) -> String{
        return movies[row].title ?? ""
    }
    
    func getDetails(row: Int) -> String {
        return movies[row].overview ?? ""
    }
    
    func getUuid(row: Int) -> String{
        if movies[row].uuid.isEmpty{
            movies[row].uuid = UUID().uuidString
        }
        
        return movies[row].uuid
    }
    
    private func image(data: Data?) -> UIImage? {
        if let data = data {
            return UIImage(data: data)
        }
        
        return Constants.placeholderImage
    }
    
    
    func getMovies(url: String, completion: @escaping ((Error?) -> ()) ) {
        NetworkManager.shared.getData(url: url) { [weak self] (model: MovieListModel?, error) in
            
            let fetchedMovies = model?.results ?? [Movie]()
            
            if self?.page == 1{
                self?.movies = fetchedMovies
            }else{
                self?.movies += fetchedMovies
            }
            
            print("url = \(url)")
            print("movies.count = \(String(describing: self?.movies.count))")
            
            completion(error)
        }
    }
    
    func downloadImage(for index: Int, completion: @escaping ((UIImage?) -> ()) ){
        if let path = movies[index].poster_path, path.isEmpty == false{
            let imageUrl = "https://image.tmdb.org/t/p/w200\(path)"
            NetworkManager.shared.download(imageURL: imageUrl) { [weak self] data, error  in
                let img = self?.image(data: data)
                completion(img)
            }
        }else{
            completion(Constants.placeholderImage)
        }
    }
    
}

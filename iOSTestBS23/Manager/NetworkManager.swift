//
//  NetworkManager.swift
//  iOSTestBS23
//
//  Created by Md. Shahed Mamun on 20/10/22.
//

import Foundation



enum NetworkManagerError: Error {
    case badResponse(URLResponse?)
    case badData
    case badLocalUrl
}


final class NetworkManager {
    
    static let shared = NetworkManager()
    
    
    func getData<T: Codable>(url: String, completion: @escaping ((T?, Error?) -> ()) ) {
        
        guard let url = URL(string: url) else{
            completion(nil, NetworkManagerError.badLocalUrl)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(nil, NetworkManagerError.badResponse(response))
                return
            }
            
            guard let data = data else {
                completion(nil, NetworkManagerError.badData)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(T.self, from: data)
                completion(response, nil)
            } catch let error {
                completion(nil, error)
            }
        }
        
        task.resume()
    }
    
    
    func download(imageURL: String, completion: @escaping ((Data?, Error?) -> ()) ) {
        
        //        print("imageUrl = \(imageURL)")
        if let imageData = StoreManager.shared.retrive(imageURL: imageURL) {
            //            print("using cached image")
            completion(imageData, nil)
            return
        }
        
        guard let imageURL = URL(string: imageURL) else{
            completion(nil, NetworkManagerError.badLocalUrl)
            return
        }
        
        let task = URLSession.shared.downloadTask(with: imageURL) { localUrl, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(nil, NetworkManagerError.badResponse(response))
                return
            }
            
            guard let localUrl = localUrl else {
                completion(nil, NetworkManagerError.badLocalUrl)
                return
            }
            
            do {
                let data = try Data(contentsOf: localUrl)
                StoreManager.shared.store(data: data, imageURL: imageURL)
                completion(data, nil)
            } catch let error {
                completion(nil, error)
            }
        }
        
        task.resume()
    }
    
}

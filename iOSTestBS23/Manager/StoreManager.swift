//
//  StoreManager.swift
//  iOSTestBS23
//
//  Created by Md. Shahed Mamun on 20/10/22.
//

import Foundation


final class StoreManager{
    
    static let shared = StoreManager()
    
    private var cachedImages = NSCache<NSString, NSData>()
    
    
    func store(data: Data, imageURL: URL){
        cachedImages.setObject(data as NSData, forKey: imageURL.absoluteString as NSString)
    }
    
    
    func retrive(imageURL: String) -> Data?{
        let imageData = cachedImages.object(forKey: imageURL as NSString) as Data?
        
        return imageData
    }
    
}

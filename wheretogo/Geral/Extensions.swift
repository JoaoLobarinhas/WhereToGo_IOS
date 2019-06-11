//
//  Extensions.swift
//  wheretogo
//
//  Created by Aluno on 11/06/2019.
//  Copyright © 2019 estg.ipvc. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    
    func loadImageUsingCacheWithUrlString(urlString: String){
        
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        let url = URL(string: urlString)
        let urlRequest = URLRequest(url: url!)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            
            if error != nil {
                print(error ?? "erro")
                return
            }
            
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!){
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }

            }
            
        }
        
        task.resume()
    }
}

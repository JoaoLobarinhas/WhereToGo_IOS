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
        
        let url = URL(string: urlString)
        image = nil
        
        let cache = URLCache.shared
        let request = URLRequest(url: url!)
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data : data){
                DispatchQueue.main.async {
                    self.image = image
                }
            }else{
                URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
                    
                    if let data = data, let response = response, (( response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data){
                        let cachedData = CachedURLResponse(response: response, data: data)
                        cache.storeCachedResponse(cachedData, for: request)
                        DispatchQueue.main.async {
                            self.image = image
                        }
                    }
                    
                }).resume()
            }
        }
    }
}

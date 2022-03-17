//
//  SearchViewModel.swift
//  MVVMTaskTest
//
//  Created by Nihad Ismayilov on 17.03.22.
//

import Foundation

struct SearchViewModel {
    
    let movieUrl = "http://www.omdbapi.com/?i=tt3896198&apikey=8bd48c99&s="
    
    func performMoviesRequest(_ searchMovieName: String, completion: @escaping (Result?) -> ()) {
        
        let query = searchMovieName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let urlString = movieUrl + (query ?? "")
        
        if let url = URL(string: urlString) {
            let session = URLSession.shared
            
            print(url)
            
            let task = session.dataTask(with: url) { data, response, error in
                
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if data != nil {
                        
                        do {
                            let decodeData = try JSONDecoder().decode(Result.self, from: data!)
                            print(decodeData)
                            
                            completion(decodeData)
                            
                        } catch {
                            print(error.localizedDescription)
                        }
                        
                    }
                }
                
            }
            task.resume()
        }
        
    }
    
}

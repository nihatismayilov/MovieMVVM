//
//  DetailsViewModel.swift
//  MVVMTaskTest
//
//  Created by Nihad Ismayilov on 17.03.22.
//

import Foundation

struct DetailsViewModel {
    
    var details: [DetailsData]?
    
    
        
    func performDetailRequest(_ searchDetailId: String, completion: @escaping (DetailsData) -> ()) {
        
        let DetailsUrl = "http://www.omdbapi.com/?i=\(searchDetailId)&apikey=8bd48c99&t"
        
        //let detailsQuery = s.addingPercentEncoding(withAllowedCharacters:
                //.urlHostAllowed)
    
        //let urlStringdetails = DetailsUrl + (detailsQuery ?? "")
        
        if let urlDetails = URL(string: DetailsUrl) {
            let sessionDetails = URLSession.shared
            
            let taskDetails = sessionDetails.dataTask(with: urlDetails) { data, response, error in
                if error != nil {
                    print(error?.localizedDescription ?? "Error")
                } else {
                    if data != nil {
                        do {
                            let decodeDetails = try JSONDecoder().decode(DetailsData.self, from: data!)
                            completion(decodeDetails)
                            
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            taskDetails.resume()
        }
    }
}

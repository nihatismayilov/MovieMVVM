//
//  MovieData.swift
//  MVVMTaskTest
//
//  Created by Nihad Ismayilov on 17.03.22.
//

import Foundation

struct Result: Codable {
    let Search: [MovieData]?
}

struct MovieData: Codable {
    let Title: String?
    let Poster: String?
    let imdbID: String?
}

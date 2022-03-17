//
//  Helper.swift
//  MVVMTaskTest
//
//  Created by Nihad Ismayilov on 17.03.22.
//

import Foundation

struct Helper {
    static var sharedInstance = Helper()
    
    var movieIdArray: [String]? = []
    var movieTitleArray: [String]? = []
    var moviePosterArray: [String]? = []
    
    private init() {}
}

//
//  File.swift
//  
//
//  Created by Conovo Mac075 on 20/07/2023.
//

import Foundation
import Vapor
import Fluent

struct ApiResponse<T> : Content where T: Content {
    var message: String?
    var data: T?
    
    init(message: String, data: T?) {
        self.message = message
        self.data = data
    }
}

final class EmptyObject: Content {}

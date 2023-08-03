//
//  ApiResponse.swift
//  
//
//  Created by Conovo Mac075 on 19/07/2023.
//

import Foundation
import Vapor
import Fluent

final class Movie: Model, Content {
    // Name of the table or collection.
    static let schema = "movies"

    // Unique identifier for this movie.
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String
    
    @Field(key: "year")
    var year: String

    // Creates a new, empty object.
    init() { }

    // Creates a new object with all properties set.
    init(id: UUID? = nil, title: String, year: String) {
        self.id = id
        self.title = title
        self.year = year
    }
}

struct MovieQuery : Content {
    let sort: String?
    let title: String?
    let id: String?
}

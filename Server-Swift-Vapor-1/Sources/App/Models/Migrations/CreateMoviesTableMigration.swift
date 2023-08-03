//
//  File.swift
//  
//
//  Created by Conovo Mac075 on 20/07/2023.
//

import Foundation
import Fluent

struct CreateMoviesTableMigration: AsyncMigration {
    
    func prepare(on database: FluentKit.Database) async throws {
        try await database.schema("movies")
            .id()
            .field("title", .string, .required)
            .field("year", .string, .required)
            .create()
    }
    
    func revert(on database: FluentKit.Database) async throws {
        try await database.schema("movies").delete()
    }
    
}

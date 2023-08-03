//
//  File.swift
//  
//
//  Created by Conovo Mac075 on 19/07/2023.
//

import Foundation
import Vapor
import Fluent

struct MoviesCoptroller: RouteCollection {
//    let movies = [Movie(title: "Batman", year: "2020"), Movie(title: "Superman", year: "2020"), Movie(title: "Superman Returns", year: "2021"), Movie(title: "Spiderman", year: "2020")]
    
    func boot (routes: RoutesBuilder) throws {
        let movies = routes.grouped ("movies")
        movies.get(use: index)
        movies.post(use: saveMovie)
        movies.delete(use: deleteMovie)
    }
    
    // GET MOVIES | SEARCH MOVIES
    func index(req: Request) async throws -> ApiResponse<[Movie]> {
        
        let query : MovieQuery = try req.query.decode(MovieQuery.self)
        
        var filteredMovies: [Movie] = []
        
        if let title = query.title {
            filteredMovies = try await Movie.query(on: req.db)
                .filter(\.$title =~ title)
                .all()
        }else{
            if let id = query.id {
                if let movieID = UUID(uuidString: id), let movie = try? await Movie.query(on: req.db)
                    .filter(\.$id == movieID)
                    .first() {
                    
                    filteredMovies = [movie]
                } else {
                    return ApiResponse(message: filteredMovies.count > 0 ? "Success" : "No record found", data: filteredMovies)
                }
            }else{
                filteredMovies = try await Movie.query(on: req.db).all()
            }
        }
        
        if query.sort == "desc" {
            filteredMovies = filteredMovies.sorted(by: {Int($0.year)! > Int($1.year)!})
        }else{
            filteredMovies = filteredMovies.sorted(by: {Int($0.year)! < Int($1.year)!})
        }
        
        return ApiResponse(message: filteredMovies.count > 0 ? "Success" : "No record found", data: filteredMovies)
    }
    
    // SAVE MOVIE
    func saveMovie(req: Request) async throws -> ApiResponse<Movie> {
        do {
            let movie = try req.content.decode(Movie.self)
            try await movie.save(on: req.db)
            return ApiResponse(message: "", data: movie)
        } catch (let error) {
            print(error)
            return ApiResponse(message: error.localizedDescription, data: nil)
        }
    }
    
    func saveMoviee(req: Request) async throws -> EventLoopFuture<Response> {
        do {
            
            let response = Response(status: HTTPResponseStatus(statusCode: 200))
            let movie = try req.content.decode(Movie.self)
            try await movie.save(on: req.db)

            try response.content.encode(movie)
            return req.eventLoop.future(response)
//            return ApiResponse(message: "", data: movie)
        } catch (let error) {
            print(error)
            return req.eventLoop.future(error: error)
//            return ApiResponse(message: error.localizedDescription, data: nil)
        }
    }
    
    // DELETE MOVIE
    func deleteMovie(req: Request) async throws -> ApiResponse<EmptyObject> {
        let query : MovieQuery = try req.query.decode(MovieQuery.self)
        if let id = query.id, let movieID = UUID(uuidString: id), let movie = try await Movie.query(on: req.db).filter(\.$id == movieID).first() {
            try await movie.delete(on: req.db)
            return ApiResponse(message: "Success", data: EmptyObject())
        }else{
            return ApiResponse(message: "Invalid Id", data: EmptyObject())
        }
    }
    
}

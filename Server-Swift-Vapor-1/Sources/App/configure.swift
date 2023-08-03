import Vapor
import Fluent
import FluentPostgresDriver

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    //  configure database
    app.databases.use(
        try .postgres(url: "postgres://ichxthdn:GrOYtSBGp-z5JbWYBxq9HjAjXP1sdOuS@stampy.db.elephantsql.com/ichxthdn"
                     ), as: .psql)
    
    //  register migrations
    app.migrations.add(CreateMoviesTableMigration())
    
    // register routes
    try routes(app)
}

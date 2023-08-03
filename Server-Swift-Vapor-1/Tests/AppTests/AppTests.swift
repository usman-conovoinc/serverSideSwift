@testable import App
import XCTVapor

final class AppTests: XCTestCase {
    func testHelloWorld() async throws {
        
        print("turns: \(pagesTurnCount(pages: 100, page: 97))")
        let app = Application(.testing)
        defer { app.shutdown() }
        try await configure(app)

        try app.test(.GET, "hello", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string, "Hello, world!")
        })
    }
    
    
    func pagesTurnCount(pages : Int, page: Int) -> Int {
        return min(page/2, (pages/2) - (page/2))
    }
}

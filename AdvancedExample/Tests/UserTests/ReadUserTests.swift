import Foundation
import XCTest
import NIOCore
import NIOPosix
import Logging
@testable import AWSLambdaRuntimeCore
@testable import Shared
@testable import User

final class ReadUserTests: XCTestCase {
    
    func testReadUser() async throws {
        let context = Context()
        // We use a MockDataStore so that we can customize the result
        let dataStore = MockDatastore<User>()
        dataStore.readMock = { (id: String) throws -> User in
            // Don't throw, return a user
            return User(id: id, name: UUID().uuidString, email: UUID().uuidString)
        }
        UserEnvironment.shared.dataStore = dataStore
        let endpoint = try await ReadUserEndpoint(context: context.initContext)
        let request: ReadUserRequest = .init(id: UUID().uuidString)
        
        let user = try await endpoint.handle(event: request, context: context.lambdaContext)
        
        XCTAssertEqual(user.id, request.id)
    }
    func testReadUserHandlesFailures() async throws {
        let context = Context()
        // We use a MockDataStore so that we can customize the result
        let dataStore = MockDatastore<User>()
        UserEnvironment.shared.dataStore = dataStore
        // The default action for read() is to throw
        let endpoint = try await ReadUserEndpoint(context: context.initContext)
        let request: ReadUserRequest = .init(id: UUID().uuidString)

        do {
            _ = try await endpoint.handle(event: request, context: context.lambdaContext)
            XCTFail("An error should have been thrown.")
        } catch {
            
        }
    }
    
    static var allTests = [
        ("testReadUser", testReadUser),
        ("testReadUserHandlesFailures", testReadUserHandlesFailures),
    ]
}

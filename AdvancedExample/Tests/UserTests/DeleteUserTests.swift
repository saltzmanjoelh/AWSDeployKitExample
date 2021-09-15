import Foundation
import XCTest
@testable import Shared
@testable import User

final class DeleteUserTests: XCTestCase {
    
    func testDeleteUser() async throws {
        let context = Context()
        // We use a MockDataStore so that we can customize the result
        let dataStore = MockDatastore<User>()
        dataStore.deleteMock = { (id: String) throws in
            // Don't throw, just return
        }
        UserEnvironment.shared.dataStore = dataStore
        let endpoint = try await DeleteUserEndpoint(context: context.initContext)
        let request: DeleteUserRequest = .init(id: UUID().uuidString)
        
        try await endpoint.handle(event: request, context: context.lambdaContext)
    }
    func testDeleteUserHandlesFailures() async throws {
        let context = Context()
        // We use a MockDataStore so that we can customize the result
        let dataStore = MockDatastore<User>()
        UserEnvironment.shared.dataStore = dataStore
        // The default action for delete() is to throw
        let endpoint = try await DeleteUserEndpoint(context: context.initContext)
        let request: DeleteUserRequest = .init(id: UUID().uuidString)

        do {
            try await endpoint.handle(event: request, context: context.lambdaContext)
            XCTFail("An error should have been thrown.")
        } catch {
            
        }
    }
    
    static var allTests = [
        ("testDeleteUser", testDeleteUser),
        ("testDeleteUserHandlesFailures", testDeleteUserHandlesFailures),
    ]
}

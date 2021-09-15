//
//  Context.swift
//  Tests
//
//  Created by Joel Saltzman on 9/8/21.
//

import Foundation
import NIOCore
import NIOPosix
import Logging
@testable import AWSLambdaRuntimeCore

class Context {
    var eventLoopGroup: EventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
    lazy var lambdaContext = newContext()
    lazy var initContext = newInitContext()
    
    deinit {
        syncShutDown()
    }
    
    func newContext(label: String = #function) -> Lambda.Context {
        Lambda.Context(requestID: UUID().uuidString,
                       traceID: "abc123",
                       invokedFunctionARN: "aws:arn:",
                       deadline: .now() + .seconds(3),
                       cognitoIdentity: nil,
                       clientContext: nil,
                       logger: Logger(label: "test"),
                       eventLoop: self.eventLoopGroup.next(),
                       allocator: ByteBufferAllocator())
    }
    func newInitContext(label: String = #function) -> Lambda.InitializationContext {
        Lambda.InitializationContext(logger: Logger(label: label),
                                     eventLoop: self.eventLoopGroup.next(),
                                     allocator: ByteBufferAllocator())
    }
    func syncShutDown() {
        try! eventLoopGroup.syncShutdownGracefully()
    }
}

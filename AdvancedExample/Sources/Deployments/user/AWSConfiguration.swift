//
//  AWSConfiguration.swift
//  
//
//  Created by Joel Saltzman on 7/23/21.
//

import Foundation
import NIO
import SotoDynamoDB
import SotoIAM
import SotoSTS
import Shared
import User

enum DeploymentError: Error {
    case undefinedRole
    case accountIdUnavailable
}


class AWSConfiguration {
    
    var logger: Logger
    
    public init() {
        self.logger = Logger.init(label: "DeployUserEndpoints")
        self.logger.logLevel = .trace
    }
    /// Makes sure that the Dynamo table exists before we start deploying
    /// Basic implementation to simplify example. Could be more dynamic.
    public func verifyDynamoTable() throws {
        // Check if the table exists
        logger.trace("Verifying dynamo table")
        let listTables = try AWSServices.shared.dynamoDB.listTables(.init()).wait()
        guard listTables.tableNames?.contains(User.table) == false else {
            print("Table exists")
            return
        }
        // If not, create it
        let input = DynamoDB.CreateTableInput(attributeDefinitions: [.init(attributeName: "id", attributeType: .s)],
                                              keySchema: [.init(attributeName: "id", keyType: .hash)],
                                              provisionedThroughput: .init(readCapacityUnits: 5, writeCapacityUnits: 5),
                                              tableName: User.table)
        try AWSServices.shared.dynamoDB.createTable(input)
            .flatMap { _ -> EventLoopFuture<Void> in
                AWSServices.shared.dynamoDB.waitUntilTableExists(.init(tableName: User.table))
            }
            .wait()
    }
    
    /// Makes sure that the Lambda has access to the Dynamo table
    public func verifyRoleAccess(for functionName: String) throws {
        logger.trace("Verifying role access")
        let roleArn = try getFunctionRole(functionName)
        // read-user-role-4264F3AB
        let roleName = roleArn.components(separatedBy: "/")[1]
        
        guard try roleHasDynamoAccess(roleName) == false else {
            logger.trace("Role has access")
            return
        }
        logger.trace("Role needs access")
        // Attach the policy
        try attachDynamoPolicy(for: functionName, to: roleName)
    }
    /// Get the role used for execution in the Lambda
    func getFunctionRole(_ functionName: String) throws -> String {
        logger.trace("Getting function role")
        // aws lambda get-function --function-name arn:aws:lambda:us-west-1:123456789012:function:read-user
        let output = try AWSServices.shared.lambda.getFunction(.init(functionName: functionName)).wait()
        // arn:aws:iam::123456789012:role/read-user-role-4264F3AB
        guard let roleArn = output.configuration?.role else { throw DeploymentError.undefinedRole }
        return roleArn
    }
    /// Check if the polices contain our Dynamo policy
    func roleHasDynamoAccess(_ roleName: String) throws -> Bool {
        logger.trace("Listing role policies")
        // aws iam list-attached-role-policies --role-name read-user-role-4264F3AB
        let policies = try AWSServices.shared.iam.listAttachedRolePolicies(.init(roleName: roleName)).wait()
        return "\(policies)".contains(dynamoPolicyName)
    }
    /// Attach the policy to the role
    func attachDynamoPolicy(for functionName: String, to roleName: String) throws {
        let policy = try getDynamoPolicy(for: functionName)
        logger.trace("Attaching role policy")
        try AWSServices.shared.iam.attachRolePolicy(.init(policyArn: policy.arn!, roleName: roleName)).wait()
    }
    // Checks if it exists. If it doesn't creates it.
    func getDynamoPolicy(for functionName: String) throws -> IAM.Policy {
        let accountId = try getAccountId()
        logger.trace("Getting policy")
        do {
            let policyOutput = try AWSServices.shared.iam.getPolicy(.init(policyArn: "arn:aws:iam::\(accountId):policy/\(dynamoPolicyName)")).wait()
            return policyOutput.policy!
        } catch {
            return try createDynamoPolicy(for: functionName)
        }
        
    }
    func getAccountId() throws -> String {
        logger.trace("Getting account id")
        return try AWSServices.shared.sts.getCallerIdentity(.init())
            .flatMapThrowing { (response: STS.GetCallerIdentityResponse) -> String in
                guard let accountId = response.account else {
                    throw DeploymentError.accountIdUnavailable
                }
                return accountId
            }.wait()
    }
    func createDynamoPolicy(for functionName: String) throws -> IAM.Policy {
        let result = try AWSServices.shared.iam.createPolicy(.init(policyDocument: dynamoPolicyJSON(functionName: functionName), policyName: dynamoPolicyName)).wait()
        return result.policy!
    }
    var dynamoPolicyName: String { "ReadWriteDynamoDBUsers" }
    func dynamoPolicyJSON(functionName: String) -> String {
        let policy = """
            {
                "Version": "2012-10-17",
                "Statement": [
                    {
                        "Sid": "VisualEditor0",
                        "Effect": "Allow",
                        "Action": [
                            "dynamodb:DeleteItem",
                            "dynamodb:DescribeTable",
                            "dynamodb:GetItem",
                            "dynamodb:BatchGetItem",
                            "dynamodb:BatchWriteItem",
                            "dynamodb:PutItem",
                            "dynamodb:Scan",
                            "dynamodb:Query",
                            "dynamodb:UpdateItem",
                            "dynamodb:GetRecords"
                        ],
                        "Resource": "arn:aws:dynamodb:*:796145072238:table/%%FUNCTION_NAME%%"
                    }
                ]
            }
            """
            .replacingOccurrences(of: "%%FUNCTION_NAME%%", with: functionName)
        return policy
    }
}

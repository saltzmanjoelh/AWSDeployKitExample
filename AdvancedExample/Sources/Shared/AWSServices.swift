//
//  AWSServices.swift
//  
//
//  Created by Joel Saltzman on 7/22/21.
//

import Foundation
import SotoDynamoDB
import SotoIAM
import SotoLambda
import SotoSTS

public class AWSServices {
    
    public static var shared = AWSServices()
    
    public var client: AWSClient
    public var dynamoDB: DynamoDB
    public var iam: IAM
    public var lambda: Lambda
    public var sts: STS
    
    public init(region: Region = .uswest1) {
        let client = AWSClient(credentialProvider: .default, httpClientProvider: .createNew)
        self.client = client
        self.dynamoDB = DynamoDB(client: client, region: .uswest1)
        self.iam = IAM(client: client)
        self.lambda = Lambda(client: client, region: region)
        self.sts = STS(client: client, region: region)
    }
    deinit {
        try! client.syncShutdown()
    }
}

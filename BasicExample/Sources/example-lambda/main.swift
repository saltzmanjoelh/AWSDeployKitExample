import AWSLambdaRuntime
import NIOCore
 
 struct Request: Codable {
    let name: String
 }
 struct Response: Codable {
    let message: String
 }

struct ExampleHandler: EventLoopLambdaHandler {
    typealias In = Request
    typealias Out = Response
    
    func handle(event: Request, context: Lambda.Context) -> EventLoopFuture<Response> {
        context.eventLoop.makeSucceededFuture(Response(message: "Hello, \(event.name)"))
    }
}
 
Lambda.run { $0.eventLoop.makeSucceededFuture(ExampleHandler()) }

 /*
  Once published, you should be able to invoke using aws-deploy-kit or aws cli
  aws lambda invoke --function-name example-lambda \
    --cli-binary-format raw-in-base64-out \
    --payload '{ "name": "Bob" }' \
    output.txt \
  && cat output.txt
  */

 import AWSLambdaRuntime
 
 private struct Request: Codable {
    let name: String
 }
 private struct Response: Codable {
    let message: String
 }
 
 Lambda.run { (context, request: Request, callback: @escaping (Result<Response, Error>) -> Void) in
    callback(.success(Response(message: "Hello, \(request.name)")))
 }

 /*
  aws lambda invoke --function-name example-lambda \
    --cli-binary-format raw-in-base64-out \
    --payload '{ "name": "Bob" }' \
    output.txt \
  && cat output.txt
  */

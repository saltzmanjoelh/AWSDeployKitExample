import Foundation
import AWSDeployCore

AWSDeployCommand.main() // This will parse your "Arguments Passed On Launch" in the Edit Scheme window

/*
 * Switch your selected target in Xcode to `Deploy`.
 * Press `cmd` + `shift` + `<` to edit the scheme.
 * Add the `build-and-publish` command in the "Arguments Passed On Launch" section
 * Add the path to this project in the "Arguments Passed On Launch" section `-d /path/this/project/`.
 * Make sure that Docker is running
 * Run the `Deploy` target. It will build and publish to AWS Lambda
 */

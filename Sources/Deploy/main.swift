import Foundation
import AWSDeployCore

AppDeployer.main()

/*
 * Switch your selected target in Xcode to `Deploy`.
 * Press `cmd` + `shift` + `<` to edit the scheme.
 * Add the path to this project in the "Arguments Passed On Launch" section `-d /path/this/project/`.
 * Make sure to skip the building and deploying the Deploy executable `-s Deploy`.
 * This is enough to build in Docker. You can optionally pass the `-p` to publish to your Lambda.
 */

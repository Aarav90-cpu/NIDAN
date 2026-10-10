import Foundation
import Vapor

@main
struct NidanContentServer {
    static func main() async throws {
        var environment = try Vapor.Environment.detect()
        try LoggingSystem.bootstrap(from: &environment)
        let application = try await Application.make(environment)

        let sourceFile = URL(fileURLWithPath: #filePath)
        let projectRoot = sourceFile
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
        let defaultContentDirectory = projectRoot.appendingPathComponent("Content/public").path
        let contentDirectory = URL(fileURLWithPath: ProcessInfo.processInfo.environment["NIDAN_CONTENT_DIRECTORY"] ?? defaultContentDirectory)
            .standardizedFileURL.path
        application.http.server.configuration.hostname = ProcessInfo.processInfo.environment["NIDAN_CONTENT_BIND_HOST"] ?? "127.0.0.1"
        let port = Int(ProcessInfo.processInfo.environment["NIDAN_CONTENT_PORT"] ?? "8081") ?? 8081
        application.http.server.configuration.port = port
        application.middleware.use(FileMiddleware(publicDirectory: contentDirectory))
        application.get("health") { _ async -> [String: String] in
            ["service": "nidan-content", "status": "ready"]
        }
        application.get(.catchall) { _ async throws -> HTTPStatus in
            throw Abort(.notFound)
        }

        print("NIDAN content service listening on port \(port)")
        print("Content directory: \(contentDirectory)")
        try await application.execute()
        try await application.asyncShutdown()
    }
}

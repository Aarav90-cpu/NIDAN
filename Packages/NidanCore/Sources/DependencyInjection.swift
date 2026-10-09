import Foundation

/// A container for injecting dependencies globally per-task or per-instance.
/// This strictly enforces Sendable for safe concurrent access across actor boundaries.
public struct Environment: Sendable {
    public var logger: LoggerProvider
    // Default clock for production; tests can override this with a test clock
    public var clock: any Clock<Duration>
    
    public var storage: StorageProvider?
    
    public init(logger: LoggerProvider = PrintLogger(), clock: any Clock<Duration> = ContinuousClock(), storage: StorageProvider? = nil) {
        self.logger = logger
        self.clock = clock
        self.storage = storage
    }
}

/// Global task-local environment to allow injection and overriding during tests.
public enum CurrentEnvironment {
    @TaskLocal public static var current = Environment()
}

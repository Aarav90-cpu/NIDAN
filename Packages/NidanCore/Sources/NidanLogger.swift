import Foundation

public enum LogLevel: String, Sendable {
    case debug = "DEBUG"
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
    case critical = "CRITICAL"
}

public protocol LoggerProvider: Sendable {
    func log(_ message: String, level: LogLevel, file: String, function: String, line: Int)
}

public extension LoggerProvider {
    func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .debug, file: file, function: function, line: line)
    }
    
    func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .info, file: file, function: function, line: line)
    }
    
    func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .warning, file: file, function: function, line: line)
    }
    
    func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .error, file: file, function: function, line: line)
    }
}

/// A default logger for development until we implement a real one.
public struct PrintLogger: LoggerProvider {
    public init() {}
    public func log(_ message: String, level: LogLevel, file: String, function: String, line: Int) {
        let filename = (file as NSString).lastPathComponent
        print("[\(level.rawValue)] [\(filename):\(line) \(function)] \(message)")
    }
}

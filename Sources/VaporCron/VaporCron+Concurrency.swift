#if compiler(>=5.5) && canImport(_Concurrency)
import Vapor

// MARK: VaporCronSchedulable
@available(macOS 12, iOS 15, watchOS 8, tvOS 15, *)
public protocol AsyncVaporCronSchedulable: VaporCronSchedulable {
    static func task(on application: Application) async throws -> T
    static func error(_ error: Error, on application: Application)
}

@available(macOS 12, iOS 15, watchOS 8, tvOS 15, *)
extension AsyncVaporCronSchedulable {
    public static func task(on application: Application) -> EventLoopFuture<T> {
        let promise = application.eventLoopGroup.next().makePromise(of: T.self)
        promise.completeWithTask {
            try await task(on: application)
        }
        
        let result = promise.futureResult
        result.whenFailure { error in
            self.error(error, on: application)
        }
        return result
    }
    public static func error(_ error: Error, on application: Application) {
        application.logger.error("[\(Self.self)] \(error)")
    }
}

// MARK: VaporCronInstanceSchedulable
@available(macOS 12, iOS 15, watchOS 8, tvOS 15, *)
public protocol AsyncVaporCronInstanceSchedulable: VaporCronInstanceSchedulable {
    func task() async throws -> T
    func error(_ error: Error)
}

@available(macOS 12, iOS 15, watchOS 8, tvOS 15, *)
extension AsyncVaporCronInstanceSchedulable {
    public func task() -> EventLoopFuture<T> {
        let promise = application.eventLoopGroup.next().makePromise(of: T.self)
        promise.completeWithTask {
            try await task()
        }
        let result = promise.futureResult
        result.whenFailure(self.error(_:))
        return result
    }
    public func error(_ error: Error) {
        application.logger.error("[\(Self.self)] \(error)")
    }
}
#endif


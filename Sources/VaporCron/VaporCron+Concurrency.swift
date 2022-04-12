#if compiler(>=5.5) && canImport(_Concurrency)
import Vapor

// MARK: VaporCronSchedulable
@available(macOS 12, iOS 15, watchOS 8, tvOS 15, *)
public protocol AsyncVaporCronSchedulable: VaporCronSchedulable {
    static func task(on application: Application) async throws -> T
}

@available(macOS 12, iOS 15, watchOS 8, tvOS 15, *)
extension AsyncVaporCronSchedulable {
    
    public static func task(on application: Application) -> EventLoopFuture<T> {
        let promise = application.eventLoopGroup.next().makePromise(of: T.self)
        promise.completeWithTask {
            try await task(on: application)
        }
        return promise.futureResult
    }
    
}

// MARK: VaporCronInstanceSchedulable
@available(macOS 12, iOS 15, watchOS 8, tvOS 15, *)
public protocol AsyncVaporCronInstanceSchedulable: VaporCronInstanceSchedulable {
    func task() async throws -> T
}

@available(macOS 12, iOS 15, watchOS 8, tvOS 15, *)
extension AsyncVaporCronInstanceSchedulable {
    
    public func task() -> EventLoopFuture<T> {
        let promise = application.eventLoopGroup.next().makePromise(of: T.self)
        promise.completeWithTask {
            try await task()
        }
        return promise.futureResult
    }
    
}
#endif


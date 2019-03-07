import Foundation
import Vapor
import NIOCronScheduler

public struct VaporCron {
    @discardableResult
    public static func schedule<T: NIOCronFutureSchedulable>(_ job: T.Type, on eventLoop: EventLoop) throws -> NIOCronJob {
        return try schedule(job.expression, on: eventLoop) { job.task(on: eventLoop) }
    }
    
    @discardableResult
    public static func schedule(_ job: NIOCronSchedulable.Type, on eventLoop: EventLoop) throws -> NIOCronJob {
        return try schedule(job.expression, on: eventLoop) { job.task() }
    }
    
    @discardableResult
    public static func schedule(_ expression: String, on eventLoop: EventLoop, _ task: @escaping () throws -> Void) throws -> NIOCronJob {
        return try NIOCronScheduler.schedule(expression, on: eventLoop, task)
    }
    
    @discardableResult
    public static func schedule<J: VaporCronSchedulable>(_ job: J.Type, on container: VaporCronContainer) throws -> NIOCronJob {
        return try schedule(job.expression, on: container.eventLoop) { job.task(on: container) }
    }
}

public typealias VaporCronContainer = NIOCronEventLoopable & Vapor.Container

public protocol VaporCronSchedulable: NIOCronExpressable {
    associatedtype Result
    
    @discardableResult
    static func task(on container: VaporCronContainer) -> EventLoopFuture<Result>
}

extension Application: NIOCronEventLoopable {}
extension Request: NIOCronEventLoopable {}

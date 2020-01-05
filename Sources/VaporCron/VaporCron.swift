import Foundation
import Vapor
import NIOCronScheduler

public struct VaporCron {
    let application: Application
    
    init (application: Application) {
        self.application = application
    }
    
    @discardableResult
    public func schedule<T: VaporCronSchedulable>(_ job: T.Type) throws -> NIOCronJob {
        return try schedule(job.expression) { job.task(on: self.application) }
    }
    
    @discardableResult
    public func schedule(_ job: NIOCronSchedulable.Type) throws -> NIOCronJob {
        return try schedule(job.expression) { job.task() }
    }
    
    @discardableResult
    public func schedule(_ expression: String, _ task: @escaping () throws -> Void) throws -> NIOCronJob {
        return try NIOCronScheduler.schedule(expression, on: application.eventLoopGroup.next(), task)
    }
    
    @discardableResult
    public func schedule(_ expression: String, _ task: @escaping (Application) throws -> Void) throws -> NIOCronJob {
        return try NIOCronScheduler.schedule(expression, on: application.eventLoopGroup.next(), { try task(self.application) })
    }
}

extension Application {
    public var cron: VaporCron {
        .init(application: self)
    }
}

extension Request {
    public var cron: VaporCron {
        .init(application: application)
    }
}

public protocol VaporCronSchedulable: NIOCronExpressable {
    associatedtype T
    
    @discardableResult
    static func task(on application: Application) -> EventLoopFuture<T>
}

[![Mihael Isaev](https://user-images.githubusercontent.com/1272610/53996790-3f346480-4153-11e9-9ca8-216680b4ab19.png)](http://mihaelisaev.com)

<p align="center">
    <a href="LICENSE">
        <img src="https://img.shields.io/badge/license-MIT-brightgreen.svg" alt="MIT License">
    </a>
    <a href="https://swift.org">
        <img src="https://img.shields.io/badge/swift-4.2-brightgreen.svg" alt="Swift 4.2">
    </a>
</p>

<br>

#### Support this lib by giving a ⭐️

## How to install

### Swift Package Manager

```swift
.package(url: "https://github.com/MihaelIsaev/VaporCron.git", from:"1.0.0")
```
In your target's dependencies add `"VaporCron"` e.g. like this:
```swift
.target(name: "App", dependencies: ["VaporCron"]),
```

## Usage

### Simple job with closure
```swift
import VaporCron

let job = try? VaporCron.schedule("* * * * *", on: eventLoop) {
    print("Closure fired")
}
```

### Complex job in dedicated struct
```swift
import VaporCron

/// Your job should conform to `VaporCronSchedulable`
struct ComplexJob: VaporCronSchedulable {
    static var expression: String { return "*/2 * * * *" }

    static func task(on container: VaporCronContainer) -> Future<Void> { // Void is not a requirement, you may return any type
        return eventLoop.newSucceededFuture(result: ()).always {
            print("ComplexJob fired")
        }
    }
}
let complexJob = try? VaporCron.schedule(ComplexJob.self, on: app)
```

Scheduled job may be cancelled just by calling `.cancel()`

## Where to define

#### On boot
You could define all cron jobs in your `boot.swift` cause here is `app: Application` which contains `eventLoop`
```swift
import Vapor
import VaporCron

/// Called after your application has initialized.
public func boot(_ app: Application) throws {
    let complexJob = try? VaporCron.schedule(ComplexJob.self, on: app)
    /// This example code will cancel scheduled job after 185 seconds
    /// so in a console you'll see "Closure fired" three times only
    app.eventLoop.scheduleTask(in: .seconds(185)) {
        complexJob?.cancel()
    }
}
```

#### In request handler
Some jobs you may want to schedule from some request handler like this
```swift
import Vapor
import VaporCron

func myEndpoint(_ req: Request) throws -> Future<HTTPStatus> {
    try VaporCron.schedule(ComplexJob.self, on: req)
    return .ok
}
```

### How to do something in the database every 5 minutes?

```swift
import Vapor
import VaporCron

struct Every5MinJob: VaporCronSchedulable {
    static var expression: String { return "*/5 * * * *" } // every 5 minutes
    
    static func task(on container: VaporCronContainer) -> Future<Void> {
        // this is how you could get a connection to the database
        return container.requestPooledConnection(to: .psql).flatMap { conn in
            // here you sould do whatever you want cause you already have a connection to database
            // it's just an example below
            return User.query(on: conn).all().flatMap { users in
                return users.map { user in
                    user.updatedAt = Date()
                    return user.save(on: conn).transform(to: Void.self)
                }.flatten(on: container)
            }
        }.always {
            // this is how to close taken pooled connection
            try? container.releasePooledConnection(conn, to: .psql)
        }
    }
}
```

## Dependencies

- [NIOCronScheduler](https://github.com/MihaelIsaev/NIOCronScheduler)
- [SwifCron](https://github.com/MihaelIsaev/SwifCron)

## Contributing

Please feel free to contribute!

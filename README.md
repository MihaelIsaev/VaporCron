[![Mihael Isaev](https://user-images.githubusercontent.com/1272610/53996790-3f346480-4153-11e9-9ca8-216680b4ab19.png)](http://mihaelisaev.com)

<p align="center">
    <a href="LICENSE">
        <img src="https://img.shields.io/badge/license-MIT-brightgreen.svg" alt="MIT License">
    </a>
    <a href="https://swift.org">
        <img src="https://img.shields.io/badge/swift-5.1-brightgreen.svg" alt="Swift 5.1">
    </a>
</p>

<br>

#### Support this lib by giving a ⭐️

Built for Vapor4

> 💡Vapor3 version is available in `vapor3` branch and from `1.0.0` tag

## How to install

### Swift Package Manager

```swift
.package(url: "https://github.com/MihaelIsaev/VaporCron.git", from:"2.0.0")
```
In your target's dependencies add `"VaporCron"` e.g. like this:
```swift
.target(name: "App", dependencies: ["VaporCron"]),
```

## Usage

### Simple job with closure
```swift
import VaporCron

let job = try app.cron.schedule("* * * * *") {
    print("Closure fired")
}
```

### Complex job in dedicated struct
```swift
import Vapor
import VaporCron

/// Your job should conform to `VaporCronSchedulable`
struct ComplexJob: VaporCronSchedulable {
    static var expression: String { "* * * * *" }

    static func task(on application: Application) -> EventLoopFuture<Void> {
        return application.eventLoopGroup.future().always { _ in
            print("ComplexJob fired")
        }
    }
}
let complexJob = try app.cron.schedule(ComplexJob.self)
```

> 💡you also could call `req.cron.schedule(...)``

> 💡💡Scheduled job may be cancelled just by calling `.cancel()`

## Where to define

#### On boot
You could define all cron jobs in your `boot.swift` cause here is `app: Application` which contains `eventLoop`
```swift
import Vapor
import VaporCron

// Called before your application initializes.
func configure(_ app: Application) throws {
    let complexJob = try app.cron.schedule(ComplexJob.self)
    /// This example code will cancel scheduled job after 185 seconds
    /// so in a console you'll see "Closure fired" three times only
    app.eventLoopGroup.next().scheduleTask(in: .seconds(185)) {
        complexJob.cancel()
    }
}
```

#### In request handler
Some jobs you may want to schedule from some request handler like this
```swift
import Vapor
import VaporCron

func myEndpoint(_ req: Request) throws -> Future<HTTPStatus> {
    try req.cron.schedule(ComplexJob.self)
    return .ok
}
```

### How to do something in the database every 5 minutes?

```swift
import Vapor
import VaporCron

struct Every5MinJob: VaporCronSchedulable {
    static var expression: String { "*/5 * * * *" } // every 5 minutes

    static func task(on application: Application) -> Future<Void> {
        application.db.query(Todo.self).all().map { rows in
            print("ComplexJob fired, found \(rows.count) todos")
        }
    }
}
```

## Dependencies

- [NIOCronScheduler](https://github.com/MihaelIsaev/NIOCronScheduler)
- [SwifCron](https://github.com/MihaelIsaev/SwifCron)

## Contributing

Please feel free to contribute!

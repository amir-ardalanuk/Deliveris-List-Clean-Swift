# Clean architecture with [RxSwift](https://github.com/ReactiveX/RxSwift)

## Contributions are welcome and highly appreciated!!
You can do this by:

- opening an issue to discuss the current solution, ask a question, propose your solution etc. (also English is not my native language so if you think that something can be corrected please open a PR 😊)
- opening a PR if you want to fix bugs or improve something

### Installation

Dependencies in this project are provided via Cocoapods. Please install all dependecies with

`
pod install
`

#### Domain 


The `Domain` is basically what is your App about and what it can do (Entities, UseCase etc.) **It does not depend on UIKit or any persistence framework**, and it doesn't have implementations apart from entities

#### Platform

The `Platform` is a concrete implementation of the `Domain` in a specific platform like iOS. It does hide all implementation details.
`NetworkPlatoform` : prepare a Http conncetion
`RemotePlatform` prepare a api's interfaces for calling network api's
`LocalPlatform`: prepare a api's for getting and setting data from localStorage(here: I used UserDefault)
`RepositoryPlatform`: handel data and prepare data for application layer
`StoragePlatform`: db conncetion's for getting and setting data on 


#### Application
`Application` is responsible for delivering information to the user and handling user input. It can be implemented with any delivery pattern e.g (MVVM, MVC, MVP). This is the place for your `UIView`s and `UIViewController`s. 

To enforce modularity, `Domain`, `Platform` and `Application` are separate targets in the App, which allows us to take advantage of the `internal` access layer in Swift to prevent exposing of types that we don't want to expose.

#### Domain

Entities are implemented as Swift value types



## License
[MIT](https://choosealicense.com/licenses/mit/)

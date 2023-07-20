import Foundation
import Reachability

let reachability = try! Reachability()
var isConnectedToNetwork: Bool {
        return reachability.connection != .unavailable
    }

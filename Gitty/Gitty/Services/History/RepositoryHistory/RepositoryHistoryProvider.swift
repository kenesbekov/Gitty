import Foundation
import SwiftUI

protocol RepositoryHistoryProvider: AnyObject, Sendable {
    var repositories: [Repository] { get }

    func add(_ repository: Repository)
}

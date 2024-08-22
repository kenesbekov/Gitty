import Foundation

enum RepositoryStatType {
    case stars, forks, watchers, issues

    var iconName: String {
        switch self {
        case .stars: "star.fill"
        case .forks: "tuningfork"
        case .watchers: "eye.fill"
        case .issues: "exclamationmark.circle.fill"
        }
    }

    var title: String {
        switch self {
        case .stars: "Stars"
        case .forks: "Forks"
        case .watchers: "Watchers"
        case .issues: "Issues"
        }
    }
}

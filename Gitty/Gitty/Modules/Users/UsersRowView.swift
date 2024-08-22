import SwiftUI

struct UsersRowView: View {
    let user: User
    let markAsViewed: () -> Void
    let showViewedIndicator: Bool

    @State private var isViewed: Bool
    @State private var isNavigationActive = false

    init(
        user: User,
        markAsViewed: @escaping () -> Void,
        showViewedIndicator: Bool = true
    ) {
        self.user = user
        self.markAsViewed = markAsViewed
        self.showViewedIndicator = showViewedIndicator
        self.isViewed = user.isViewed
    }

    var body: some View {
        Button {
            markAsViewed()
            isViewed = true
            isNavigationActive = true
        } label: {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(user.login)
                            .font(.headline)
                            .foregroundColor(.accentColor)
                            .lineLimit(1)

                        if let followers = user.followers {
                            Label("\(followers)", systemImage: "person.2.fill")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                    }

                    Spacer()

                    if showViewedIndicator && isViewed {
                        Image(systemName: "eye")
                            .foregroundColor(.secondary)
                            .opacity(0.5)
                            .transition(.opacity)
                    }

                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }

                Divider()
            }
            .frame(maxWidth: .infinity)
            .padding(.top)
            .padding(.horizontal)
        }
        .background(
            NavigationLink(
                destination: UserRepositoriesView(with: user),
                isActive: $isNavigationActive,
                label: { EmptyView() }
            )
        )
    }
}

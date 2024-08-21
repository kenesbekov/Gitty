import SwiftUI

struct UserRowView: View {
    let user: User
    let markAsViewed: () -> Void
    let showViewedIndicator: Bool

    @State private var isViewed: Bool

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
        NavigationLink(
            destination: UserRepositoriesView(user: user),
            label: {
                ZStack {
                    if showViewedIndicator && isViewed {
                        Color.blue.opacity(0.1)
                    }

                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text(user.login)
                                .font(.headline)
                                .foregroundColor(.accentColor)
                                .lineLimit(1)

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

                        if let followers = user.followers {
                            Label("\(followers)", systemImage: "person.2.fill")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }

                        Divider()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top)
                    .padding(.horizontal)
                }
                .animation(.easeInOut, value: isViewed)
            }
        )
        .simultaneousGesture(
            TapGesture().onEnded {
                markAsViewed()
                isViewed = true
            }
        )
    }
}

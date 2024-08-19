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
        _isViewed = State(initialValue: user.isViewed)
    }

    var body: some View {
        Button {
            if !isViewed {
                markAsViewed()
                isViewed = true
            }
        } label: {
            VStack(alignment: .leading, spacing: 8) {
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
                }

                if let followers = user.followers {
                    Label("\(followers)", systemImage: "person.2.fill")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(showViewedIndicator && isViewed ? Color.blue.opacity(0.1) : Color.clear)
            .animation(.easeInOut, value: isViewed)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

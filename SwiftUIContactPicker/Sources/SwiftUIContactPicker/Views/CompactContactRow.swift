import SwiftUI

public struct CompactContactRow: View {
    @State var contact: PhoneContact

    public init(contact: PhoneContact) {
        self._contact = State<PhoneContact>(wrappedValue: contact)
    }

    public var body: some View {
        HStack(spacing: 2) {
            if let gn = contact.givenName {
                if contact.familyName == nil || contact.familyName?.isEmpty ?? false  {
                    Text(gn).bold()
                } else {
                    Text(gn)
                }
            }
            if let mn = contact.middleName {
                Text(mn)
            }
            if let fn = contact.familyName {
                Text(fn).bold()
            }
            if let ns = contact.nameSuffix {
                Text(ns)
            }
            Spacer()
        }.contentShape(Rectangle())
    }
}

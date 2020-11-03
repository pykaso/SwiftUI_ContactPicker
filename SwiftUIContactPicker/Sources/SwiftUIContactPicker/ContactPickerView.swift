import Contacts
import SwiftUI

public struct ContactListView: View {
    @Binding var selectedContact: PhoneContact?
    @StateObject private var viewModel: ContactPickerViewModel = ContactPickerViewModel(store: ContactStore())

    public init(
        viewModel: ContactPickerViewModel,
        selectedContact: Binding<PhoneContact?>,
        rowBuilder: ((PhoneContact, ContactListView) -> AnyView)? = nil,
        onCancel: (() -> Void)? = nil
    ) {
        self._selectedContact = selectedContact
        self.onCancel = onCancel

        if let rb = rowBuilder {
            self.rowBuilder = rb
        } else {
            self.rowBuilder = { contact, _ in
                AnyView(CompactContactRow(contact: contact))
            }
        }
    }

    let rowBuilder: (_ contact: PhoneContact, _ listView: ContactListView) -> AnyView
    let onCancel: (() -> Void)?

    public var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ContactPickerHeader(text: $viewModel.query, onCancel: onCancel)

            if viewModel.groups.count > 0 {
                List {
                    ForEach(viewModel.groups) { g in
                        Section(header: Text(g.name)) {
                            ForEach(g.rows) { c in
                                rowBuilder(c, self).onTapGesture {
                                    // print("onTapGesture: \(c.name)")
                                    viewModel.selectedContact = c
                                    selectedContact = c
                                }
                            }
                        }
                    }
                }.listStyle(PlainListStyle())
            } else {
                GeometryReader { gm in
                    VStack {
                        Text("No results")
                            .position(x: gm.size.width / 2, y: gm.size.height / 2)
                    }
                }
            }
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .onAppear {
            viewModel.query = ""
        }
    }

    func isLast(_ item: PhoneContact) -> Bool {
        viewModel.rows.lastIndex(of: item) == viewModel.rows.count - 1
    }
}

struct ContactListView_Previews: PreviewProvider {
    static let vm = ContactPickerViewModel(store: StubContactStore())
    static var previews: some View {
        ContactListView(viewModel: vm, selectedContact: Binding.constant(nil)) { contact, _ in
            AnyView(CompactContactRow(contact: contact))
        }
    }
}

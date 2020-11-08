import Contacts
import SwiftUI

public struct ContactPickerView: View {
    @Binding var selectedContact: PhoneContact?
    @StateObject private var viewModel: ContactPickerViewModel = ContactPickerViewModel(store: ContactStore())
    private var cpConfig: ContactPickerConfiguration

    public init(
        viewModel: ContactPickerViewModel,
        config: ContactPickerConfiguration,
        selectedContact: Binding<PhoneContact?>,
        rowBuilder: ((PhoneContact, ContactPickerView) -> AnyView)? = nil,
        onCancel: (() -> Void)? = nil
    ) {
        self._selectedContact = selectedContact
        self.onCancel = onCancel
        self.cpConfig = config
        if let rb = rowBuilder {
            self.rowBuilder = rb
        } else {
            self.rowBuilder = { contact, _ in
                AnyView(CompactContactRow(contact: contact))
            }
        }
    }

    let rowBuilder: (_ contact: PhoneContact, _ listView: ContactPickerView) -> AnyView
    let onCancel: (() -> Void)?

    public var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ContactPickerHeader(text: $viewModel.query, onCancel: onCancel, l10n: cpConfig.l10n)

            if viewModel.groups.count > 0 {
                List {
                    ForEach(viewModel.groups) { g in
                        Section(header: Text(g.name)) {
                            ForEach(g.rows) { c in
                                rowBuilder(c, self)
                                    .onTapGesture {
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
        ContactPickerView(viewModel: vm, config: ContactPickerConfiguration.default, selectedContact: Binding.constant(nil)) { contact, _ in
            AnyView(CompactContactRow(contact: contact))
        }
    }
}

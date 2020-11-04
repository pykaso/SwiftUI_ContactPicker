# SwiftUI ContactPicker
Native SwiftUI CNContactViewController replacement

![License](https://img.shields.io/cocoapods/l/Purchases.svg?style=flat)
![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-orange.svg)
![Twitter](https://img.shields.io/twitter/follow/pykasonet?label=Follow&style=social)

![CNContactViewController VS. SwiftUI_ContactPicker](https://github.com/pykaso/SwiftUI_ContactPicker/blob/main/github/swiftui_contact_picker.png?raw=true)

## Usage
Default list, without custom row layout

```
import SwiftUIContactPicker

@State var selectedContact: PhoneContact?
@State var viewModel: ContactPickerViewModel = ContactPickerViewModel(store: 
@State var showSheet: Bool = false

var body: some View {
    Text("Choose a contact")
        .onTapGesture {
            showSheet.toggle()
        }
        .sheet(isPresented: $showSheet, content: {
            ContactListView(viewModel: ContactPickerViewModel(store: ContactStore()),
                            selectedContact: $selectedContact,
                            onCancel: {
                                showSheet = false
                            })
        })
        .onChange(of: selectedContact) { selected in
            guard let selectedContact = selected else { return }
            print("selected=\(selectedContact.name ?? "")")

        }
}
```

## TODO
- The "Groups" button not implemented. It's possible that will be removed/hidden because I don't need it for now.
- Missing "index bar" (letters on the right side)

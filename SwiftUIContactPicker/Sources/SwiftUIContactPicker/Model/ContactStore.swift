import ContactsUI
import SwiftUI

public protocol ContactStoreProvider {
    func filtered(by query: String) -> [PhoneContact]
}

public class ContactStore: ObservableObject, ContactStoreProvider {
    var contacts: [PhoneContact] = []

    public init() {
        load()
    }

    public func filtered(by query: String) -> [PhoneContact] {
        guard !query.isEmpty else { return contacts }

        let filtered = contacts.filter { contact -> Bool in
            contact.name?.lowercased().contains(query.lowercased()) ?? false
        }

        return filtered
    }

    func load() {
        contacts = getContacts().map { PhoneContact(contact: $0) }
    }

    func getContacts() -> [CNContact] {
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactIdentifierKey,
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactThumbnailImageDataKey,
            CNContactViewController.descriptorForRequiredKeys(),
        ] as [Any]

        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }

        var results: Set<CNContact> = []

        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                for c in containerResults {
                    results.insert(c)
                }
            } catch {
                print("Error fetching containers")
            }
        }
        return Array(results)
    }
}

public class StubContactStore: ContactStore {
    override func load() {
        contacts = [
            PhoneContact(id: UUID().uuidString, givenName: "John", familyName: "Appleseed"),
            PhoneContact(id: UUID().uuidString, givenName: "Kate", familyName: "Bell"),
            PhoneContact(id: UUID().uuidString, givenName: "Anna", familyName: "Haro"),
            PhoneContact(id: UUID().uuidString, givenName: "Daniel", familyName: "Higgins", nameSuffix: "Jr."),
            PhoneContact(id: UUID().uuidString, givenName: "David", familyName: "Taylor"),
            PhoneContact(id: UUID().uuidString, givenName: "Hank", familyName: "Zakroff", middleName: "M."),
        ]
    }
}

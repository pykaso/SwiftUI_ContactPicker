import Combine
import SwiftUI

public struct Group: Identifiable, Hashable {
    public var id: String { name }
    public let name: String
    public let rows: [PhoneContact]

    init(name: String, rows: [PhoneContact]) {
        self.name = name
        self.rows = rows
    }
}

public class ContactPickerViewModel: ObservableObject {
    private var store: ContactStoreProvider

    @Published public var selectedContact: PhoneContact?
    @Published public var rows: [PhoneContact] = []
    @Published public var groups: [Group] = []

    var query: String = "" {
        willSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.searchSubject.send(newValue)
            }
        }
    }

    let onlyWithPhoneNumber: Bool

    private let searchSubject = PassthroughSubject<String, Never>()

    private var searchCancellable: Cancellable!

    deinit {
        searchCancellable?.cancel()
    }

    public init(store: ContactStoreProvider, onlyWithPhoneNumber: Bool = false) {
        self.store = store
        self.onlyWithPhoneNumber = onlyWithPhoneNumber
        
        searchCancellable = searchSubject
            .eraseToAnyPublisher().map { $0 }
            .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { searchText in
                let rows = self.store.filtered(by: searchText)
                if self.onlyWithPhoneNumber {
                    self.rows = rows.filter { $0.phoneNumber.count > 0 }
                } else {
                    self.rows = rows
                }
                self.updateGroups()
            })
    }

    public func updateGroups() {
        let _groups = Dictionary(grouping: rows) { (contact: PhoneContact) -> String in
            return String(contact.sortName.prefix(1))
        }.sorted { l, r -> Bool in
            if l.key == "#"  { return false }
            if r.key == "#" { return true }
            return l.key < r.key
        }.map { key, value -> Group in
            Group(name: key, rows: value.sorted(by: { (lp, rp) -> Bool in
                lp.sortName < rp.sortName
            }))
        }
        self.groups = _groups
    }
}

extension PhoneContact {
    var sortName: String {
        if let fn = familyName?.trimmingCharacters(in: .whitespacesAndNewlines), !fn.isEmpty {
            return fn
        } else if let gn = givenName?.trimmingCharacters(in: .whitespacesAndNewlines), !gn.isEmpty {
            return gn
        }
        return "#"
    }
}

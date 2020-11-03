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
            DispatchQueue.main.async {
                self.searchSubject.send(newValue)
            }
        }
    }

    private let searchSubject = PassthroughSubject<String, Never>()

    private var searchCancellable: Cancellable!

    deinit {
        searchCancellable?.cancel()
    }

    public init(store: ContactStoreProvider) {
        self.store = store

        searchCancellable = searchSubject
            .eraseToAnyPublisher().map { $0 }
            .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { searchText in
                self.rows = self.store.filtered(by: searchText)
                self.updateGroups()
            })
    }

    public func updateGroups() {
        let _groups = Dictionary(grouping: rows) { (contact: PhoneContact) -> String in
            guard let fn = contact.familyName else { return "" }
            return String(fn.prefix(1))
        }.sorted { l, r -> Bool in
            l.key < r.key
        }.map { key, value -> Group in
            Group(name: key, rows: value.sorted(by: { (lp, rp) -> Bool in
                lp.familyName ?? "" < rp.familyName ?? ""
            }))
        }
        self.groups = _groups
    }
}


public struct ContactPickerConfiguration {
    public static let `default`: ContactPickerConfiguration = ContactPickerConfiguration(l10n: L10n(title: "Contacts",
                                                                                                cancelButton: "Cancel",
                                                                                                groupsButton: "Groups",
                                                                                                searchPlaceholder: "Search"))
    public init(l10n: ContactPickerConfiguration.L10n) {
        self.l10n = l10n
    }
    
    public struct L10n {
        let title: String
        let cancelButton: String
        let groupsButton: String
        let searchPlaceholder: String
    }

    let l10n: L10n
}

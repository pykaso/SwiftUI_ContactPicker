import ContactsUI
import Foundation

public class PhoneContact: Identifiable, Hashable {
    internal init(id: String,
                  givenName: String? = nil,
                  familyName: String? = nil,
                  middleName: String? = nil,
                  nameSuffix: String? = nil,
                  avatarData: Data? = nil,
                  phoneNumber: [String] = [String](),
                  email: [String] = [String]()) {
        self.id = id
        self.givenName = givenName
        self.familyName = familyName
        self.avatarData = avatarData
        self.phoneNumber = phoneNumber
        self.email = email
    }

    public static func == (lhs: PhoneContact, rhs: PhoneContact) -> Bool {
        lhs.id == rhs.id
    }

    public var id: String
    public var givenName: String?
    public var familyName: String?
    public var middleName: String?
    public var nameSuffix: String?
    public var avatarData: Data?
    public var phoneNumber: [String] = [String]()
    public var email: [String] = [String]()
    public var cnContact: CNContact?
    
    public var name: String? {
        cnContact?.fullName
    }


    init() {
        id = ""
        givenName = nil
        familyName = nil
        middleName = nil
        avatarData = nil
        phoneNumber = []
        email = []
    }

    init(contact: CNContact) {
        id = contact.identifier
        givenName = contact.givenName
        familyName = contact.familyName
        middleName = contact.middleName
        nameSuffix = contact.nameSuffix
        avatarData = contact.thumbnailImageData
        cnContact = contact
        
        for phone in contact.phoneNumbers {
            phoneNumber.append(phone.value.stringValue)
        }
        for mail in contact.emailAddresses {
            email.append(mail.value as String)
        }
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


extension CNContact {
    var fullName: String {
        let safeName = [self.givenName, self.middleName , self.familyName].compactMap({ $0 }).joined(separator: " ")
        return CNContactFormatter.string(from: self, style: .fullName) ?? safeName
    }
}

import SwiftUI

public struct ContactPickerHeader: View {
    @Binding var text: String
    public let onCancel: (() -> Void)?
    
    @State private var showCancelButton: Bool = false

    public var body: some View {
        VStack(spacing: 0) {
            if !showCancelButton {
                HStack {
                    Button("Groups", action: {})
                    Spacer()
                    Text("Contacts")
                        .bold()
                    Spacer()
                    Button("Cancel", action: {
                        onCancel?()
                    })
                }.padding(EdgeInsets(top: 18, leading: 20, bottom: 4, trailing: 20))
                    .accentColor(Color.Theme.primaryTint)
            }

            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color.gray)
                        .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 0))
                    TextField("", text: $text,
                              onEditingChanged: { changed in
                                  print("onEditingChanged(\(changed)")
                                  withAnimation {
                                      showCancelButton = changed
                                  }
                              },
                              onCommit: {
                                  print("onCommit")
                              })
                        .modifier(PlaceholderStyle(showPlaceHolder: text.isEmpty, placeholder: "Search"))
                        .font(.system(size: 18, weight: .regular, design: .default))
                        .padding(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 4))
                        .background(Color.clear)
                        .foregroundColor(Color.primary)
                    if !text.isEmpty {
                        Image(systemName: "xmark.octagon.fill")
                            .font(.system(size: 14, weight: .light, design: .default))
                            .foregroundColor(Color.secondary)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 4))
                            .onTapGesture {
                                text = ""
                            }
                    }
                }
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)

                if showCancelButton {
                    Button("Cancel", action: {
                        text = ""
                        //showCancelButton = false
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    })
                    .accentColor(Color.Theme.primaryTint)
                }
            }
            .padding(EdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20))

            GeometryReader { gr in
                Color.gray
                    .frame(width: gr.size.width, height: 0.4)
            }.frame(maxHeight: 0.4)
        }
        .background(Color.Theme.headerBackground)
    }
}

public struct PlaceholderStyle: ViewModifier {
    var showPlaceHolder: Bool
    var placeholder: String

    public func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if showPlaceHolder {
                Text(placeholder)
                    .font(.system(size: 17, weight: .regular, design: .default))
                    .foregroundColor(Color.gray)
            }
            content
        }
    }
}

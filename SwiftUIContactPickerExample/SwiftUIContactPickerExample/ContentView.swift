//
//  ContentView.swift
//  SwiftUIComponents
//
//  Created by Lukas Gergel on 02/11/2020.
//

import SwiftUI
import SwiftUIContactPicker

struct ContentView: View {
    @State var selectedContact: PhoneContact?
    @State var showSheet: Bool = false

    @State var flipped: Bool = false
    @State var degrees: Double = 0

    var body: some View {
        Text("Choose a contact")
            .onTapGesture {
                showSheet.toggle()
            }
            .sheet(isPresented: $showSheet, content: {
                ZStack {
                    if !flipped {
                        ContactListView(viewModel: ContactPickerViewModel(store: ContactStore(), onlyWithPhoneNumber: true), selectedContact: $selectedContact,
                                        onCancel: {
                                            showSheet = false
                                        })
                    } else {
                        GeometryReader { gr in
                            Text("BACK")
                                .position(x: gr.size.width / 2, y: gr.size.height / 2)
                                .onTapGesture {
                                    flipped.toggle()
                                    selectedContact = nil
                                    withAnimation {
                                        degrees += 180
                                    }
                                }.rotation3DEffect(.degrees(-degrees), axis: (x: 0, y: 1, z: 0))
                        }
                    }
                }.rotation3DEffect(.degrees(degrees), axis: (x: 0, y: 1, z: 0))
            })
            // }
            .onChange(of: selectedContact) { selected in
                guard let selectedContact = selected else { return }
                print("list.state.selected=\(selectedContact.name ?? "")")
                flipped.toggle()
                withAnimation {
                    degrees -= 180
                }
            }
    }
}

struct DetailView: View {
    @State var contact: PhoneContact

    var body: some View {
        VStack {
            Text("Detail")
            Text(contact.name ?? "")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

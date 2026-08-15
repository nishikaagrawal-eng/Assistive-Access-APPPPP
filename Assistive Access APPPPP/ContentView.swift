//
//  ContentView.swift
//  Challenge 2 App
//
//  Created by T Krobot on 1/8/26.
//

import SwiftUI

struct Contact {
    var name: String
    var phoneNumber: String
}

let daughter = Contact(name: "Daughter", phoneNumber: "12345678")
let son = Contact(name: "Son", phoneNumber: "12345678")
let helper = Contact(name: "Helper", phoneNumber: "12345678")

struct ContentView: View {
    
    var body: some View {
        
        NavigationStack {
            
            VStack(spacing: 30) {
                
                Text("Hi! What would you like to do?")
                    .font(.system(size: 34, weight: .bold))
                    .multilineTextAlignment(.center)
                
                NavigationLink {
                    CallView()
                } label: {
                    Text("📞Call Someone")
                        .font(.system(size: 30, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                
                NavigationLink {
                    MessageContactView()
                } label: {
                    Text("💬 Send a Message")
                        .font(.system(size: 30, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(25)
            .navigationTitle("Dementia Helper")
        }
    }
}

struct CallView: View {
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            Text("Who would you like to call?")
                .font(.system(size: 32, weight: .bold))
                .multilineTextAlignment(.center)
            
            NavigationLink {
                CallConfirmation(contact: daughter)
            } label: {
                Text("👩 Daughter")
                    .font(.system(size: 30, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            
            NavigationLink {
                CallConfirmation(contact: son)
            } label: {
                Text("👨 Son")
                    .font(.system(size: 30, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            
            NavigationLink {
                CallConfirmation(contact: helper)
            } label: {
                Text("👧🏻 Helper")
                    .font(.system(size: 30, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(25)
        .navigationTitle("Call Someone")
    }
}

struct CallConfirmation: View {
    
    var contact: Contact
    
    var body: some View {
        
        VStack(spacing: 30) {
            
            Text("Would you like to call \(contact.name)?")
                .font(.system(size: 36, weight: .bold))
                .multilineTextAlignment(.center)
            
            Link(destination: URL(string: "tel:\(contact.phoneNumber)")!) {
                Text("📞 Call \(contact.name)")
                    .font(.system(size: 30, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(25)
        .navigationTitle("Call")
    }
}

struct MessageContactView: View {
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            Text("Who would you like to message?")
                .font(.system(size: 32, weight: .bold))
                .multilineTextAlignment(.center)
            
            NavigationLink {
                MessageView(contact: daughter)
            } label: {
                Text("👩 Daughter")
                    .font(.system(size: 30, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            
            NavigationLink {
                MessageView(contact: son)
            } label: {
                Text("👨 Son")
                    .font(.system(size: 30, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            
            NavigationLink {
                MessageView(contact: helper)
            } label: {
                Text("👧🏻 Helper")
                    .font(.system(size: 30, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(25)
        .navigationTitle("Send a Message")
    }
}

struct MessageView: View {
    
    var contact: Contact
    
    @State private var message = ""
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            Text("What would you like to tell \(contact.name)?")
                .font(.system(size: 30, weight: .bold))
                .multilineTextAlignment(.center)
            
            TextEditor(text: $message)
                .font(.system(size: 25))
                .frame(height: 180)
                .border(.gray, width: 2)
            
            Link(
                destination: URL(
                    string: "sms:\(contact.phoneNumber)&body=\(message)"
                )!
            ) {
                Text("📤 Send Message")
                    .font(.system(size: 30, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(25)
        .navigationTitle("Message")
    }
}


#Preview {
    ContentView()
}

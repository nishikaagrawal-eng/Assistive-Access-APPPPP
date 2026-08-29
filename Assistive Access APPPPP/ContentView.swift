//
//  ContentView.swift
//  Assitive access app
//

import SwiftUI

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isSent: Bool
}

struct ContentView: View {
    @State private var selectedPerson = ""
    @State private var screen = "home"
    @State private var message = ""
    @State private var daughterMessages: [ChatMessage] = []
    @State private var sonMessages: [ChatMessage] = []
    @State private var helperMessages: [ChatMessage] = []

    var chatMessages: [ChatMessage] {
        switch selectedPerson {
        case "Daughter": daughterMessages
        case "Son": sonMessages
        case "Helper": helperMessages
        default: []
        }
    }

    var body: some View {
        if screen == "home" { homeScreen }
        else { messageScreen }
    }

    var homeScreen: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Chats").font(.system(size: 34, weight: .bold))
                    Text("Recent conversations").font(.system(size: 17)).foregroundStyle(.secondary)
                }
                Spacer()
            }.padding(.top)
            Button { selectedPerson = "Daughter"; screen = "messages" } label: { personButton("Daughter") }
            Button { selectedPerson = "Son"; screen = "messages" } label: { personButton("Son") }
            Button { selectedPerson = "Helper"; screen = "messages" } label: { personButton("Helper") }
            Spacer()
        }.padding()
    }

    func personButton(_ name: String) -> some View {
        HStack(spacing: 15) {
            ZStack {
                Circle().fill(Color.blue.opacity(0.15)).frame(width: 58, height: 58)
                Image(systemName: "person.fill").font(.system(size: 25)).foregroundStyle(.blue)
            }
            Text(name).font(.system(size: 25, weight: .bold))
            Spacer()
            Image(systemName: "chevron.right").font(.system(size: 20, weight: .bold)).foregroundStyle(.secondary)
        }
        .padding().frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 22).fill(Color.gray.opacity(0.12)))
        .foregroundStyle(.primary)
    }

    var messageScreen: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Button { screen = "home" } label: { Image(systemName: "chevron.left").font(.system(size: 23, weight: .bold)) }
                ZStack {
                    Circle().fill(Color.blue.opacity(0.15)).frame(width: 48, height: 48)
                    Image(systemName: "person.fill").font(.system(size: 21)).foregroundStyle(.blue)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(selectedPerson).font(.system(size: 22, weight: .bold))
                    Text("Online").font(.system(size: 14)).foregroundStyle(.secondary)
                }
                Spacer()
            }.padding().background(.ultraThinMaterial)
            Divider()
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        if chatMessages.isEmpty {
                            VStack(spacing: 15) {
                                ZStack {
                                    Circle().fill(Color.blue.opacity(0.12)).frame(width: 90, height: 90)
                                    Image(systemName: "message.fill").font(.system(size: 38)).foregroundStyle(.blue)
                                }
                                Text("No messages yet").font(.system(size: 24, weight: .bold))
                                Text("Send a message to \(selectedPerson)").font(.system(size: 17)).foregroundStyle(.secondary)
                            }.frame(maxWidth: .infinity).padding(.top, 100)
                        } else {
                            ForEach(chatMessages) { chatMessage in
                                HStack {
                                    if chatMessage.isSent { Spacer() }
                                    Text(chatMessage.text).font(.system(size: 20))
                                        .foregroundStyle(chatMessage.isSent ? .white : .primary)
                                        .padding(.horizontal, 17).padding(.vertical, 12)
                                        .background(chatMessage.isSent ? Color.blue : Color.gray.opacity(0.15))
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .frame(maxWidth: 280, alignment: chatMessage.isSent ? .trailing : .leading)
                                    if !chatMessage.isSent { Spacer() }
                                }.id(chatMessage.id)
                            }
                        }
                    }.padding()
                }
                .onChange(of: chatMessages.count) {
                    if let lastMessage = chatMessages.last { withAnimation(.easeOut(duration: 0.25)) { proxy.scrollTo(lastMessage.id, anchor: .bottom) } }
                }
            }
            HStack(spacing: 10) {
                    TextField("Type a message...", text: $message).font(.system(size: 19)).padding(.horizontal, 16).padding(.vertical, 12).background(Color.gray.opacity(0.12)).clipShape(RoundedRectangle(cornerRadius: 20))
                    Button { sendMessage() } label: {
                        Image(systemName: "arrow.up").font(.system(size: 20, weight: .bold)).foregroundStyle(.white).frame(width: 48, height: 48).background(message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray : Color.blue).clipShape(Circle())
                    }.disabled(message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }.padding().background(.ultraThinMaterial)
        }.ignoresSafeArea(.keyboard, edges: .bottom)
    }

    func sendMessage() {
        let cleanedMessage = message.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanedMessage.isEmpty else { return }
        addMessage(cleanedMessage)
        message = ""
    }

    func addMessage(_ text: String) {
        let newMessage = ChatMessage(text: text, isSent: true)
        withAnimation(.spring(response: 0.3)) {
            switch selectedPerson {
            case "Daughter": daughterMessages.append(newMessage)
            case "Son": sonMessages.append(newMessage)
            case "Helper": helperMessages.append(newMessage)
            default: break
            }
        }
    }

}

// MARK: - Assistive Access experience

/// This view is shown by iOS only while Assistive Access is enabled.
/// It keeps the core task—sending a message—short, predictable, and easy to reverse.
struct AssistiveAccessContentView: View {
    private let contacts = [
        AssistiveContact(name: "Daughter", symbol: "heart.fill", color: .pink),
        AssistiveContact(name: "Son", symbol: "star.fill", color: .orange),
        AssistiveContact(name: "Helper", symbol: "hand.raised.fill", color: .blue)
    ]
    private let assistiveEmojis = ["😀", "❤️", "👍", "🙏", "👋", "😊"]
    private let presetMessages = ["Hello!", "I am okay.", "Please call me.", "Thank you!"]

    @State private var selectedContact: AssistiveContact?
    @State private var confirmationText: String?
    @State private var personalText = ""

    var body: some View {
        Group {
            if let selectedContact {
                messageChoices(for: selectedContact)
            } else {
                contactChoices
            }
        }
        .padding(24)
        .background(Color(uiColor: .systemBackground))
    }

    private var contactChoices: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Who would you like to message?")
                .font(.system(size: 34, weight: .bold))
                .accessibilityAddTraits(.isHeader)

            ForEach(contacts) { contact in
                Button { selectedContact = contact } label: {
                    HStack(spacing: 20) {
                        Image(systemName: contact.symbol)
                            .font(.system(size: 34, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 76, height: 76)
                            .background(contact.color, in: Circle())
                        Text(contact.name)
                            .font(.system(size: 30, weight: .bold))
                        Spacer()
                    }
                    .padding(18)
                    .frame(maxWidth: .infinity, minHeight: 104)
                    .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 24))
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Message \(contact.name)")
            }
            Spacer()
        }
    }

    private func messageChoices(for contact: AssistiveContact) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
            Button { selectedContact = nil; confirmationText = nil } label: {
                Label("Choose another person", systemImage: "chevron.left")
                    .font(.title3.weight(.bold))
            }

            Text("Message \(contact.name)")
                .font(.system(size: 34, weight: .bold))
                .accessibilityAddTraits(.isHeader)

            if let confirmationText {
                VStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 58))
                        .foregroundStyle(.green)
                    Text(confirmationText)
                        .font(.title2.weight(.bold))
                        .multilineTextAlignment(.center)
                    Button("Send another message") { self.confirmationText = nil }
                        .font(.title3.weight(.bold))
                        .buttonStyle(.bordered)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Text("Personal text")
                    .font(.title3)
                    .fontWeight(.bold)

                TextField("Type your message", text: $personalText, axis: .vertical)
                    .font(.system(size: 24))
                    .lineLimit(2...4)
                    .padding(18)
                    .background(Color(uiColor: .secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                Button {
                    let message = personalText.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !message.isEmpty else { return }
                    confirmationText = "Your message was sent to \(contact.name)."
                    personalText = ""
                } label: {
                    Label("Send typed message", systemImage: "arrow.up.circle.fill")
                        .font(.system(size: 24, weight: .bold))
                        .frame(maxWidth: .infinity, minHeight: 76)
                        .background(personalText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray : Color.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .buttonStyle(.plain)
                .disabled(personalText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                Text("Preset messages")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.top, 8)

                ForEach(presetMessages, id: \.self) { message in
                    Button {
                        confirmationText = "\(message) was sent to \(contact.name)."
                    } label: {
                        Text(message)
                            .font(.system(size: 26, weight: .bold))
                            .frame(maxWidth: .infinity, minHeight: 70)
                            .background(Color.blue)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Send \(message) to \(contact.name)")
                }

                Text("Emoji")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.top, 8)

                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible(), spacing: 14), count: 3),
                    spacing: 14
                ) {
                    ForEach(assistiveEmojis, id: \.self) { emoji in
                        Button {
                            confirmationText = "\(emoji) was sent to \(contact.name)."
                        } label: {
                            Text(emoji)
                                .font(.system(size: 42))
                                .frame(maxWidth: .infinity, minHeight: 76)
                                .background(Color(uiColor: .secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Send \(emoji) to \(contact.name)")
                    }
                }
                Spacer(minLength: 20)
            }
        }
        }
    }
}

private struct AssistiveContact: Identifiable {
    let name: String
    let symbol: String
    let color: Color
    var id: String { name }
}

#Preview { ContentView() }

#Preview("Assistive Access", traits: .assistiveAccess) {
    AssistiveAccessContentView()
}


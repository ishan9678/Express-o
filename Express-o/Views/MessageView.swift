//
//  MessageView.swift
//  Express-o
//
//  Created by user1 on 02/01/24.
//

import SwiftUI

struct MessageView: View {
    @ObservedObject var viewModel: ChatViewModel
    @State private var newMessage = ""

    var body: some View {
        VStack {
            // Header
            HeaderView(title: "Nova", subTitle: "", alignLeft: true, height: 230, subMessage: true, subMessageWidth: 133, subMessageText: "          Your Art Pal")
                .frame(maxWidth: .infinity, maxHeight: 130, alignment: .topLeading)
                
            
            List(viewModel.messages) { message in
                Text(message.text)
                    .padding(10)
                    .padding(.leading, 5)
                    .padding(.trailing, 5)
                    .background(message.isUser1 ? Color(hex: "FEC7C0") : Color(hex: "E9E9EB")) // Set background to .clear for messages from User 1
                    .foregroundColor(Color(hex: "17335F"))
                    .cornerRadius(20)
                    .frame(maxWidth: .infinity, alignment: message.isUser1 ? .trailing : .leading) // Align messages to the right for User 1
                    .listRowInsets(EdgeInsets()) // Set row insets to zero to remove extra spacing

            }
            .listStyle(PlainListStyle())
            .padding(.top, 40)
            .padding(.trailing, 10)
            .padding(.leading,10)
            .padding(.bottom,5)

            HStack {
                Button(action: {
                            // handle audio
                           }) {
                               Image(systemName: "mic.fill")
                                   .font(.title)
                                   .foregroundColor(.blue)
                           }

                           Button(action: {
                               // handle image
                           }) {
                               Image(systemName: "photo.fill")
                                   .font(.title)
                                   .foregroundColor(.purple)
                           }

                           TextField("Type a message", text: $newMessage)
                               .textFieldStyle(RoundedBorderTextFieldStyle())

                           Button(action: {
                               self.sendMessage()
                           }) {
                               Text("Send")
                           }
                       }
                       .padding()

            BottomNavBarView()
        }
        .navigationTitle("Chat")
        .edgesIgnoringSafeArea(.bottom)
        .background(Color.white)
        .navigationBarHidden(true)

    }

    func sendMessage() {
        guard !newMessage.isEmpty else { return }
        viewModel.sendMessage(text: newMessage, isUser1: true)
        newMessage = ""

        // Simulate a response after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let responseMessage = "I received your message: \(newMessage)"
            self.viewModel.sendMessage(text: responseMessage, isUser1: false) // Simulated response
        }
    }
}


#Preview {
    MessageView(viewModel: ChatViewModel())
}

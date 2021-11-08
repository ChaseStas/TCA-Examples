//
//  InfoPopup.swift
//  TestTCA
//
//  Created by Stanislau Parechyn on 03.11.2021.
//

import SwiftUI

struct InfoPopup: View {
    let text: String
    let onDismiss: () -> Void

    var body: some View {
        ZStack(alignment: .center) {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture(perform: onDismiss)

            VStack(spacing: 0) {
                Button(action: onDismiss, label: {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .foregroundColor(.black)
                        .rotationEffect(.degrees(45))
                        .frame(width: 44, height: 44)
                })
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal, 4)
                .padding(.top, 4)

                Text(text)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)

            }
            .background(
                Color.white
                    .cornerRadius(20)
            )
            .frame(maxWidth: 280)
        }
    }

}

struct InfoPopup_Previews: PreviewProvider {
    static var previews: some View {
        InfoPopup(text: "Hello, my name is Igor and I'm about to play some music for use!", onDismiss: {})
            .background(Color.blue)
    }
}

//
//  SplashScreenView.swift
//  DysKid
//
//  Created by Mehmet Ali Bunsuz on 25.09.2024.
//

import SwiftUI
import FirebaseAuth

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var isLoggedIn = false

    var body: some View {
        Group {
            if isActive {
                if isLoggedIn {
                    NewIntroView()
                } else {
                    NewIntroView()
                }
            } else {
                VStack {
                    Image("logo-black")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 200)
                        .transition(.opacity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .onAppear {
                    checkUserLoginStatus()
                }
            }
        }
        .animation(.easeIn, value: isActive)
    }

    private func checkUserLoginStatus() {

        if Auth.auth().currentUser != nil {
            isLoggedIn = true
        } else {
            isLoggedIn = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                isActive = true 
            }
        }
    }
}

#Preview {
    SplashScreenView()
}

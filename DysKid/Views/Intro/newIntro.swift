//
//  newIntro.swift
//  DysKid
//
//  Created by Mehmet Ali Bunsuz on 25.09.2024.
//
import SwiftUI

struct NewIntroView: View {

    @State private var showSignUp: Bool = false
    @State private var showLoginView: Bool = false
    @State private var isVisible: Bool = false

    var body: some View {
        VStack(spacing: 40) {
            ZStack {
                Image("intro")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: UIScreen.main.bounds.height / 1.8)
                    .clipped()
                    .ignoresSafeArea(edges: .top)
                
                VStack {
                    Spacer()
                    Text("Her Çocuk Özel, \nHer Yolculuk Farklı")
                        .font(.custom(outfitMedium, size: 38))
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 16)
                        .foregroundColor(.white)
                        .padding(.bottom, 40)
                        .offset(x: isVisible ? -30 : -100)
                        .opacity(isVisible ? 1 : 0)
                        .animation(.easeIn(duration: 0.6).delay(0.1), value: isVisible)
                }
                
                HStack(alignment: .top) {
                    Image("logoTrans")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding(.leading, 16)
                    
                    VStack(alignment: .leading) {
                        Text("DysKid")
                            .font(.custom(outfitRegular, size: 14))
                            .foregroundColor(.white)
                        Text("Dyslexia & ADHD")
                            .font(.custom(outfitLight, size: 10))
                            .foregroundColor(.white)
                    }
                    .padding(.top, -1)
                }
                .padding(.top, -190)
                .offset(x: isVisible ? -125 : -200)
                .opacity(isVisible ? 1 : 0)
                .animation(.easeIn(duration: 0.6).delay(0.2), value: isVisible)
            }

            HStack(spacing: 16) {
                actionButton(title: "Giriş Yap", backgroundColor: Color("ColorSecondaryBlack"), textColor: Color.white, showStroke: false) {
                    showLoginView.toggle()
                }
                .disableWithOpacity(false)
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 20)
                .animation(.easeIn(duration: 0.6).delay(0.3), value: isVisible)

                actionButton(title: "Kayıt Ol", backgroundColor: Color.white, textColor: Color.black, showStroke: true) {
                    showSignUp.toggle()
                }
                .disableWithOpacity(false)
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 20)
                .animation(.easeIn(duration: 0.6).delay(0.3), value: isVisible)
            }
            .padding(.horizontal, 16)
            .hSpacing() // Maksimum genişlik ayarı

            HStack {
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(.gray)
                Text("veya")
                    .foregroundColor(.gray)
                    .padding(.horizontal, 8)
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 16)
            .hSpacing() // Maksimum genişlik ayarı

            // Sosyal Butonlar
            socialButton(title: "Apple ile Devam Et", imageName: "apple") {
                // Apple ile devam etme işlemi
            }
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 20)
            .animation(.easeIn(duration: 0.6).delay(0.4), value: isVisible)

            socialButton(title: "Google ile Devam Et", imageName: "google") {
                // Google ile devam etme işlemi
            }
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 20)
            .animation(.easeIn(duration: 0.6).delay(0.4), value: isVisible)
            .padding(.bottom, 20)

            Spacer()
        }
        .fullScreenCover(isPresented: $showLoginView) {
            LoginView()
        }
        .fullScreenCover(isPresented: $showSignUp) {
            RegisterView()
        }
        .onAppear {
            isVisible = true
        }
    }

    private func actionButton(title: String, backgroundColor: Color, textColor: Color, showStroke: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.custom(outfitMedium, size: 18))
                .frame(maxWidth: .infinity)
                .padding()
                .background(backgroundColor)
                .foregroundColor(textColor)
                .cornerRadius(30)
                .overlay(
                    showStroke ? RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.gray, lineWidth: 0.5) : nil
                )
        }
        .frame(height: 50)
    }

    private func socialButton(title: String, imageName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(imageName)
                    .foregroundColor(.black)
                    .frame(width: 24, height: 24)
                Text(title)
                    .font(.custom(outfitRegular, size: 18))
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .foregroundColor(.black)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.gray, lineWidth: 0.5)
            )
        }
        .frame(height: 50)
        .padding(.horizontal, 16)
    }
}

#Preview {
    NewIntroView()
}

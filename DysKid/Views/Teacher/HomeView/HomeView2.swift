//
//  HomeView2.swift
//  DysKid
//
//  Created by Mehmet Ali Bunsuz on 1.11.2024.
//
import SwiftUI

// Örnek ClassroomView
struct ClassroomView: View {
    var body: some View {
        VStack {
            Text("Classroom Sayfası")
                .font(.largeTitle)
                .foregroundColor(.black)
            Spacer()
        }
        .padding()
    }
}

struct HomeView2: View {
    var body: some View {
        NavigationView {  // NavigationView ile sayfalar arasında geçiş yapılabilir
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // HeaderView sabit
                    HeaderView(profileImage: Image("man")) {
                        // HeaderView içeriği burada
                    } onNotificationsButtonTapped: {
                        // Bildirim butonuna tıklama işlevi burada
                    }
                    .frame(height: 120) // Header'ın yüksekliği

                    // Scrollable içerik
                    ScrollView {
                        VStack(spacing: 20) {
                            VStack(spacing: 16) {
                                HStack {
                                    Text("Günaydın Ali!")
                                        .font(.custom(outfitLight, size: 34))
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                                .padding(.leading)

                                // Turuncu kısmı, tıklanabilir yapmak için NavigationLink ekliyoruz
                                NavigationLink(destination: TeacherView()) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 100)
                                            .fill(Color.orange)
                                            .frame(height: 85)
                                        
                                        HStack(spacing: 10) {
                                            Circle()
                                                .fill(Color.white)
                                                .frame(width: 70, height: 70)
                                                .overlay(
                                                    Text("7")
                                                        .font(.title)
                                                        .foregroundColor(.orange)
                                                )

                                            ScrollView(.horizontal, showsIndicators: false) {
                                                HStack(spacing: -10) {
                                                    ForEach(0..<3) { _ in
                                                        Circle()
                                                            .frame(width: 50, height: 50)
                                                            .overlay(
                                                                Image("man")
                                                                    .resizable()
                                                                    .scaledToFit()
                                                                    .clipShape(Circle())
                                                            )
                                                            .foregroundColor(Color.gray.opacity(0.3))
                                                    }
                                                    Circle()
                                                        .fill(Color.white)
                                                        .frame(width: 50, height: 50)
                                                        .overlay(
                                                            Text("+")
                                                                .font(.title)
                                                                .foregroundColor(.gray)
                                                        )
                                                }
                                                .padding(.horizontal, 5)
                                            }
                                            
                                            Circle()
                                                .stroke(Color.white, lineWidth: 6)
                                                .frame(width: 70, height: 70)
                                                .overlay(
                                                    Image(systemName: "arrow.right")
                                                        .foregroundColor(.white)
                                                )
                                        }
                                        .padding(.horizontal, 8)
                                    }
                                    .padding(.horizontal)
                                }
                                .buttonStyle(PlainButtonStyle()) // Bu, butonun görünümünü düz tutar
                            }
                            
                            Spacer() // Diğer içerikler burada
                        }
                        .padding() // Overall padding for the whole content
                        .frame(width: geometry.size.width)
                    }
                    .background(Color.white)
                    .edgesIgnoringSafeArea(.bottom) // Allow content to go to the bottom of the screen
                }
            }
            .navigationBarTitleDisplayMode(.inline) // If you're using a navigation view
        }
    }
}

struct HomeView2_Previews: PreviewProvider {
    static var previews: some View {
        HomeView2()
    }
}

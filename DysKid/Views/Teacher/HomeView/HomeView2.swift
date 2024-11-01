//
//  HomeView2.swift
//  DysKid
//
//  Created by Mehmet Ali Bunsuz on 1.11.2024.
//
import SwiftUI

// Model
struct Student: Identifiable {
    let id = UUID()
    let name: String
    let timeSpent: String
    let points: Int
}

// ViewModel
class HomeViewModel: ObservableObject {
    @Published var students = [
        Student(name: "Mehmet Ali Bunsuz", timeSpent: "16 Dakika", points: 45),
        Student(name: "Ayşe Güneş", timeSpent: "20 Dakika", points: 50),
        Student(name: "Ahmet Deniz", timeSpent: "12 Dakika", points: 40)
    ]
}

// Öğrenci Kartı Görünümü
struct StudentCardView: View {
    var student: Student
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Günün Öğrencisi")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 90, height: 90)
                .overlay(
                    Image("man")
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                )
            
            Text(student.name)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.black)
            
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .foregroundColor(.orange)
                Text(student.timeSpent)
                    .font(.headline)
                    .foregroundColor(.black)
            }
            
            Text("Toplamda \(student.points) puan topladı.")
                .font(.footnote)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(15)
    }
}

// Ana Görünüm
struct HomeView2: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var currentIndex: Int = 0 // Aktif sayfa indeksi

    var body: some View {
        GeometryReader { geometry in
            ScrollView { // Make the entire view scrollable
                VStack(spacing: 20) {
                    // Üst Bilgi Alanı
                    HStack {
                        Circle()
                            .fill(Color.gray.opacity(0.05))
                            .frame(width: 70, height: 70)
                            .overlay(
                                Image("man")
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                            )
                        
                        Spacer()
                        
                        HStack(spacing: 0) {
                            Circle()
                                .fill(Color.gray.opacity(0.05))
                                .frame(width: 70, height: 70)
                                .overlay(
                                    Image(systemName: "person.2")
                                        .foregroundColor(.black)
                                        .frame(width: 20, height: 20)
                                )
                            
                            Circle()
                                .fill(Color.gray.opacity(0.05))
                                .frame(width: 70, height: 70)
                                .overlay(
                                    Image(systemName: "bell")
                                        .foregroundColor(.black)
                                        .frame(width: 20, height: 20)
                                )
                        }
                    }
                    .padding(.horizontal)

                    // Kullanıcı Karşılama ve Öğrenci Listesi
                    VStack(spacing: 16) {
                        HStack {
                            Text("Günaydın Ali!")
                                .font(.custom(outfitLight, size: 34))
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .padding(.leading)

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
                    
                    // Günlük Veriler Başlığı
                    HStack {
                        Text("Günlük Veriler")
                            .font(.custom(outfitLight, size: 24))
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding(.top, 20)
                    .padding(.leading)

                    // Günün Öğrencisi ve Ödevler Kaydırılabilir Alanı
                    TabView(selection: $currentIndex) {
                        ForEach(viewModel.students.indices, id: \.self) { index in
                            StudentCardView(student: viewModel.students[index])
                                .tag(index) // Her kartın bir etiketi var
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always)) // Sayfa göstergesi
                    .frame(height: 340) // Kartların yüksekliğine göre ayarlayın
                    
                    // Sayfa göstergesi
                    HStack(spacing: 5) {
                        ForEach(0..<viewModel.students.count, id: \.self) { index in
                            Circle()
                                .fill(currentIndex == index ? Color.orange : Color.gray.opacity(0.5))
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(.top, 8) // Dikey boşluk
                    
                    Spacer()
                }
                .padding() // Overall padding for the whole view
                .frame(width: geometry.size.width)
                .background(Color.white)
                .edgesIgnoringSafeArea(.bottom) // Allow content to go to the bottom of the screen
            }
        }
        .navigationBarTitleDisplayMode(.inline) // If you're using a navigation view
    }
}

struct HomeView2_Previews: PreviewProvider {
    static var previews: some View {
        HomeView2()
    }
}

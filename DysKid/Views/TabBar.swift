//
//  TabBar.swift
//  DysKid
//
//  Created by Mehmet Ali Bunsuz on 25.09.2024.
//

import SwiftUI

struct TeacherTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Ana", systemImage: "house")
                }
            
            TaskHome()
                .tabItem {
                    Label("Görevler", systemImage: "note.text")
                }
            
            Text("Profili Yönet")
                .tabItem {
                    Label("Profil", systemImage: "person")
                }
        }
        .accentColor(.black)
    }
}

struct ParentTabView: View {
    var body: some View {
        TabView {
            SummaryView()
                .tabItem {
                    Label("Ana", systemImage: "house")
                }
            
            Text("Çocuk Durumu")
                .tabItem {
                    Label("Durum", systemImage: "book")
                }
            
            Text("Eğitim İçeriği")
                .tabItem {
                    Label("Eğitim", systemImage: "person")
                }
        }
    }
}


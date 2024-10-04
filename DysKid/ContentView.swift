//
//  ContentView.swift
//  DysKid
//
//  Created by Mehmet Ali Bunsuz on 26.09.2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                SplashScreenView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.white)
                    .preferredColorScheme(.light)
            } else {
                if let userRole = viewModel.userRole {
                    if userRole == "teacher" {
                        TeacherTabView()
                    } else if userRole == "parent" {
                        ParentTabView()
                    } else {
                        NewIntroView()
                    }
                } else {
                    NewIntroView()
                }
            }
        }
        .onAppear {
            viewModel.checkUser()
        }
    }
}

@MainActor
class ContentViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var userRole: String?
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    func checkUser() {
        if let user = auth.currentUser {
            // Oturum açık ise Firestore'dan rolünü kontrol et
            fetchUserRole(userId: user.uid)
        } else {
            // Oturum yoksa kullanıcıyı IntroView'a yönlendir
            isLoading = false
        }
    }
    
    private func fetchUserRole(userId: String) {
        // İlk önce "teachers" koleksiyonunu kontrol et
        checkUserRoleInCollection(userId: userId, collection: "teachers") { [weak self] role in
            if role != nil {
                // Kullanıcı "teacher" olarak bulundu
                self?.userRole = "teacher"
                self?.isLoading = false
            } else {
                // Eğer "teachers" koleksiyonunda bulunmazsa, "parents" koleksiyonuna bak
                self?.checkUserRoleInCollection(userId: userId, collection: "parents") { role in
                    if role != nil {
                        // Kullanıcı "parent" olarak bulundu
                        self?.userRole = "parent"
                    } else {
                        // Kullanıcı hiçbir koleksiyonda bulunamadı, NewIntroView'a yönlendir
                        self?.userRole = nil
                    }
                    self?.isLoading = false
                }
            }
        }
    }
    
    private func checkUserRoleInCollection(userId: String, collection: String, completion: @escaping (String?) -> Void) {
        db.collection(collection).document(userId).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching document: \(error)")
                completion(nil)
                return
            }
            if let snapshot = snapshot, snapshot.exists {
                completion(collection) // Kullanıcının rolünü belirtiyoruz
            } else {
                completion(nil) // Kullanıcı bu koleksiyonda yok
            }
        }
    }
}

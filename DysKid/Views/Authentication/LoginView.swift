import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
    
    @State private var emailID: String = ""
    @State private var password: String = ""
    @State private var showForgotPasswordSheet: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var userRole: String? = nil // Kullanıcı rolünü saklamak için
    @State private var isLoggedIn: Bool = false // Yönlendirmeyi kontrol etmek için

    var body: some View {
        ZStack {
            // Arka plan rengi
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            // Kullanıcı rolüne göre görünüm
            if let role = userRole {
                if role == "teacher" {
                    TeacherTabView()
                        .transition(.move(edge: .trailing)) // Geçiş animasyonu
                } else if role == "parent" {
                    ParentTabView()
                        .transition(.move(edge: .trailing)) // Geçiş animasyonu
                } else {
                    Text("Bilinmeyen kullanıcı rolü.")
                        .foregroundColor(.red)
                }
            } else {
                loginView
                    .transition(.opacity) // Geçiş animasyonu
            }
        }
        .animation(.easeInOut, value: userRole) // Animasyon ayarı
        .sheet(isPresented: $showForgotPasswordSheet) {
            ForgotPasswordSheetView()
                .presentationDetents([.fraction(0.5)])
                .presentationBackground(.gray)
        }
        .alert(isPresented: $showError) {
            Alert(title: Text("Hata"), message: Text(errorMessage), dismissButton: .default(Text("Tamam")))
        }
    }
    
    var loginView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Spacer(minLength: 0)
            Text("Giriş Yap")
                .foregroundStyle(Color("ColorSecondaryBlack"))
                .font(.custom(outfitRegular, size: 36))
            
            Text("Devam etmek için lütfen giriş yapın")
                .font(.custom(outfitRegular, size: 16))
                .foregroundStyle(.gray)
                .padding(.top, -5)
            
            VStack(spacing: 25) {
                CustomTextField(sfIcon: "at", hint: "Email", value: $emailID)
                CustomTextField(sfIcon: "lock", hint: "Şifre", isPassword: true, value: $password)
                
                Button("Şifreni mi Unuttun?") {
                    showForgotPasswordSheet.toggle()
                }
                .font(.custom(outfitRegular, size: 16))
                .foregroundStyle(.gray)
                .tint(.black)
                
                Button(action: loginUser) {
                    Text("Giriş Yap")
                        .font(.custom(outfitRegular, size: 16))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("ColorSecondaryBlack"))
                        .cornerRadius(100)
                        .foregroundStyle(.white)
                }
                .disabled(emailID.isEmpty || password.isEmpty)
            }
            .padding(.top, 20)
            
            Spacer(minLength: 0)
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
    }
    
    func handleLoginError(error: Error) {
        switch AuthErrorCode(rawValue: error._code) {
        case .invalidEmail:
            errorMessage = "Geçersiz e-posta adresi."
        case .wrongPassword:
            errorMessage = "Şifre yanlış."
        case .userNotFound:
            errorMessage = "Bu e-posta adresiyle kayıtlı kullanıcı bulunamadı."
        default:
            errorMessage = "Giris yapılamadı. Lütfen bilgilerinizi kontrol edin ve tekrar deneyin."
        }
        showError = true
    }
    
    func loginUser() {
        Auth.auth().signIn(withEmail: emailID, password: password) { result, error in
            if let error = error {
                handleLoginError(error: error)
            } else {
                fetchUserRole { role in
                    if let role = role {
                        self.userRole = role
                    } else {
                        self.errorMessage = "Kullanıcı rolü bulunamadı."
                        self.showError = true
                    }
                }
            }
        }
    }
    
    func fetchUserRole(completion: @escaping (String?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            print("Kullanıcı oturumu bulunamadı")
            completion(nil)
            return
        }
        
        let db = Firestore.firestore()
        
        // Önce teachers koleksiyonunda kullanıcıyı arıyoruz
        db.collection("teachers").document(user.uid).getDocument { document, error in
            if let error = error {
                print("Firestore'dan öğretmen verisi alınırken hata: \(error.localizedDescription)")
                self.errorMessage = "Veritabanı hatası."
                self.showError = true
                completion(nil)
                return
            }
            
            if let document = document, document.exists {
                if let role = document.data()?["role"] as? String {
                    print("Öğretmen rolü alındı: \(role)") // Hata ayıklama
                    completion(role.lowercased())
                } else {
                    print("Belgede role bulunamadı")
                    self.errorMessage = "Rol bulunamadı."
                    self.showError = true
                    completion(nil)
                }
            } else {
                print("Öğretmen belgesi bulunamadı, veli koleksiyonunu kontrol ediyorum.")
                // Öğretmen değilse parents koleksiyonunda arıyoruz
                db.collection("parents").document(user.uid).getDocument { document, error in
                    if let error = error {
                        print("Firestore'dan veli verisi alınırken hata: \(error.localizedDescription)")
                        self.errorMessage = "Veritabanı hatası."
                        self.showError = true
                        completion(nil)
                        return
                    }
                    
                    if let document = document, document.exists {
                        if let role = document.data()?["role"] as? String {
                            print("Veli rolü alındı: \(role)") // Hata ayıklama
                            completion(role.lowercased())
                        } else {
                            print("Belgede role bulunamadı")
                            self.errorMessage = "Rol bulunamadı."
                            self.showError = true
                            completion(nil)
                        }
                    } else {
                        print("Kullanıcı ne öğretmen ne de veli.")
                        self.errorMessage = "Kullanıcı rolü bulunamadı."
                        self.showError = true
                        completion(nil)
                    }
                }
            }
        }
    }
}

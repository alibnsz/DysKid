import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct RegisterView: View {
    
    @State private var emailID: String = ""
    @State private var fullName: String = ""
    @State private var phone: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var role: String = "Parent"
    @State private var isRegistered: Bool = false // Kayıt durumu için değişken

    var body: some View {
        
        VStack(alignment: .leading, spacing: 15) {
            Spacer(minLength: 0)
            Text("Kayıt Ol")
                .font(.custom("outfitRegular", size: 36))
                .foregroundStyle(Color("ColorSecondaryBlack"))

            Text("Devam etmek için lütfen giriş yapın")
                .font(.custom("outfitRegular", size: 16))
                .foregroundStyle(.gray)
                .padding(.top, -5)
            
            VStack(spacing: 25) {
                
                CustomTextField(sfIcon: "person", hint: "Ad Soyad", value: $fullName)
                
                CustomTextField(sfIcon: "phone", hint: "Telefon", value: $phone)
                    .padding(.top, 5)
                
                CustomTextField(sfIcon: "at", hint: "Email", value: $emailID)
                    .padding(.top, 5)
                
                CustomTextField(sfIcon: "lock", hint: "Şifre", isPassword: true, value: $password)
                    .padding(.top, 5)
                
                CustomTextField(sfIcon: "lock", hint: "Şifre Tekrar", isPassword: true, value: $confirmPassword)
                    .padding(.top, 5)
                
                Text("Lütfen Birini Seçiniz")
                    .font(.custom("outfitRegular", size: 16))
                    .foregroundStyle(Color(.gray))
                
                Picker("Role", selection: $role) {
                    Text("Ebeveyn").tag("Parent")
                    Text("Öğretmen").tag("Teacher")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.top, 10)
                
                Button(action: signUpUser) {
                    Text("Kayıt Ol")
                        .font(.custom("outfitRegular", size: 16))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("ColorSecondaryBlack"))
                        .cornerRadius(100)
                        .foregroundStyle(Color(.white))
                }
                .disabled(emailID.isEmpty || password.isEmpty || fullName.isEmpty || phone.isEmpty || confirmPassword.isEmpty || password != confirmPassword)
                .fullScreenCover(isPresented: $isRegistered) {
                    // Kullanıcının rolüne göre yönlendirme yap
                    if role == "Teacher" {
                        TeacherTabView()
                    } else {
                        ParentTabView()
                    }
                }
            }
            .padding(.top, 20)
            
            Spacer(minLength: 0)
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        .toolbar(.hidden, for: .navigationBar)
    }
    
    func signUpUser() {
        // Firebase Authentication
        Auth.auth().createUser(withEmail: emailID, password: password) { result, error in
            if let error = error {
                print("Kullanıcı oluşturma hatası: \(error.localizedDescription)")
                return
            }
            
            guard let userID = result?.user.uid else { return }
            
            // Kullanıcı verilerini Firestore'a kaydet
            let userData: [String: Any] = [
                "fullName": fullName,
                "email": emailID,
                "phone": phone,
                "role": role
            ]
            
            let collection = role == "Teacher" ? "teachers" : "parents"
            
            Firestore.firestore().collection(collection).document(userID).setData(userData) { error in
                if let error = error {
                    print("Kullanıcı verilerini kaydetme hatası: \(error.localizedDescription)")
                } else {
                    print("\(role) başarıyla kaydedildi!")
                    isRegistered = true // Yönlendirme için true yap
                }
            }
        }
    }
}

#Preview {
    RegisterView()
}

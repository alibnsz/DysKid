import SwiftUI

struct ForgotPasswordSheetView: View {
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all) 
            VStack {
                Text("Forgot Password")
                    .font(.title)
                    .padding()
                
                Text("Enter your email to reset your password.")
                    .font(.body)
                    .padding(.bottom, 20)
                
                TextField("Email", text: .constant(""))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button("Sumbit") { }
                    .font(.custom(outfitRegular, size: 16))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("ColorSecondaryBlack"))
                    .cornerRadius(10)
                    .foregroundStyle(Color(.gray))

            }
            .padding()
        }
    }
}


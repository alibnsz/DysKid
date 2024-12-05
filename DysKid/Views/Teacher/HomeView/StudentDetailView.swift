//
//  StudentDetailView.swift
//  SpecialKids
//
//  Created by Mehmet Ali Bunsuz on 23.11.2024.
//
import SwiftUI
struct StudentDetailView: View {
    let student: Student
    @State private var homeworkTitle = ""
    @State private var homeworkDescription = ""
    @State private var isHomeworkSent = false

    var body: some View {
        VStack {
            Text("Öğrenci Bilgileri")
                .font(.headline)

            Text("Ad: \(student.name)")
            Text("ID: \(student.id)")
            Text("Yaş: \(student.age)")

            Divider()
                .padding(.vertical)

            // Ödev Verme Alanı
            Text("Ödev Ver")
                .font(.headline)

            TextField("Ödev Başlığı", text: $homeworkTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextEditor(text: $homeworkDescription)
                .frame(height: 100)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding()

            Button("Gönder") {
                sendHomework()
            }
            .buttonStyle(.borderedProminent)
            .padding()

            if isHomeworkSent {
                Text("Ödev başarıyla gönderildi!")
                    .foregroundColor(.green)
            }
        }
        .padding()
    }

    private func sendHomework() {
        guard !homeworkTitle.isEmpty, !homeworkDescription.isEmpty else {
            print("Ödev başlığı veya açıklaması boş!")
            return
        }

        // Ödevin ID'si Firebase tarafından otomatik olarak atanacaktır
        let homeworkId = UUID().uuidString  // Ödev ID'si için UUID kullanabilirsiniz
        let dueDate = Date() // Ödevin teslim tarihi olarak şu anki tarihi kullanıyoruz

        let homework = Homework(id: homeworkId, title: homeworkTitle, description: homeworkDescription, dueDate: dueDate, studentId: student.id)

        FirebaseManager.shared.assignHomework(homework: homework) { error in
            if let error = error {
                print("Ödev gönderilirken hata: \(error.localizedDescription)")
            } else {
                isHomeworkSent = true
                homeworkTitle = ""
                homeworkDescription = ""
            }
        }
    }

}

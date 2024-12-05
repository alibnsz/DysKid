//
//  TeacherView.swift
//  DysKid
//
//  Created by Mehmet Ali Bunsuz on 24.11.2024.
//

import SwiftUI

struct TeacherView: View {
    @StateObject private var firebaseManager = FirebaseManager.shared
    @State private var teacherClasses: [SchoolClass] = []
    @State private var selectedClass: SchoolClass?
    @State private var studentsInSelectedClass: [Student] = []
    @State private var showAddClassSheet = false
    @State private var showAddStudentSheet = false
    @State private var newClassName = ""
    @State private var studentIdToAdd = "" // Öğrenci eklemek için ID
    @State private var selectedStudent: Student? // Seçilen öğrenci detaylarını göstermek için

    var body: some View {
        NavigationView {
            VStack {
                Text("Oluşturduğunuz Sınıflar")
                    .font(.headline)

                // Sınıf Listesi
                List(teacherClasses) { schoolClass in
                    Button(action: {
                        selectedClass = schoolClass
                        fetchStudents(for: schoolClass)
                    }) {
                        HStack {
                            Text(schoolClass.name)
                            Spacer()
                            Text("\(schoolClass.students.count) Öğrenci")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }

                // Yeni Sınıf Ekleme Butonu
                Button("Yeni Sınıf Ekle") {
                    showAddClassSheet = true
                }
                .buttonStyle(.borderedProminent)
                .sheet(isPresented: $showAddClassSheet) {
                    VStack(spacing: 20) {
                        Text("Yeni Sınıf Ekle")
                            .font(.headline)

                        TextField("Sınıf Adı", text: $newClassName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()

                        Button("Sınıfı Kaydet") {
                            guard let teacherId = firebaseManager.auth.currentUser?.uid else { return }
                            firebaseManager.createClassForTeacher(teacherId: teacherId, name: newClassName) { error in
                                if let error = error {
                                    print("Hata: \(error.localizedDescription)")
                                } else {
                                    newClassName = ""
                                    showAddClassSheet = false
                                    fetchTeacherClasses() // Listeyi yenile
                                }
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                }

                // Öğrenci Ekleme Butonu
                if selectedClass != nil {
                    Button("Seçili Sınıfa Öğrenci Ekle") {
                        showAddStudentSheet = true
                    }
                    .buttonStyle(.borderedProminent)
                    .sheet(isPresented: $showAddStudentSheet) {
                        VStack(spacing: 20) {
                            Text("Yeni Öğrenci Ekle")
                                .font(.headline)

                            TextField("Öğrenci ID", text: $studentIdToAdd)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()

                            Button("Öğrenci Kaydet") {
                                guard !studentIdToAdd.isEmpty else {
                                    print("Öğrenci ID boş!")
                                    return
                                }

                                // Öğrenci verisini Firebase'den alıyoruz
                                firebaseManager.getStudentById(id: studentIdToAdd) { student in
                                    guard let student = student else {
                                        print("Öğrenci bulunamadı!")
                                        return
                                    }

                                    // Öğrenciyi sınıfa ekliyoruz
                                    if let selectedClass = selectedClass {
                                        firebaseManager.addStudentToClass(classId: selectedClass.id, studentId: student.id) { error in
                                            if let error = error {
                                                print("Hata: \(error.localizedDescription)")
                                            } else {
                                                print("Öğrenci \(student.name) sınıfa eklendi.")
                                                studentIdToAdd = "" // ID'yi sıfırlıyoruz
                                                showAddStudentSheet = false // Öğrenci ekleme sayfasını kapatıyoruz
                                                fetchStudents(for: selectedClass) // Öğrenci listesini güncelliyoruz
                                            }
                                        }
                                    }
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()
                    }
                }

                // Seçilen sınıfın öğrencileri
                if selectedClass != nil {
                    List(studentsInSelectedClass) { student in
                        Button(action: {
                            selectedStudent = student
                        }) {
                            HStack {
                                Text(student.name)
                                Spacer()
                                Text("\(student.id)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .sheet(item: $selectedStudent) { student in
                        StudentDetailView(student: student) // Öğrenci detayı sayfası
                    }
                }
            }
            .padding()
            .onAppear {
                fetchTeacherClasses()
            }
        }
    }

    // MARK: - Öğretmenin Sınıflarını Çekme
    private func fetchTeacherClasses() {
        guard let teacherId = firebaseManager.auth.currentUser?.uid else { return }
        firebaseManager.fetchClassesForTeacher(teacherId: teacherId) { classes, error in
            if let error = error {
                print("Sınıfları yükleme hatası: \(error.localizedDescription)")
            } else if let classes = classes {
                teacherClasses = classes
            }
        }
    }

    // MARK: - Sınıf Öğrencilerini Çekme
    private func fetchStudents(for schoolClass: SchoolClass) {
        firebaseManager.fetchStudentsForClass(classId: schoolClass.id) { students, error in
            if let error = error {
                print("Öğrencileri yükleme hatası: \(error.localizedDescription)")
            } else if let students = students {
                studentsInSelectedClass = students
            }
        }
    }
    
    
}

//
//  FirebaseManager.swift
//  DysKid
//
//  Created by Mehmet Ali Bunsuz on 24.11.2024.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
import FirebaseAppCheck


// MARK: - Firebase Manager
class FirebaseManager: ObservableObject {
    static let shared = FirebaseManager()
    var auth = Auth.auth()
    private var db = Firestore.firestore()

    @Published var currentUserRole: String? = nil
    @Published var isAuthenticated = false
    @Published var classes: [SchoolClass] = []
    @Published var studentIdToAdd: String? = nil

    // MARK: - Sınıf Oluşturma
    func createClass(name: String, completion: @escaping (Error?) -> Void) {
        let newClass = SchoolClass(id: UUID().uuidString, name: name, students: [])
        db.collection("classes").document(newClass.id).setData([
            "id": newClass.id,
            "name": name,
            "students": [] // Boş öğrenci listesi ile başlatıyoruz
        ]) { error in
            DispatchQueue.main.async {
                if error == nil {
                    self.classes.append(newClass) // Yeni sınıfı array'e ekliyoruz
                }
                completion(error)
            }
        }
    }

    // MARK: - Çocukları Al
    func fetchChildren(for parentId: String, completion: @escaping ([Student]?, Error?) -> Void) {
        db.collection("parents").document(parentId).collection("children")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Çocuklar çekilemedi: \(error.localizedDescription)")
                    completion(nil, error)
                } else {
                    let children = snapshot?.documents.compactMap { doc -> Student? in
                        let data = doc.data()
                        print("Çocuk verisi: \(data)") // Çocuk verilerini yazdır
                        guard let id = data["id"] as? String,
                              let name = data["name"] as? String,
                              let age = data["age"] as? Int else { return nil } // Yaş bilgisini ekledik
                        return Student(id: id, name: name, age: age)
                    }
                    completion(children, nil)
                }
            }
    }

    // MARK: - Öğrencinin Velisini Al
    func fetchParentForStudent(studentId: String, completion: @escaping (String?) -> Void) {
        db.collection("parents").whereField("children", arrayContains: studentId).getDocuments { snapshot, error in
            if let error = error {
                print("Veli bulunamadı: \(error.localizedDescription)")
                completion(nil)
                return
            }

            if let documents = snapshot?.documents, let parent = documents.first {
                // İlk veli belgesinin ID'sini alıyoruz
                completion(parent.documentID)
            } else {
                completion(nil)
            }
        }
    }

    // MARK: - Çocuk Ekleme (Parents kısmına da eklenmesi gerek)
    func addChildToParent(userId: String, childId: String, childName: String, age: Int, completion: @escaping (Error?) -> Void) {
        let child = Student(id: childId, name: childName, age: age)
        let childRef = db.collection("parents").document(userId).collection("children").document(childId)
        
        // Çocuğu veritabanına ekliyoruz
        do {
            try childRef.setData(from: child) { error in
                if let error = error {
                    completion(error)
                } else {
                    // Çocuk eklendikten sonra "students" koleksiyonuna da ekliyoruz
                    self.db.collection("students").document(childId).setData([
                        "id": childId,
                        "name": childName,
                        "age": age // Age burada da ekleniyor
                    ]) { error in
                        completion(error)
                    }
                }
            }
        } catch {
            completion(error)
        }
    }    // MARK: - Sınıf Yükleme
    func fetchClasses(completion: @escaping (Error?) -> Void) {
        db.collection("classes").addSnapshotListener { snapshot, error in
            if let error = error {
                completion(error)
                return
            }
            if let documents = snapshot?.documents {
                self.classes = documents.compactMap { try? $0.data(as: SchoolClass.self) }
            }
            completion(nil)
        }
    }
    
    // MARK: - Ödev İşlemleri
    func assignHomework(homework: Homework, completion: @escaping (Error?) -> Void) {
        let homeworkData: [String: Any] = [
            "title": homework.title,
            "description": homework.description,
            "dueDate": Timestamp(date: homework.dueDate) // Ödevin teslim tarihi
        ]
        
        // Öğrenciye ait "homeworks" koleksiyonuna ödev kaydediyoruz
        let homeworkRef = db.collection("students").document(homework.studentId).collection("homeworks")
        
        homeworkRef.addDocument(data: homeworkData) { error in
            completion(error)
        }
    }

    func fetchAssignmentsForStudent(studentId: String, completion: @escaping ([Assignment]?, Error?) -> Void) {
        let db = Firestore.firestore() // Firestore bağlantısı

        db.collection("students").document(studentId).collection("homeworks")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Firebase'den ödev çekme hatası: \(error.localizedDescription)")
                    completion(nil, error)
                    return
                }

                // Gelen verileri Assignment modeline dönüştürüyoruz
                let assignments = snapshot?.documents.compactMap { document -> Assignment? in
                    let data = document.data()
                    guard let title = data["title"] as? String,
                          let description = data["description"] as? String,
                          let dueDateTimestamp = data["dueDate"] as? Timestamp else {
                              return nil
                          }
                    return Assignment(
                        id: document.documentID,
                        title: title,
                        description: description,
                        dueDate: dueDateTimestamp.dateValue(),
                        studentId: studentId // Eksik olan studentId burada eklendi
                    )
                }

                print("Firebase'den çekilen ödevler: \(assignments ?? [])")
                completion(assignments, nil)
            }
    }

    func fetchHomeworks(for parentId: String, completion: @escaping ([Homework]?, Error?) -> Void) {
        // Önce ebeveynin çocuklarını çek
        fetchChildren(for: parentId) { children, error in
            if let error = error {
                completion(nil, error)
            } else if let children = children {
                // Çocukların ID'lerini kontrol et
                let studentIds = children.map { $0.id }
                print("Ebeveynin çocukları: \(studentIds)") // Konsola çocukların ID'lerini yazdır

                var homeworks: [Homework] = []
                let dispatchGroup = DispatchGroup()

                for studentId in studentIds {
                    dispatchGroup.enter()
                    self.fetchAssignmentsForStudent(studentId: studentId) { studentHomeworks, error in
                        if let studentHomeworks = studentHomeworks {
                            homeworks.append(contentsOf: studentHomeworks)
                        }
                        dispatchGroup.leave()
                    }
                }

                dispatchGroup.notify(queue: .main) {
                    print("Ebeveyn için çekilen tüm ödevler: \(homeworks)") // Tüm ödevlerin listesini yazdır
                    completion(homeworks, nil)
                }
            }
        }
    }
    
    // MARK: - Öğrenci Ekleme
    func addStudentToClass(classId: String, studentId: String, completion: @escaping (Error?) -> Void) {
        let classRef = db.collection("classes").document(classId)
        
        // Öğrenci eklenmeden önce mevcut öğrencileri alıp, sonra yeni öğrenci ekliyoruz
        classRef.updateData([
            "students": FieldValue.arrayUnion([studentId])
        ]) { error in
            if error == nil {
                // Sınıfın güncel listesini alıyoruz
                self.fetchClasses { _ in
                    completion(nil)
                }
            } else {
                completion(error)
            }
        }
    }
    
    func fetchClassesForTeacher(teacherId: String, completion: @escaping ([SchoolClass]?, Error?) -> Void) {
        db.collection("teachers").document(teacherId).getDocument { document, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let data = document?.data(),
                  let classIds = data["classes"] as? [String] else {
                completion(nil, nil)
                return
            }

            var fetchedClasses: [SchoolClass] = []
            let group = DispatchGroup()
            for classId in classIds {
                group.enter()
                self.db.collection("classes").document(classId).getDocument { classDoc, error in
                    if let classDoc = classDoc, let schoolClass = try? classDoc.data(as: SchoolClass.self) {
                        fetchedClasses.append(schoolClass)
                    }
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                completion(fetchedClasses, nil)
            }
        }
    }
    
    func createClassForTeacher(teacherId: String, name: String, completion: @escaping (Error?) -> Void) {
        let newClass = SchoolClass(id: UUID().uuidString, name: name, students: [])
        let classRef = db.collection("classes").document(newClass.id)
        let teacherRef = db.collection("teachers").document(teacherId)

        classRef.setData([
            "id": newClass.id,
            "name": name,
            "teacherId": teacherId,
            "students": []
        ]) { error in
            if let error = error {
                completion(error)
                return
            }

            teacherRef.updateData([
                "classes": FieldValue.arrayUnion([newClass.id])
            ]) { error in
                if error == nil {
                    self.classes.append(newClass) // UI için güncelleme
                }
                completion(error)
            }
        }
    }
    
    func fetchStudentsForClass(classId: String, completion: @escaping ([Student]?, Error?) -> Void) {
        db.collection("classes").document(classId).getDocument { document, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let data = document?.data(),
                  let studentIds = data["students"] as? [String] else {
                completion(nil, nil)
                return
            }

            var students: [Student] = []
            let group = DispatchGroup()
            for studentId in studentIds {
                group.enter()
                self.db.collection("students").document(studentId).getDocument { studentDoc, error in
                    if let studentDoc = studentDoc, let student = try? studentDoc.data(as: Student.self) {
                        students.append(student)
                    }
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                completion(students, nil)
            }
        }
    }
    
    func getStudentById(id: String, completion: @escaping (Student?) -> Void) {
        db.collection("students").document(id).getDocument { document, error in
            if let error = error {
                print("Öğrenci verisi alınırken hata oluştu: \(error.localizedDescription)")
                completion(nil)
                return
            }

            if let document = document, document.exists {
                do {
                    let student = try document.data(as: Student.self)
                    completion(student)
                } catch {
                    print("Öğrenci verisi çözümleme hatası: \(error.localizedDescription)")
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
    
    // MARK: - Öğrenci İsmi Getirme
    func getStudentName(by id: String, completion: @escaping (String?) -> Void) {
        db.collection("students").document(id).getDocument { document, error in
            if let error = error {
                print("Öğrenci ismi alınamadı: \(error.localizedDescription)")
                completion(nil)
                return
            }
            if let document = document, document.exists, let student = try? document.data(as: Student.self) {
                completion(student.name)
            } else {
                completion(nil)
            }
        }
    }

    // MARK: - 6 Haneli Öğrenci ID Üretimi
    func generateRandomChildId() -> String {
        return String(format: "%06d", Int.random(in: 0...999999))
    }

    // MARK: - Öğrenci Ekleme
    func addStudent(name: String, age: Int, completion: @escaping (Error?) -> Void) {
        let studentId = generateRandomChildId() // Otomatik 6 haneli ID oluşturuluyor
        let student = Student(id: studentId, name: name, age: age) // Yaş bilgisini de ekliyoruz

        // Öğrenciyi "students" koleksiyonuna kaydediyoruz
        do {
            try db.collection("students").document(studentId).setData(from: student) { error in
                completion(error)
            }
        } catch {
            completion(error)
        }
    }

    func signUp(email: String, password: String, role: String, completion: @escaping (Error?) -> Void) {
        auth.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(error)
                return
            }

            guard let userId = authResult?.user.uid else {
                completion(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı ID'si bulunamadı"]))
                return
            }

            // Rol bilgisine göre Firestore'da kullanıcıyı kaydedelim
            let userRef = self.db.collection(role).document(userId)
            userRef.setData([
                "email": email,
                "role": role
            ]) { error in
                completion(error)
            }
        }
    }
    // MARK: - Giriş Yapma
    func signIn(email: String, password: String, completion: @escaping (Error?) -> Void) {
        auth.signIn(withEmail: email, password: password) { [weak self] _, error in
            if let error = error {
                completion(error)
                return
            }
            self?.fetchCurrentUserRole(completion: completion)
        }
    }

    func fetchCurrentUserRole(completion: @escaping (Error?) -> Void) {
        guard let userId = auth.currentUser?.uid else { return }

        // Öğretmen rolünü kontrol et
        db.collection("teachers").document(userId).getDocument { [weak self] document, error in
            if let error = error {
                completion(error)
                return
            }

            if let document = document, document.exists {
                self?.currentUserRole = "teacher"
                self?.isAuthenticated = true
                completion(nil)
            } else {
                // Veli rolünü kontrol et
                self?.db.collection("parents").document(userId).getDocument { document, error in
                    if let error = error {
                        completion(error)
                        return
                    }

                    if let document = document, document.exists {
                        self?.currentUserRole = "parent"
                        self?.isAuthenticated = true
                        completion(nil)
                    } else {
                        completion(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Rol bulunamadı"]))
                    }
                }
            }
        }
    }

    func signOut() {
        do {
            try auth.signOut()
            DispatchQueue.main.async {
                self.currentUserRole = nil
                self.isAuthenticated = false
            }
        } catch {
            print("Çıkış yapılamadı: \(error.localizedDescription)")
        }
    }
}

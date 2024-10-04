
//
//  Tab.swift
//  DysKid
//
//  Created by Mehmet Ali Bunsuz on 4.10.2024.
//

import SwiftUI

enum TeacherTab: String, CaseIterable {
    case summary = "Özet"
    case students = "Öğrenciler"
    
    // Burada ekranları doğrudan döndürmek için bir property ekliyoruz
    @ViewBuilder
    var view: some View {
        switch self {
        case .summary:
            TaskHome() // Burada TaskHome ekranını getiriyoruz
        case .students:
            TaskHome() // İkinci ekran olarak yine TaskHome ekranını kullanabilirsiniz veya başka bir ekran getirebilirsiniz
        }
    }
}

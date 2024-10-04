//
//  ParentTab.swift
//  DysKid
//
//  Created by Mehmet Ali Bunsuz on 4.10.2024.
//


import SwiftUI

enum ParentTab: String, CaseIterable {
    case summary = "Özet"
    case students = "Ödevler"
    
    // Burada ekranları doğrudan döndürmek için bir property ekliyoruz
    @ViewBuilder
    var view: some View {
        switch self {
        case .summary:
            SummaryView() // Burada TaskHome ekranını getiriyoruz
        case .students:
            SummaryView() // İkinci ekran olarak yine TaskHome ekranını kullanabilirsiniz veya başka bir ekran getirebilirsiniz
        }
    }
}

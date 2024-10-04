//
//  SummaryModel.swift
//  DysKid
//
//  Created by Mehmet Ali Bunsuz on 10.09.2024.
//

import Foundation

struct Report: Identifiable {
    var id = UUID()
    var title: String
    var description: String
    var icon: String
}

class SummaryViewModel: ObservableObject {
    @Published var reports: [Report] = [
        Report(title: "Bugün 45 puan topladı", description: "Sayı Eşleştirme, Hayvan Eşleştirme", icon: "lock.fill"),
        Report(title: "Bugün, 16 dakika oynadı.", description: "Sayı Eşleştirme, Hayvan Eşleştirme", icon: "timer")
    ]
    
    @Published var dailyMinutes: Int = 16
    @Published var streak: Int = 128
    @Published var date: String = "28 Ekim"
}

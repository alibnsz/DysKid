//
//  EducationModel.swift
//  Dyskid
//
//  Created by Mehmet Ali Bunsuz on 11.09.2024.
//
import Foundation

struct EgitimModel: Identifiable {
    let id = UUID()
    let baslik: String
    let aciklama: String
    let detayGorsel: String
    let detayMetin: String
}

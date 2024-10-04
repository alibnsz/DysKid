//
//  EducationDetailView.swift
//  DysKid
//
//  Created by Mehmet Ali Bunsuz on 11.09.2024.
//

import SwiftUI

struct EducationDetailView: View {
    let egitim: EgitimModel
    
    var body: some View {
        ScrollView {
            VStack {
                Image(egitim.detayGorsel)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 300)
                    .cornerRadius(15)
                
                Text(egitim.detayMetin)
                    .padding()
                    .font(.custom(outfitLight, size: 14))
                Text(egitim.detayMetin)
                    .padding()
                    .font(.custom(outfitLight, size: 14))


                Spacer()
            }

        }
    }
}




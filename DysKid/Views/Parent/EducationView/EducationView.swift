//
//  EducationView.swift
//  DysKid
//
//  Created by Mehmet Ali Bunsuz on 11.09.2024.
//

import SwiftUI

struct EducationView: View {
    @ObservedObject var viewModel = EducationViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Eğitim")
                            .font(.custom(outfitThin, size: 36))
                            .foregroundColor(.black)
                    }
                    Divider()
                    ForEach(Array(viewModel.egitimListesi.enumerated()), id: \.element.id) { index, egitim in
                        NavigationLink(destination: EducationDetailView(egitim: egitim)) {
                            VStack(alignment: .leading) {
                                Button(action: {
                                    withAnimation(.snappy(duration: 0.6)) {
                                        viewModel.toggleAciklama(for: index)
                                    }
                                }) {
                                    HStack {
                                        ZStack {
                                            Circle()
                                                .stroke(lineWidth: 1)
                                                .frame(width: 45, height: 45)
                                                .foregroundColor(.black.opacity(0.1))
                                            Image(systemName: "plus")
                                                .foregroundColor(.green)
                                        }
                                        Spacer()
                                        Text(egitim.baslik)
                                            .font(.custom(outfitRegular, size: 16))
                                            .foregroundStyle(Color(.black))
                                    }
                                }
                                
                                if viewModel.aciklamaGoster[index] {
                                    Image(egitim.detayGorsel)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxHeight: 300)
                                        .cornerRadius(15)
                                    Text(egitim.aciklama)
                                        .font(.custom(outfitLight, size: 12))
                                        .padding(.top, 5)
                                        .transition(.opacity.combined(with: .move(edge: .top)))
                                        .animation(.easeInOut(duration: 0.4), value: viewModel.aciklamaGoster[index])
                                }
                                
                                Divider()
                            }
                            .padding()
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    EducationView()
}

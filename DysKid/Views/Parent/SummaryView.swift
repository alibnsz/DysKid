//
//  SummaryView.swift
//  DysKid
//
//  Created by Mehmet Ali Bunsuz on 10.09.2024.
//

import SwiftUI

struct SummaryView: View {
    @ObservedObject var viewModel = SummaryViewModel()
    
    var body: some View {
        VStack {
            // Header
            HStack {
                Text("Ozet")
                    .font(.custom(outfitThin, size: 36)) // Dinamik yazı boyutu
                    
                
                Spacer()
                
                HStack {
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 1)
                            .frame(width: 55, height: 55)
                        .foregroundColor(.black.opacity(0.1))
                        Image(systemName: "person.2")
                    }
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 1)
                            .frame(width: 55, height: 55)
                        .foregroundColor(.black.opacity(0.1))
                        Image(systemName: "bell")

                    }
                    
                }
                .font(.title2)
            }
            
            .padding()
            Divider()
                .padding(.horizontal)

            // Date and Set Goal Button
            HStack {
                VStack(alignment: .leading) {
                    Text("Bugün")
                        .font(.custom(outfitThin, size: 26))
                    Text(viewModel.date)
                        .font(.custom(outfitThin, size: 16))

                }
                Spacer()
                Button(action: {
                    // Hedef belirleme işlemi
                }) {
                    Text("Hedef Belirle")
                        .font(.custom(outfitThin, size: 16))
                        .foregroundStyle(Color(.black))
                        .padding(.vertical, 5)
                        .padding(.horizontal, 15)
                        .background(Color.gray.opacity(0.04))
                        .cornerRadius(20)
                }
            }
            .padding(.horizontal)

            // Circular Progress for Minutes
            VStack {
                ZStack {
                    Circle()
                        .trim(from: 0.0, to: CGFloat(viewModel.dailyMinutes) / 20)
                        .stroke(Color.blue, lineWidth: 10)
                        .rotationEffect(.degrees(-90))
                        .frame(width: 100, height: 100)
                    
                    VStack {
                        Text("\(viewModel.dailyMinutes)")
                            .font(.custom(outfitBold, size: 26))
                        Text("Dakika")
                            .font(.custom(outfitThin, size: 16))

                    }
                }
                .padding(.vertical)
                
                Text("128 Günlük Seri")
                    .font(.custom(outfitLight, size: 26))
                Text("Seriyi korumak için çocuğunuzun her gün verilen görevleri tamamlaması gerekir.")
                    .font(.custom(outfitThin, size: 12))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            Divider()
                .padding(.horizontal)

            // Report List
            VStack(alignment: .leading) {
                Text("Rapor")
                    .font(.custom(outfitThin, size: 26))
                ForEach(viewModel.reports) { report in
                    HStack {
                        Image(systemName: report.icon)
                            .font(.custom(outfitThin, size: 16))
                            .padding(.trailing)
                        VStack(alignment: .leading) {
                            Text(report.title)
                                .font(.custom(outfitThin, size: 16))
                            Text(report.description)
                                .font(.custom(outfitThin, size: 12))
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
            }
            .padding()
            
            Spacer()

        }
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView()
    }
}

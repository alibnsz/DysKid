//
//  EducationViewModel.swift
//  Dyskid
//
//  Created by Mehmet Ali Bunsuz on 11.09.2024.
//
import Foundation

class EducationViewModel: ObservableObject {
    @Published var egitimListesi: [EgitimModel]
    @Published var secilenEgitim: EgitimModel?
    @Published var aciklamaGoster: [Bool]
    
    init() {
        // Önce egitimListesi başlatılıyor
        let egitimler = [
            EgitimModel(baslik: "DEHB'nin Öğrenme Üzerindeki Etkisi",
                        aciklama: "Dikkat Eksikliği ve Hiperaktivite Bozukluğu (DEHB), çocukların öğrenme sürecini olumsuz yönde etkileyebilen bir durumdur...",
                        detayGorsel: "adhd",
                        detayMetin: "ADHD, çocukların dikkatlerini toplamada, hareketlerini kontrol etmede ve organizasyon becerilerini geliştirmede zorluk çekmesine neden olan bir nörolojik durumdur. Bu durum, çocuğun akademik başarılarını, sosyal ilişkilerini ve genel yaşam kalitesini etkileyebilir. Çocuğunuzun ADHD ile başa çıkabilmesi için sabırlı, destekleyici ve yapılandırılmış bir ortam sunmak çok önemlidir. Eğitim ve davranışsal stratejiler, aile desteği ve gerektiğinde profesyonel yardım, çocuğunuzun güçlü yönlerini geliştirmesine ve zorluklarını aşmasına yardımcı olabilir. Unutmayın ki, ADHD'li çocuklar yaratıcı, enerjik ve güçlü birer birey olabilirler; onlara güven ve anlayışla yaklaşmak, gelişimlerini olumlu yönde destekleyecektir."),
            EgitimModel(baslik: "DEHB'nin Öğrenme Üzerindeki Etkisi",
                        aciklama: "Dikkat Eksikliği ve Hiperaktivite Bozukluğu (DEHB), çocukların öğrenme sürecini olumsuz yönde etkileyebilen bir durumdur...",
                        detayGorsel: "adhd",
                        detayMetin: "Dikkat eksikliği ve hiperaktivite bozukluğu (DEHB)..."),
            EgitimModel(baslik: "DEHB'nin Öğrenme Üzerindeki Etkisi",
                        aciklama: "Dikkat Eksikliği ve Hiperaktivite Bozukluğu (DEHB), çocukların öğrenme sürecini olumsuz yönde etkileyebilen bir durumdur...",
                        detayGorsel: "adhd",
                        detayMetin: "Dikkat eksikliği ve hiperaktivite bozukluğu (DEHB)..."),
            EgitimModel(baslik: "DEHB'nin Öğrenme Üzerindeki Etkisi",
                        aciklama: "Dikkat Eksikliği ve Hiperaktivite Bozukluğu (DEHB), çocukların öğrenme sürecini olumsuz yönde etkileyebilen bir durumdur...",
                        detayGorsel: "adhd",
                        detayMetin: "Dikkat eksikliği ve hiperaktivite bozukluğu (DEHB)..."),
            EgitimModel(baslik: "DEHB'nin Öğrenme Üzerindeki Etkisi",
                        aciklama: "Dikkat Eksikliği ve Hiperaktivite Bozukluğu (DEHB), çocukların öğrenme sürecini olumsuz yönde etkileyebilen bir durumdur...",
                        detayGorsel: "adhd",
                        detayMetin: "Dikkat eksikliği ve hiperaktivite bozukluğu (DEHB)..."),
            EgitimModel(baslik: "DEHB'nin Öğrenme Üzerindeki Etkisi",
                        aciklama: "Dikkat Eksikliği ve Hiperaktivite Bozukluğu (DEHB), çocukların öğrenme sürecini olumsuz yönde etkileyebilen bir durumdur...",
                        detayGorsel: "adhd",
                        detayMetin: "Dikkat eksikliği ve hiperaktivite bozukluğu (DEHB)..."),
            EgitimModel(baslik: "DEHB'nin Öğrenme Üzerindeki Etkisi",
                        aciklama: "Dikkat Eksikliği ve Hiperaktivite Bozukluğu (DEHB), çocukların öğrenme sürecini olumsuz yönde etkileyebilen bir durumdur...",
                        detayGorsel: "adhd",
                        detayMetin: "Dikkat eksikliği ve hiperaktivite bozukluğu (DEHB)..."),
            EgitimModel(baslik: "DEHB'nin Öğrenme Üzerindeki Etkisi",
                        aciklama: "Dikkat Eksikliği ve Hiperaktivite Bozukluğu (DEHB), çocukların öğrenme sürecini olumsuz yönde etkileyebilen bir durumdur...",
                        detayGorsel: "adhd",
                        detayMetin: "Dikkat eksikliği ve hiperaktivite bozukluğu (DEHB)..."),
            // Diğer içerikler de eklenir.
        ]
        
        self.egitimListesi = egitimler
        
        // Daha sonra egitimListesi'nin boyutuna göre aciklamaGoster dizisi başlatılıyor
        self.aciklamaGoster = Array(repeating: false, count: egitimler.count)
    }
    
    func toggleAciklama(for index: Int) {
        aciklamaGoster[index].toggle()
    }
    
    func egitimSec(_ egitim: EgitimModel) {
        secilenEgitim = egitim
    }
}



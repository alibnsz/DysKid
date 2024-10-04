//
//  ParentHomeView.swift
//  DysKid
//
//  Created by Mehmet Ali Bunsuz on 4.10.2024.
//

//
//  TeacherHomeView.swift
//  DysKid
//
//  Created by Mehmet Ali Bunsuz on 4.10.2024.
//

import SwiftUI
import FirebaseAuth

struct ParentHomeView: View {
    
    @State private var activeTab: ParentTab = .summary
    var offsetObserverParent = PageOffsetObserverParent()
    
    var body: some View {
        VStack(spacing: 15) {
            VStack {
                ParentHeaderView()
                TabbarParent(.gray)
                    .overlay{
                        if let collectionViewBounds = offsetObserverParent.collectionView?.bounds {
                            GeometryReader {
                                let width = $0.size.width
                                let tabCount = CGFloat(TeacherTab.allCases.count)
                                let  capsuleWidth = width / tabCount
                                let progress = offsetObserverParent.offset / collectionViewBounds.width
                                
                                Capsule()
                                    .fill(.white)
                                    .shadow(color: .black.opacity(0.05), radius: 5, x: 5, y: 5)
                                    .shadow(color: .black.opacity(0.05), radius: 5, x: -5, y: -5)
                                    .frame(width: capsuleWidth)
                                    .offset(x: progress * capsuleWidth)
                                
                                TabbarParent(.white, .semibold)
                                    .mask(alignment: .leading) {
                                        Capsule()
                                            .frame(width: capsuleWidth)
                                            .offset(x: progress * capsuleWidth)
                                    }
                            }
                        }
                    }
                    .background(.gray.opacity(0.03))
                    .clipShape(.capsule)
                    .shadow(color: .gray.opacity(0.1), radius: 5, x: 5, y: 5)
                    .shadow(color: .gray.opacity(0.05), radius: 5, x: -5, y: -5)
                    .padding([.horizontal, .top], 15)
                
                TabView(selection: $activeTab) {
                    ForEach(ParentTab.allCases, id: \.rawValue) { tab in
                        tab.view
                            .tag(tab)
                            .background{
                                if !offsetObserverParent.isObserving {
                                    findCollectionView{
                                        offsetObserverParent.collectionView = $0
                                        offsetObserverParent.observe()
                                    }
                                }
                            }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
            }
        }
    }
    
    @ViewBuilder
    func TabbarParent(_ tint : Color, _ weight: Font.Weight = .regular) -> some View {
        HStack(spacing: 0) {
            ForEach(ParentTab.allCases, id: \.rawValue) { tab in
                Text(tab.rawValue)
                    .font(.callout)
                    .fontWeight(weight)
                    .foregroundStyle(.gray)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .contentShape(.rect)
                    .onTapGesture {
                        withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                            activeTab = tab
                        }
                    }
            }
            
        }
    }
}

@ViewBuilder
func ParentHeaderView() -> some View {
    HStack {
        VStack(alignment: .leading) {
            Text("Hoşgeldin,")
                .font(.custom(outfitRegular, size: 20))
                .foregroundColor(.gray)
            
            Text("Mehmet")
                .font(.custom(outfitRegular, size: 32))
                .foregroundColor(.black)
        }
        .padding(.leading)

        Spacer()

        Image(systemName: "bell")
            .resizable()
            .frame(width: 24, height: 24)
            .padding(.trailing)
            .foregroundColor(.gray)
            .onTapGesture {
                // Firebase'den çıkış işlemi
                do {
                    try Auth.auth().signOut() // Firebase'den çıkış yap
                    // Yönlendirme işlemi
                    // Burada kullanıcının yönlendirileceği sayfayı belirtin
                    // Örneğin, bir state değişkeni kullanarak yönlendirebilirsiniz
                } catch {
                    print("Çıkış yaparken hata oluştu: \(error.localizedDescription)")
                }
            }
    }
}



@Observable
class PageOffsetObserverParent: NSObject{
    var collectionView: UICollectionView?
    var offset: CGFloat = 0
    private(set) var isObserving: Bool = false
    
    deinit {
        remove()
    }
    
    func observe(){
        guard !isObserving else { return }
        collectionView?.addObserver(self, forKeyPath: "contentOffset", context: nil)
        isObserving = true
    }
    
    func remove(){
        isObserving = false
        collectionView?.removeObserver(self, forKeyPath: "contentOffset")
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "contentOffset" else { return }
        if let contentOffset = (object as? UICollectionView)?.contentOffset {
            offset = contentOffset.x
        }
    }
    
}

struct findCollectionViewParent: UIViewRepresentable {
    var result: (UICollectionView) -> ()
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if let collectionView = view.collectionSuperView {
                result(collectionView)
            }
            
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

extension UIView {
     var collectionSuperViewParent: UICollectionView? {
        if let collectionView = superview as? UICollectionView {
             return collectionView
         }
         return superview?.collectionSuperView
    }
}


#Preview {
    ParentHomeView()
}

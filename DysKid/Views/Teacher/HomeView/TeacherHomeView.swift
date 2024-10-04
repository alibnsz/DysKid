//
//  TeacherHomeView.swift
//  DysKid
//
//  Created by Mehmet Ali Bunsuz on 4.10.2024.
//

import SwiftUI

struct HomeView: View {
    
    @State private var activeTab: TeacherTab = .summary
    var offsetObserver = PageOffsetObserver()
    
    var body: some View {
        VStack(spacing: 15) {
            VStack {
                HeaderView()
                Tabbar(.gray)
                    .overlay{
                        if let collectionViewBounds = offsetObserver.collectionView?.bounds {
                            GeometryReader {
                                let width = $0.size.width
                                let tabCount = CGFloat(TeacherTab.allCases.count)
                                let  capsuleWidth = width / tabCount
                                let progress = offsetObserver.offset / collectionViewBounds.width
                                
                                Capsule()
                                    .fill(.white)
                                    .shadow(color: .black.opacity(0.05), radius: 5, x: 5, y: 5)
                                    .shadow(color: .black.opacity(0.05), radius: 5, x: -5, y: -5)
                                    .frame(width: capsuleWidth)
                                    .offset(x: progress * capsuleWidth)
                                
                                Tabbar(.white, .semibold)
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
                    ForEach(TeacherTab.allCases, id: \.rawValue) { tab in
                        tab.view
                            .tag(tab)
                            .background{
                                if !offsetObserver.isObserving {
                                    findCollectionView{
                                        offsetObserver.collectionView = $0
                                        offsetObserver.observe()
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
    func Tabbar(_ tint : Color, _ weight: Font.Weight = .regular) -> some View {
        HStack(spacing: 0) {
            ForEach(TeacherTab.allCases, id: \.rawValue) { tab in
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
func HeaderView() -> some View {
    HStack {
        VStack(alignment: .leading) {
            Text("Hoşgeldin,")
                .font(.custom(outfitRegular, size: 20))
                .foregroundColor(.gray)
            
            Text("Mehmet Ali")
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
    }
}



@Observable
class PageOffsetObserver: NSObject{
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

struct findCollectionView: UIViewRepresentable {
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
     var collectionSuperView: UICollectionView? {
        if let collectionView = superview as? UICollectionView {
             return collectionView
         }
         return superview?.collectionSuperView
    }
}




// Önizleme için
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

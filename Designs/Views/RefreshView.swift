//
//  RefreshView.swift
//  Designs
//
//  Created by Juan Camilo Marín Ochoa on 23/04/23.
//

import SwiftUI

private enum RefreshConstants {
    static let cleanSpace: CGFloat = 100
    static let circleRadius: CGFloat = 38
    
    // Dado que nuestro tamaño máximo de actualización es 100, para colocarlo en el medio, entonces
    // El desplazamiento será -> RefreshConstants.cleanSpace/2 = 50
    // Radio del circulo -> RefreshConstants.circleRadius/2 = 19
    // Total -> 50 + 19 = 69
    static let circlePosition: CGFloat = 69
}

struct RefreshView<Content: View>: View {
    let content: Content
    let onRefresh: () async -> ()
    
    init(@ViewBuilder content: @escaping () -> Content, onRefresh: @escaping ()async -> ()){
        self.content = content()
        self.onRefresh = onRefresh
    }
    
    @StateObject var scrollDelegate: ScrollViewModel = .init()
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(.clear)
                    .frame(height: RefreshConstants.cleanSpace * scrollDelegate.progress)
                
                content
            }
            .offset(coordinateSpace: "SCROLL") { offset in
                scrollDelegate.contentOffset = offset
                
                // Detiene el progreso cuando se puede actualizar
                if !scrollDelegate.isEligible {
                    var progress = offset / RefreshConstants.cleanSpace
                    progress = (progress < 0 ? 0 : progress)
                    progress = (progress > 1 ? 1 : progress)
                    scrollDelegate.scrollOffset = offset
                    scrollDelegate.progress = progress
                }
                
                if scrollDelegate.isEligible && !scrollDelegate.isRefreshing{
                    scrollDelegate.isRefreshing = true
                    
                    // Retroalimentación háptica (vibración)
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
            }
        }
        .overlay(alignment: .top, content: {
            EmptyView()
                .overlay(alignment: .top, content: {
                    Canvas { context, size in
                        context.addFilter(.alphaThreshold(min: 0.5, color: .black))
                        context.addFilter(.blur(radius: 10))
                        
                        context.drawLayer { ctx in
                            for index in [1,2]{
                                if let resolvedView = context.resolveSymbol(id: index){
                                    // Desplazamiento de isla dinámica -> 11
                                    // Radio del circulo -> 38/2 -> 14
                                    // Total -> 11 + 14 -> 30
                                    ctx.draw(resolvedView, at: CGPoint(x: size.width / 2, y: 30))
                                }
                            }
                        }
                    } symbols: {
                        if hasDynamicIsland() {
                            Capsule()
                                .fill(.black)
                                .frame(width: 126, height: 37.33)
                                .tag(1)
                        }
                        
                        CanvasSymbol()
                            .tag(2)
                    }
                    .allowsHitTesting(false)
                })
                .overlay(alignment: .top, content: {
                    RefreshView()
                    // Altura de la isla dinamica
                        .offset(y: 11)
                })
                .ignoresSafeArea()
        })
        .coordinateSpace(name: "SCROLL")
        .onAppear(perform: scrollDelegate.addGesture)
        .onDisappear(perform: scrollDelegate.removeGesture)
        .onChange(of: scrollDelegate.isRefreshing) { newValue in
            // MARK: Calling Async Method
            if newValue{
                Task{
                    // MARK: 1 Sec Sleep For Smooth Animation
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    await onRefresh()
                    // MARK: After Refresh Done Resetting Properties
                    withAnimation(.easeInOut(duration: 0.25)){
                        scrollDelegate.progress = 0
                        scrollDelegate.isEligible = false
                        scrollDelegate.isRefreshing = false
                        scrollDelegate.scrollOffset = 0
                    }
                }
            }
        }
    }
    
    func CanvasSymbol() -> some View {
        let centerOffset = scrollDelegate.isEligible ? (scrollDelegate.contentOffset > RefreshConstants.circlePosition ? scrollDelegate.contentOffset : RefreshConstants.circlePosition) : scrollDelegate.scrollOffset
        
        let offset = scrollDelegate.scrollOffset > 0 ? centerOffset : 0
        let scaling = ((scrollDelegate.progress / 1) * 0.21)
        
        var size: Double
        var multiplier: Double
        
        if scrollDelegate.progress > 0 {
            if scrollDelegate.scrollOffset <= 47 {
                multiplier = scrollDelegate.scrollOffset
            } else {
                multiplier = 47
            }
            
            size = multiplier * 1
        } else {
            size = 0
        }
        
        return Circle()
            .fill(.black)
            .frame(width: size, height: size)
            .scaleEffect(0.79 + scaling,anchor: .center)
            .offset(y: offset)
    }
    
    private func hasDynamicIsland() -> Bool {
        UIDevice.current.name.contains("iPhone 14 Pro")
    }
    
    @ViewBuilder
    func RefreshView() -> some View {
        let centerOffset = scrollDelegate.isEligible ? (scrollDelegate.contentOffset > 69 ? scrollDelegate.contentOffset : 69) : scrollDelegate.scrollOffset
        let offset = scrollDelegate.scrollOffset > 0 ? centerOffset : 0
        
        ZStack {
            Image(systemName: "arrow.down")
                .foregroundColor(.white)
                .frame(width: RefreshConstants.circleRadius, height: RefreshConstants.circleRadius)
                .rotationEffect(.init(degrees: scrollDelegate.progress * 180))
                .opacity(scrollDelegate.isEligible ? 0 : 1)
            
            ProgressView()
                .tint(.white)
                .frame(width: RefreshConstants.circleRadius, height: RefreshConstants.circleRadius)
                .opacity(scrollDelegate.isEligible ? 1 : 0)
        }
        .animation(.easeInOut(duration: 0.25), value: scrollDelegate.isEligible)
        .opacity(scrollDelegate.progress)
        .offset(y: offset)
    }
}

class ScrollViewModel: NSObject, ObservableObject, UIGestureRecognizerDelegate {
    // MARK: Properties
    @Published var isEligible: Bool = false
    @Published var isRefreshing: Bool = false
    
    // MARK: Offsets and Progress
    @Published var scrollOffset: CGFloat = 0
    @Published var contentOffset: CGFloat = 0
    @Published var progress: CGFloat = 0
    let gestureID = UUID().uuidString
    
    // MARK: Since We need to Know when the user Left the Screen to Start Refresh
    // Adding Pan Gesture To UI Main Application Window
    // With Simultaneous Gesture Desture
    // Thus it Wont disturb SwiftUI Scroll's And Gesture's
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: Adding Gesture
    func addGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onGestureChange(gesture:)))
        panGesture.delegate = self
        panGesture.name = gestureID
        
        rootController().view.addGestureRecognizer(panGesture)
    }
    
    // MARK: Removing When Leaving The View
    func removeGesture() {
        rootController().view.gestureRecognizers?.removeAll(where: { gesture in
            gesture.name == gestureID
        })
    }
    
    // MARK: Finding Root Controller
    func rootController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else{
            return .init()
        }
        
        return root
    }
    
    @objc
    func onGestureChange(gesture: UIPanGestureRecognizer) {
        if gesture.state == .cancelled || gesture.state == .ended{
            // MARK: Your Max Duration Goes Here
            if !isRefreshing{
                if scrollOffset > RefreshConstants.cleanSpace {
                    isEligible = true
                } else {
                    isEligible = false
                }
            }
        }
    }
}

// MARK: Offset Modifier
extension View {
    @ViewBuilder
    func offset(coordinateSpace: String, offset: @escaping (CGFloat) -> ()) -> some View {
        self
            .overlay {
                GeometryReader{proxy in
                    let minY = proxy.frame(in: .named(coordinateSpace)).minY
                    
                    Color.clear
                        .preference(key: OffsetKey.self, value: minY)
                        .onPreferenceChange(OffsetKey.self) { value in
                            offset(value)
                        }
                }
            }
    }
}

// MARK: Offset Preference Key
struct OffsetKey: PreferenceKey{
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct CustomRefreshView_Previews: PreviewProvider {
    static var previews: some View {
        RefreshView() {
            VStack{
                Rectangle()
                    .fill(.blue)
                    .frame(height: 300)
                
                Rectangle()
                    .fill(.orange)
                    .frame(height: 300)
            }
        } onRefresh: {}
    }
}

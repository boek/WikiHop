////
////  SwiftUIView.swift
////  
////
////  Created by Dan Stepanov on 8/6/23.
////
//
//import SwiftUI
//
//struct HasWonView: View {
//    @State var showModal = true
//    @State var showToast = false
//    var body: some View {
//        VStack {
//            Text("Wiki end page here").padding()
//            Button(action: {
//                showModal = true
//            }) {
//                Text("Show modal")
//            }
//        }
//        .padding()
//        .sheet(isPresented: $showModal, onDismiss: {
//            showModal = false
//        }) {
//            HasWonModal(showToast: $showToast)
//        }
//        
//    }
//    
//    
//}
//
//struct HasWonModal: View {
//    @Binding var showToast: Bool
//    var body: some View {
//        let clicks = 5
//        let shareText = "Barbie -> Oppenheimer took me \(clicks) clicks, https://wikihop.app"
//        
//        VStack {
//            Text("You did it")
//            Text("It only took you...\(clicks) clicks").padding()
//            Button(action: {
//                UIPasteboard.general.string = shareText
//                showToast = true
//                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                    showToast = false
//                }
//            }) {
//                Text("Share")
//            }
//            
//        }
//        .padding()
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .toast(isPresented: $showToast)
//    }
//}
//
//extension View {
//    func toast(isPresented: Binding<Bool>) -> some View {
//        self.modifier(ToastModifier(isPresented: isPresented))
//    }
//}
//
//struct ToastModifier: ViewModifier {
//    @Binding var isPresented: Bool
//    
//    func body(content: Content) -> some View {
//        ZStack(alignment: .top) {
//            content
//
//            if isPresented {
//                ToastView().transition(.move(edge: .top))
//            }
//        }
//        .animation(.easeInOut(duration: 0.3), value: isPresented)
//    }
//    
//}
//
//struct ToastView: View {
//    var body: some View {
//        Text("Copied to clipboard 🎉")
//            .foregroundColor(.white)
//            .padding()
//            .background(Color.black.opacity(0.7))
//            .cornerRadius(10)
//        
//    }
//}
//
//struct HasWonView_Previews: PreviewProvider {
//    static var previews: some View {
//        HasWonView()
//    }
//}

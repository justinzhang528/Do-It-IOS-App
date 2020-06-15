//
//  SplashView.swift
//  DoIt
//
//  Created by 張維俊 on 2020/6/14.
//  Copyright © 2020 NTUT. All rights reserved.
//

import SwiftUI

struct SplashView: View {
    
    @State var isActive:Bool = false
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var body: some View {
        VStack {
            if self.isActive {
                ListView().environment(\.managedObjectContext, managedObjectContext)
            } else {
                VStack{
                    HStack{
                        Image(systemName: "bell.circle").resizable().frame(width:40, height:40).padding()
                        Image(systemName: "clock").resizable().frame(width:40, height:40).padding()
                        Image(systemName: "calendar").resizable().frame(width:40, height:40).padding()
                        Image(systemName: "doc.text").resizable().frame(width:30, height:40).padding()
                    }.padding()
                    Image("icon").resizable().frame(width:180, height:180)
                    Text("DO IT").font(.system(size: 50)).foregroundColor(Color.primary)
                    Text("MAKE THINGS HAPPEN ").font(Font.headline).foregroundColor(Color.primary)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
    
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}

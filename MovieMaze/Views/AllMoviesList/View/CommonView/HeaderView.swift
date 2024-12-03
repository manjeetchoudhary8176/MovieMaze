//
//  HeaderView.swift
//  MovieMaze
//
//  Created by manjeet kumar on 02/12/24.
//

import SwiftUI

struct HeaderView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    var title: String
    
    var body: some View {
        HStack(alignment: .bottom) {
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(.black)
                    .frame(width: 40, height: 40, alignment: .center)
            }
            
            Spacer()
            Text(title)
                .frame(height: 40, alignment: .center)
                .font(.headline)
                .foregroundColor(.black)
                .lineLimit(1)
                
            Spacer()
            
            Button(action: {}) {}
                .frame(width: 40, height: 40, alignment: .center)
        }
        .frame(height: 90, alignment: .bottom)
        .background(.white)
      }
   }

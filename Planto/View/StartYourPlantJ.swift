//
//  SwiftUIView.swift
//  Planto
//
//  Created by Lamya on 09/11/2026.
//
import SwiftUI

// العنوان والخط الفاصل
struct PlantsHeader: View {
    var body: some View {
        VStack(spacing: 0) {
            Text("My Plants 🌱")
                .font(.system(size: 34,
                              weight: .bold))              .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 12)
            
            Divider()
        }
    }
}

// صفحة البداية
struct StartYourPlantJView: View {
    @ObservedObject var viewModel: PlantViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            
            VStack(spacing: 16) {
                Image("Plant")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                
                Text("Start your plant journey!")
                    .font(.headline)
                    .foregroundStyle(.white)
                
                Text("Now all your plants will be in one place and we will help you take care of them :)🪴")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)
            
            Spacer()
            
            Button {
                viewModel.openAdd()
            } label: {
                Text("Set Plant Reminder")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color("PlantGreen"), in: Capsule())
            }
            .padding(.horizontal, 60)
            .padding(.bottom, 200)
        }
    }
}

#Preview {
    StartYourPlantJView(viewModel: PlantViewModel())
        .preferredColorScheme(.dark)
}
//.glassEffect(.regular.tint(Color("buttonColor"))
//    .interactive())


import SwiftUI

@main
struct PlantoApp: App {
    @StateObject private var viewModel = PlantViewModel()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    PlantsHeader()
                    
                    if viewModel.plants.isEmpty && !viewModel.hasStarted {
                        StartYourPlantJView(viewModel: viewModel)
                    } else if viewModel.plants.isEmpty {
                        noRemindersPage
                    } else if viewModel.allWatered {
                        allDonePage
                    } else {
                        TodayReminderView(viewModel: viewModel)
                    }
                }
            }
            .overlay(alignment: .bottomTrailing) {
                if viewModel.hasStarted {
                    plusButton
                }
            }
            .sheet(isPresented: $viewModel.showSheet, onDismiss: {
                viewModel.resetForm()
            }) {
                SetReminderView(viewModel: viewModel)
            }
            .preferredColorScheme(.dark)
        }
    }
    
    // MARK: - ما فيه تذكيرات
    var noRemindersPage: some View {
        Text("No reminders set yet..")
            .font(.system(size: 20))
            .foregroundStyle(.gray)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - كلها انسقت (اضغطي عليها لترجع العلامات فاضية)
    var allDonePage: some View {
        VStack(spacing: 12) {
            Image("Plant")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            
            Text("All Done! 🎉")
                .font(.headline)
                .foregroundStyle(.white)
            
            Text("All Reminders Completed")
                .font(.caption)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.resetWatered()
        }
    }
    
    // MARK: - زر +
    var plusButton: some View {
        Button {
            viewModel.openAdd()
        } label: {
            Image(systemName: "plus")
                .font(.title3.bold())
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
        }
        .glassEffect(.regular.tint(Color("PlantGreen")).interactive(), in: .circle)
        .padding(.trailing, 24)
        .padding(.bottom, 24)
    }
}

//
//  TodayReminder.swift
//  Planto
//
//  Created by Lamya on 15/11/2026.
//
import SwiftUI

// صف نبتة واحدة
struct PlantRow: View {
    let plant: Plant
    let viewModel: PlantViewModel

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Button {
                viewModel.toggleWatered(plant)
            } label: {
                Image(systemName: plant.isWatered ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(plant.isWatered ? .mint : .gray)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 4) {
                    Image(systemName: "location")
                    Text("in \(plant.room.rawValue)")
                }
                .font(.caption2)
                .foregroundStyle(.gray)

                Text(plant.name)
                    .font(.title3)
                    .foregroundStyle(plant.isWatered ? .gray : .white)

                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "sun.max")
                        Text(plant.light.rawValue)
                    }
                    HStack(spacing: 4) {
                        Image(systemName: "drop")
                        Text(plant.waterAmount.rawValue)
                    }
                }
                .font(.caption2)
                .foregroundStyle(.gray)
            }

            Spacer()
        }
        .padding(.vertical, 8)
    }
}

// صفحة القائمة
struct TodayReminderView: View {
    @ObservedObject var viewModel: PlantViewModel

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                Text(viewModel.progressMessage)
                    .font(.system(size: 18))
                    .foregroundStyle(.white)

                ProgressView(value: viewModel.progress)
                    .tint(Color("PlantGreen"))
                    .animation(.easeInOut, value: viewModel.progress)
            }
            .padding(20)

            List {
                ForEach(viewModel.plants) { plant in
                    PlantRow(plant: plant, viewModel: viewModel)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.openEdit(plant)
                        }
                        .listRowBackground(Color.black)
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.deletePlant(plant)
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                }
            }
            .listStyle(.plain)
        }
    }
}

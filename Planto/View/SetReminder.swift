//
//  SetReminder.swift
//  Planto
//
//  Created by Lamya on 15/11/2026.
//
import SwiftUI

struct SetReminderView: View {
    @ObservedObject var viewModel: PlantViewModel

    var body: some View {
        NavigationStack {
            Form {
                // اسم النبتة
                Section {
                    HStack {
                        Text("Plant Name")
                        TextField("Pothos", text: $viewModel.name)
                    }
                }

                // الغرفة والإضاءة
                Section {
                    Picker(selection: $viewModel.room) {
                        ForEach(Room.allCases) { item in
                            Text(item.rawValue).tag(item)
                        }
                    } label: {
                        Label("Room", systemImage: "location")
                            .foregroundStyle(.white)
                    }

                    Picker(selection: $viewModel.light) {
                        ForEach(Light.allCases) { item in
                            Text(item.rawValue).tag(item)
                        }
                    } label: {
                        Label("Light", systemImage: "sun.max")
                            .foregroundStyle(.white)
                    }
                }

                // أيام السقي وكمية الماء
                Section {
                    Picker(selection: $viewModel.wateringDays) {
                        ForEach(WateringDays.allCases) { item in
                            Text(item.rawValue).tag(item)
                        }
                    } label: {
                        Label("Watering Days", systemImage: "drop")
                            .foregroundStyle(.white)
                    }

                    Picker(selection: $viewModel.waterAmount) {
                        ForEach(Water.allCases) { item in
                            Text(item.rawValue).tag(item)
                        }
                    } label: {
                        Label("Water", systemImage: "drop")
                            .foregroundStyle(.white)
                    }
                }

                // زر الحذف (وقت التعديل فقط)
                if viewModel.plantToEdit != nil {
                    Section {
                        Button(role: .destructive) {
                            viewModel.deleteEditingPlant()
                        } label: {
                            Text("Delete Reminder")
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            .navigationTitle("Set Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .close) {
                        viewModel.showSheet = false
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button(role: .confirm) {
                        viewModel.savePlant()
                    }
                    .tint(Color("PlantGreen"))
                    .disabled(viewModel.name.isEmpty)
                }
            }
        }
    }
}

#Preview {
    SetReminderView(viewModel: PlantViewModel())
        .preferredColorScheme(.dark)
}

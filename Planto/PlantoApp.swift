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
                    header

                    if viewModel.plants.isEmpty && !viewModel.hasStarted {
                        startPage
                    } else if viewModel.plants.isEmpty {
                        noRemindersPage
                    } else if viewModel.allWatered {
                        allDonePage
                    } else {
                        listPage
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
                setReminderSheet
            }
            .preferredColorScheme(.dark)
        }
    }

    // MARK: - العنوان
    var header: some View {
        VStack(spacing: 0) {
            Text("My Plants 🌱")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 12)

            Divider()
        }
    }

    // MARK: - صفحة البداية
    var startPage: some View {
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
            .padding(.bottom, 100)
        }
    }

    // MARK: - ما فيه تذكيرات
    var noRemindersPage: some View {
        Text("No reminders set yet..")
            .font(.caption)
            .foregroundStyle(.gray)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - كلها انسقت
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
    }

    // MARK: - قائمة النباتات
    var listPage: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                Text(viewModel.progressMessage)
                    .font(.footnote)
                    .foregroundStyle(.white)

                ProgressView(value: viewModel.progress)
                    .tint(Color("PlantGreen"))
                    .animation(.easeInOut, value: viewModel.progress)
            }
            .padding(20)

            List {
                ForEach(viewModel.plants) { plant in
                    plantRow(plant)
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
            .scrollContentBackground(.hidden)
        }
    }

    // MARK: - صف نبتة
    func plantRow(_ plant: Plant) -> some View {
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
                    .foregroundStyle(Color("LightColor"))

                    HStack(spacing: 4) {
                        Image(systemName: "drop")
                        Text(plant.waterAmount.rawValue)
                    }
                    .foregroundStyle(Color("Watering"))
                }
                .font(.caption2)
            }

            Spacer()
        }
        .padding(.vertical, 8)
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
                .background(Color("PlantGreen"), in: Circle())
        }
        .padding(.trailing, 24)
        .padding(.bottom, 24)
    }

    // MARK: - الشيت (Set Reminder)
    var setReminderSheet: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Text("Plant Name")
                        TextField("Pothos", text: $viewModel.name)
                    }
                }

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

//
//  PlantoViewModel.swift
//  Planto
//
//  Created by Lamya on 12/11/2026.
//
import SwiftUI
import Combine
import UserNotifications

class PlantViewModel: ObservableObject {
    // البيانات
    @Published var plants: [Plant] = []
    @Published var plantToEdit: Plant?
    @Published var showSheet = false
    @Published var hasStarted = false

    // حقول الفورم
    @Published var name = ""
    @Published var room: Room = .bedroom
    @Published var light: Light = .fullSun
    @Published var wateringDays: WateringDays = .everyDay
    @Published var waterAmount: Water = .small

    // نطلب إذن الإشعارات أول ما ينشأ الـ ViewModel
    init() {
        requestPermission()
    }

    // عدد النباتات اللي انسقت
    var wateredCount: Int {
        plants.filter { $0.isWatered }.count
    }

    // نسبة التقدم من 0 إلى 1
    var progress: Double {
        plants.isEmpty ? 0 : Double(wateredCount) / Double(plants.count)
    }

    // هل كل النباتات انسقت؟
    var allWatered: Bool {
        !plants.isEmpty && wateredCount == plants.count
    }

    // الجملة فوق الشريط
    var progressMessage: String {
        if wateredCount == 0 {
            return "Your plants are waiting for a sip 💦"
        } else {
            return "\(wateredCount) of your plants feel loved today ✨"
        }
    }

    // فتح الشيت لإضافة نبتة
    func openAdd() {
        resetForm()
        showSheet = true
    }

    // فتح الشيت لتعديل نبتة
    func openEdit(_ plant: Plant) {
        plantToEdit = plant
        name = plant.name
        room = plant.room
        light = plant.light
        wateringDays = plant.wateringDays
        waterAmount = plant.waterAmount
        showSheet = true
    }

    // حفظ (إضافة أو تعديل)
    func savePlant() {
        if let plant = plantToEdit,
           let index = plants.firstIndex(where: { $0.id == plant.id }) {
            plants[index].name = name
            plants[index].room = room
            plants[index].light = light
            plants[index].wateringDays = wateringDays
            plants[index].waterAmount = waterAmount

            cancelNotification(for: plants[index])
            scheduleNotification(for: plants[index])
        } else {
            let newPlant = Plant(
                name: name,
                room: room,
                light: light,
                wateringDays: wateringDays,
                waterAmount: waterAmount
            )
            plants.append(newPlant)
            hasStarted = true

            scheduleNotification(for: newPlant)
        }
        showSheet = false
    }

    // حذف النبتة اللي نعدّلها
    func deleteEditingPlant() {
        if let plant = plantToEdit {
            deletePlant(plant)
        }
        showSheet = false
    }

    func deletePlant(_ plant: Plant) {
        cancelNotification(for: plant)
        plants.removeAll { $0.id == plant.id }
    }

    func toggleWatered(_ plant: Plant) {
        if let index = plants.firstIndex(where: { $0.id == plant.id }) {
            plants[index].isWatered.toggle()
        }
    }

    // نرجّع كل النباتات غير مسقية
    func resetWatered() {
        for index in plants.indices {
            plants[index].isWatered = false
        }
    }

    // تفريغ الفورم
    func resetForm() {
        plantToEdit = nil
        name = ""
        room = .bedroom
        light = .fullSun
        wateringDays = .everyDay
        waterAmount = .small
    }

    // MARK: - الإشعارات

    // نطلب إذن إظهار الإشعارات
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    // نجدول إشعار للنبتة
    func scheduleNotification(for plant: Plant) {
        let content = UNMutableNotificationContent()
        content.title = "Planto"
        content.body = "Hey! let's water your plant"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: plant.wateringDays.intervalSeconds,
            repeats: true
        )

        // للتجربة: بدّليه بهذا السطر (يطلع بعد 5 ثواني)
        // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(
            identifier: plant.id.uuidString,
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(request)
    }

    // نلغي إشعار النبتة
    func cancelNotification(for plant: Plant) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [plant.id.uuidString])
    }
}

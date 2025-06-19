import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
class MetersViewModel: ObservableObject {
    @Published var meters: [Meter] = []
    @Published var editingMeter: Meter?
    @Published var isEditing = false
    
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    
    func startListeningMeters(for userId: String) {
       
        listener?.remove()
        listener = db.collection("meters")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Ошибка счетчиков: \(error)")
                    return
                }
                guard let documents = snapshot?.documents else { return }
                self.meters = documents.compactMap { doc in
                    try? doc.data(as: Meter.self)
                }
            }
    }
    

    func stopListening() {
        listener?.remove()
        listener = nil
    }
    

    func saveMeter(number: String, address: String) {
        if let editing = editingMeter, let id = editing.id {
  
            db.collection("meters").document(id).setData([
                "location": address,
                "serialNumber": number,
                "type": editing.type,
                "userId": editing.userId
            ]) { error in
                if let error = error {
                    print("Ошибка обновления счетчика: \(error)")
                }
            }
        } else {
            // Создание нового
            let newMeter = Meter(id: nil, location: address, serialNumber: number, type: "hot_water", userId: "") // userId заполнить перед вызовом
            do {
                _ = try db.collection("meters").addDocument(from: newMeter)
            } catch {
                print("Ошибка сохранения нового счетчика: \(error)")
            }
        }
        // Сброс
        editingMeter = nil
        isEditing = false
    }
    
    func editMeter(_ meter: Meter) {
        editingMeter = meter
        isEditing = true
    }
    
    func deleteMeters(at offsets: IndexSet) {
        offsets.forEach { index in
            if let id = meters[index].id {
                db.collection("meters").document(id).delete() { error in
                    if let error = error {
                        print("Ошибка удаления счетчика: \(error)")
                    }
                }
            }
        }
        meters.remove(atOffsets: offsets)
    }
    
//    deinit {
//        stopListening()
//    }
}


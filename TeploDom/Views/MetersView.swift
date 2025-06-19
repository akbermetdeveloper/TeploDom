////
////  MetersView.swift
////  TeploDom
////
////  Created by Bema on 19/6/25.
////
import SwiftUI


struct MetersView: View {
    @ObservedObject var viewModel: MetersViewModel
    @Binding var selectedTab: CustomTabBarView.Tab
    var subViewModel: SubViewModel
    @EnvironmentObject var authVM: AuthViewModel
    

    @State private var serialNumber: String = ""
    @State private var location: String = ""
    @FocusState private var isInputActive: Bool
    
    var body: some View {
        NavigationStack {
     
            VStack {
                
                if viewModel.meters.isEmpty {
                    Text("Нет счетчиков")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    List {
                        ForEach(viewModel.meters) { meter in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(meter.location)
                                        .font(.headline)
                                    Text("Серийный номер: \(meter.serialNumber)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Button {
                                    viewModel.editMeter(meter)
                                    serialNumber = meter.serialNumber
                                    location = meter.location
                                    isInputActive = true
                                } label: {
                                    Image(systemName: "pencil")
                                }
                                .buttonStyle(.borderless)
                            }
                        }
                        .onDelete(perform: viewModel.deleteMeters)
                    }
                    .listStyle(.plain)
                }
                
                Divider()
                
                VStack(spacing: 12) {
                    Text(viewModel.isEditing ? "Редактировать счетчик" : "Добавить счетчик")
                        .font(.title2)
                        .bold()
                    
                    TextField("Локация (например, ванная, кухня)", text: $location)
                        .textFieldStyle(.roundedBorder)
                        .focused($isInputActive)
                    
                    TextField("Серийный номер", text: $serialNumber)
                        .textFieldStyle(.roundedBorder)
                        .focused($isInputActive)
                    
                    Button {
                        guard !serialNumber.isEmpty, !location.isEmpty else {
                            // Можно показать алерт или ошибку
                            return
                        }
                        
                        if viewModel.isEditing {
                            if var editingMeter = viewModel.editingMeter {
                                editingMeter.serialNumber = serialNumber
                                editingMeter.location = location
                                Task {
                                    await viewModel.saveMeter(number: serialNumber, address: location)
                                    clearForm()
                                }
                            }
                        } else {
                            Task {
                                await viewModel.saveMeter(number: serialNumber, address: location)
                                clearForm()
                            }
                        }
                    } label: {
                        Text(viewModel.isEditing ? "Сохранить изменения" : "Добавить счетчик")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.cornerRadius(10))
                            .foregroundColor(.white)
                    }
                }
                .padding()
            }
            .navigationTitle("Счетчики горячей воды")
            .toolbar {
                EditButton()
            }
            .onAppear {
//                Task {
//                    if let userId = authVM.appUser?.accountNumber {
//                        await viewModel.fetchMeters(for: userId)
//                    }
//
//                }
            }

            
        }
    }
    
    private func clearForm() {
        serialNumber = ""
        location = ""
        viewModel.isEditing = false
        viewModel.editingMeter = nil
        isInputActive = false
    }
}

struct AddEditMeterView: View {
    @ObservedObject var viewModel: MetersViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var number = ""
    @State private var address = ""
    @State private var status: MeterStatus = .active
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Номер счетчика", text: $number)
                    .keyboardType(.numberPad)
                TextField("Адрес", text: $address)
                Picker("Статус", selection: $status) {
                    ForEach(MeterStatus.allCases, id: \.self) { status in
                        Text(status.rawValue.capitalized)
                    }
                }
            }
            .navigationTitle(viewModel.isEditing ? "Редактировать счетчик" : "Добавить счетчик")
            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button("Отмена") {
//                        dismiss()
//                    }
//                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Сохранить") {
                        viewModel.saveMeter(number: number, address: address)
                        dismiss()
                    }
                    .disabled(number.isEmpty || address.isEmpty)
                }
            }
            .onAppear {
                if let editingMeter = viewModel.editingMeter {
                    number = editingMeter.serialNumber
                    address = editingMeter.location
                   // MeterStatus(rawValue: status = editingMeter.type) ?? ""
                }
            }
        }
    }
}

enum MeterStatus: String, CaseIterable {
    case active = "активен"
    case inactive = "неактивен"
    case needsReplacement = "нуждается в замене"
}

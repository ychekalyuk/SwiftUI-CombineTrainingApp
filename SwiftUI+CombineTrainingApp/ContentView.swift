//
//  ContentView.swift
//  SwiftUI+CombineTrainingApp
//
//  Created by Юрий Альт on 10.03.2023.
//

import SwiftUI
import Combine

class CancellingMultiplePipelinesViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var firstNameValidation = ""
    @Published var lastName = ""
    @Published var lastNameValidation = ""
    private var validationCancellables: Set<AnyCancellable> = []
    
    init() {
        $firstName
            .map { $0.isEmpty ? "❌" : "✅" }
            .sink { [unowned self] value in
                self.firstNameValidation = value
            }
            .store(in: &validationCancellables)
        $lastName
            .map { $0.isEmpty ? "❌" : "✅" }
            .sink { [unowned self] value in
                self.lastNameValidation = value
            }
            .store(in: &validationCancellables)
    }
    
    func cancelAllValidations() {
        validationCancellables.removeAll()
    }
}




struct ContentView: View {
    @StateObject private var vm = CancellingMultiplePipelinesViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                TextField("First Name", text: $vm.firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text(vm.firstNameValidation)
            }
            
            HStack {
                TextField("Last Name", text: $vm.lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text(vm.lastNameValidation)
            }
            
            Button("Cancel All Validations") {
                vm.cancelAllValidations()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


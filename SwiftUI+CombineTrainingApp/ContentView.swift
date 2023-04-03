//
//  ContentView.swift
//  SwiftUI+CombineTrainingApp
//
//  Created by Юрий Альт on 10.03.2023.
//

import SwiftUI
import Combine

enum InvalidAgeError: String, Error, Identifiable {
    var id: String { rawValue }
    case lessThanZero = "Cannot be less than zero"
    case moreThanOneHundred = "Cannot be more than 100"
}

class Validators {
    static func validAgePublisher(age: Int) -> AnyPublisher<Int, InvalidAgeError> {
        if age < 0 {
            return Fail(error: InvalidAgeError.lessThanZero)
                .eraseToAnyPublisher()
        } else if age > 100 {
            return Fail(error: InvalidAgeError.moreThanOneHundred)
                .eraseToAnyPublisher()
        }
        
        return Just(age)
            .setFailureType(to: InvalidAgeError.self)
            .eraseToAnyPublisher()
    }
}

class FailIntroViewModel: ObservableObject {
    @Published var age = 0
    @Published var error: InvalidAgeError?
    
    func save(age: Int) {
        _ = Validators.validAgePublisher(age: age)
            .sink { [unowned self] completion in
                if case .failure(let error) = completion {
                    self.error = error
                }
            } receiveValue: { [unowned self] age in
                self.age = age
            }
    }
}


struct ContentView: View {
    @StateObject private var vm = FailIntroViewModel()
    @State private var age = ""
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter Age", text: $age)
                .keyboardType(UIKeyboardType.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button("Save") {
                vm.save(age: Int(age) ?? -1)
            }
            Text("\(vm.age)")
        }
        .font(.title)
        .alert(item: $vm.error) { error in
            Alert(title: Text("Invalid Age"), message: Text(error.rawValue))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


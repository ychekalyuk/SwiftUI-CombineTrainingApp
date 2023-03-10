//
//  ContentView.swift
//  SwiftUI+CombineTrainingApp
//
//  Created by Юрий Альт on 10.03.2023.
//

import SwiftUI
import Combine

class CurrentValueSubjectViewModel: ObservableObject {
    
    var selection = CurrentValueSubject<String, Never>("No Name Selected")
    var seletionSame = CurrentValueSubject<Bool, Never>(false)
    var cancellables: [AnyCancellable] = []
    
    init() {
        selection
            .map { [unowned self] newValue -> Bool in
                if newValue == selection.value {
                    return true
                } else {
                    return false
                }
            }
            .sink { [unowned self] value in
                seletionSame.value = value
                objectWillChange.send()
            }
            .store(in: &cancellables)
    }
}




struct ContentView: View {
    @StateObject private var vm = CurrentValueSubjectViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Button("Select Lorenzo") {
                vm.selection.send("Lorenzo")
            }
            
            Button("Select Ellen") {
                vm.selection.value = "Ellen"
            }
            
            Text(vm.selection.value)
                .foregroundColor(vm.seletionSame.value ? .red : .green)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


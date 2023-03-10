//
//  ContentView.swift
//  SwiftUI+CombineTrainingApp
//
//  Created by Юрий Альт on 10.03.2023.
//

import SwiftUI
import Combine

class PublishedValidationViewModel: ObservableObject {
    @Published var name = ""
    @Published var validation: String = ""
    var cancellable: AnyCancellable?
    
    
    init() {
        cancellable = $name
            .map { $0.isEmpty ? "❌" : "✅" }
            .sink { [unowned self] value in
                self.validation = value
            }
    }
    
}

struct ContentView: View {
    @StateObject private var vm = PublishedValidationViewModel()
    @State private var message = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("@Published")
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            HStack {
                TextField("name", text: $vm.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text(vm.validation)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


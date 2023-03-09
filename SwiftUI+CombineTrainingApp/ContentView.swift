//
//  ContentView.swift
//  SwiftUI+CombineTrainingApp
//
//  Created by Юрий Альт on 10.03.2023.
//

import SwiftUI

class PublishedValidationViewModel: ObservableObject {
    @Published var name = ""
    @Published var validation: String = ""
    
    init() {
        
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
                    .onChange(of: vm.name) { value in
                        message = value.isEmpty ? "❌" : "✅"
                    }
                Text(message)
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


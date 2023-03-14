//
//  ContentView.swift
//  SwiftUI+CombineTrainingApp
//
//  Created by Юрий Альт on 10.03.2023.
//

import SwiftUI
import Combine

enum BombError: Error {
    case bombError
}

class EmtyIntroViewModel: ObservableObject {
    
    @Published var dataToView: [String] = []
    
    func fetch() {
        let dataIn = ["value 1", "value 2", "value 3", "🧨", "value 5", "value 6"]
        
        _ = dataIn.publisher
            .tryMap { item in
                if item == "🧨" {
                    throw BombError.bombError
                }
                return item
            }
            .catch { error in
                Empty(completeImmediately: true)
            }
            .sink { [unowned self] item in
                dataToView.append(item)
            }
    }
}


struct ContentView: View {
    @StateObject private var vm = EmtyIntroViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            List(vm.dataToView, id: \.self) { item in
                Text(item)
            }
        }
        .onAppear {
            vm.fetch()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


//
//  ContentView.swift
//  SwiftUI+CombineTrainingApp
//
//  Created by Юрий Альт on 10.03.2023.
//

import SwiftUI
import Combine

class CancellingMultiplePipelinesViewModel: ObservableObject {
    var characterLimit = 30
    @Published var data = ""
    @Published var characterCount = 0
    @Published var countColor = Color.gray

    init() {
        $data
            .map { data -> Int in
                return data.count
                
            }
            .assign(to: &$characterCount)
        
        $characterCount
            .map { [unowned self] count -> Color in
                let eightyPercent = Int(Double(characterLimit) * 0.8)
                if (eightyPercent...characterLimit).contains(count) {
                    return Color.yellow
                } else if count > characterLimit {
                    return Color.red
                }
                return Color.gray
            }
            .assign(to: &$countColor)
    }
}




struct ContentView: View {
    @StateObject private var vm = CancellingMultiplePipelinesViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            TextEditor(text: $vm.data)
                .border(Color.gray, width: 1)
                .frame(height: 200)
                .padding()
            
            Text("\(vm.characterCount)/\(vm.characterLimit)")
                .foregroundColor(vm.countColor)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


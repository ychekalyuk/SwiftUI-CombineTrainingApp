//
//  ContentView.swift
//  SwiftUI+CombineTrainingApp
//
//  Created by Юрий Альт on 10.03.2023.
//

import SwiftUI
import Combine

class PublishedValidationViewModel: ObservableObject {
    @Published var data = "Start Data"
    @Published var status = ""
    private var cancellablePipeLine: AnyCancellable?
    
    
    init() {
        cancellablePipeLine = $data
            .map { [unowned self] value -> String in
                status = "Processing..."
                return value
            }
            .delay(for: 5, scheduler: RunLoop.main)
            .sink { [unowned self] value in
                status = "Finished Process"
            }
    }
    
    func refreshData() {
        data = "Refreshed Data"
    }
    
    func cancel() {
        status = "Cancelled"
        cancellablePipeLine?.cancel()
    }
    
}

struct ContentView: View {
    @StateObject private var vm = PublishedValidationViewModel()
    @State private var message = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text(vm.data)
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Button("Refresh Data") {
                vm.refreshData()
            }
            
            Button("Cancel Subscription") {
                vm.cancel()
            }
            .opacity(vm.status == "Processing..." ? 1 : 0)
            Text(vm.status)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


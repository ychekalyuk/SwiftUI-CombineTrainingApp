//
//  ContentView.swift
//  SwiftUI+CombineTrainingApp
//
//  Created by Юрий Альт on 10.03.2023.
//

import SwiftUI
import Combine

class FutureIntroViewModel: ObservableObject {
    @Published var hello = ""
    @Published var goodbye = ""
    
    var goodbyeCancellable: AnyCancellable?
    
    func sayHello() {
        Future<String, Never> { promise in
            promise(Result.success("Hello, World!"))
        }
        .assign(to: &$hello)
    }
    
    func sayGoodbye() {
        let futurePublisher = Future<String, Never> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                promise(.success("Goodbye, my friend"))
            }
        }
        
        goodbyeCancellable = futurePublisher
            .sink { [unowned self] message in
                goodbye = message
            }
    }
}

struct ContentView: View {
    @StateObject private var vm = FutureIntroViewModel()
    @State private var age = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Button("Say Hello") {
                vm.sayHello()
            }
            Text(vm.hello)
                .padding(.bottom)
            Button("Say Goodbye") {
                vm.sayGoodbye()
            }
            Text(vm.goodbye)
            Spacer()
        }
        .font(.title)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


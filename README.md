example of usage 


    func makeRequest() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com") else {
            return
        }

        let builder = NMRequestBuilder(baseURL: url, path: "/posts/1")

        builder.set(method: .get)

        let network = NM()

        do {
            let response = try network.makeRequest(with: builder, type: WelcomeElement.self)

            response.sink { completion in
                switch completion {
                case .finished:
                    print("request is finished")
                case let .failure(error):
                    print("request is failed with \(error)")
                }
            } receiveValue: { value in
                print("response: \(value)")
            }
            .store(in: &cancellables)
        } catch {
            print("error: \(error)")
        }
    }

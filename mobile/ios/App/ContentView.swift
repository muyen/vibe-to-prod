import SwiftUI

struct ContentView: View {
    @State private var message = "Tap to fetch"
    @State private var isLoading = false
    @State private var error: String?

    var body: some View {
        VStack(spacing: 24) {
            Text("Vibe to Prod")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("iOS + Go Backend")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Spacer()

            if isLoading {
                ProgressView()
                    .scaleEffect(1.5)
            } else if let error = error {
                VStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                    Text(error)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
            } else {
                Text(message)
                    .font(.title2)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
            }

            Spacer()

            Button(action: {
                Task { await fetchHello() }
            }) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Fetch from API")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .disabled(isLoading)
        }
        .padding()
    }

    private func fetchHello() async {
        isLoading = true
        error = nil

        // TODO: Replace with your API base URL
        let urlString = "http://localhost:8080/api/v1/hello?name=iOS"

        guard let url = URL(string: urlString) else {
            error = "Invalid URL"
            isLoading = false
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                error = "Server error"
                isLoading = false
                return
            }

            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let msg = json["message"] as? String {
                message = msg
            }
        } catch {
            self.error = "Network error: \(error.localizedDescription)"
        }

        isLoading = false
    }
}

#Preview {
    ContentView()
}

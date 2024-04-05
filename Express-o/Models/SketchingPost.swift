    //
    //  SketchingPost.swift
    //  Express-o
    //
    //  Created by admin on 01/03/24.
    //

    import Foundation
    import FirebaseFirestore
    import FirebaseAuth


struct SketchingPost: Identifiable {
    var id = UUID()
    var drawingID: String 
    var title: String
    var drawingData: Data?
}

extension SketchingPost {
    static func fetchPosts(completion: @escaping ([SketchingPost]) -> Void, debugCompletion: @escaping (String) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            debugCompletion("User is not logged in")
            completion([])
            return
        }

        debugCompletion("Fetching sketches for user with ID: \(userId)")

        let db = Firestore.firestore()
        let drawingsRef = db.collection("drawings").document(userId)

        drawingsRef.getDocument { document, error in
            if let error = error {
                debugCompletion("Error fetching user's drawings: \(error)")
                completion([])
                return
            }

            var posts: [SketchingPost] = []
            if let document = document, let data = document.data() {
                for (key, drawingData) in data {
                    debugCompletion("Key: \(key)")
                    if let drawingData = drawingData as? [String: Any],
                       let title = drawingData["title"] as? String,
                       let drawingDataString = drawingData["drawingData"] as? String,
                       let drawingData = Data(base64Encoded: drawingDataString) {
                        let post = SketchingPost(drawingID: key, title: title, drawingData: drawingData)
                        posts.append(post)
                        debugCompletion("Drawing Data: \(drawingDataString)")
                    }
                }
            }

            debugCompletion("Fetched \(posts.count) sketches")
            completion(posts)
        }
    }
}

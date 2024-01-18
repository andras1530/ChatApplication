//
//  FCollectionReference.swift
//  chatApplication
//
//  Created by Nagy Andras on 17.01.2024.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference: String {
    case User
    case Recent
}

func FirebaseReference( collectionReference: FCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}

import 'package:clipy/model/clipboard_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ClipBoardRepo {
  final clipboardCollection =
      FirebaseFirestore.instance.collection('clipboard');

  Future<List<ClipBoardContent>> getClipBoardContent() {
    try {
      return clipboardCollection
          .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .orderBy("createdAt", descending: true)
          .get()
          .then((value) => value.docs
              .map((e) => ClipBoardContent.fromJson(e.data())..id = e.id)
              .toList());
    } catch (e) {
      debugPrint(e.toString());
      throw e.toString();
    }
  }

  Stream<QuerySnapshot> getContentStream() {
    return clipboardCollection
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .orderBy("createdAt", descending: true)
        .snapshots(includeMetadataChanges: true)
        .asBroadcastStream();
  }

  Future<void> createClipboardContent({
    required String content,
    required String type,
  }) async {
    try {
      await clipboardCollection.add({
        "content": content,
        "type": type,
        "createdAt": DateTime.now().toIso8601String(),
        "userId": FirebaseAuth.instance.currentUser!.uid,
      });
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updateClipBoardContent(String content, String contentId) async {
    try {
      await clipboardCollection
          .doc(contentId)
          .update({"content": content})
          .then((_) => print("success"))
          .catchError((e) => throw e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> deleteClipboard({
    required String id,
  }) async {
    try {
      clipboardCollection.doc(id).delete();
    } catch (e) {
      throw e.toString();
    }
  }
}

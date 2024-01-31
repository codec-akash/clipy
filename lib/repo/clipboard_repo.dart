import 'package:clipy/model/clipboard_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ClipBoardRepo {
  final clipboardCollection =
      FirebaseFirestore.instance.collection('clipboard');

  Future<List<ClipBoardContent>> getClipBoardContent() {
    try {
      return clipboardCollection
          .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) => value.docs
              .map((e) => ClipBoardContent.fromJson(e.data())..id = e.id)
              .toList());
    } catch (e) {
      print(e.toString());
      throw e.toString();
    }
  }

  Stream<QuerySnapshot> getContentStream() {
    return clipboardCollection
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots(includeMetadataChanges: true);
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

import 'package:clipy/model/clipboard_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClipBoardRepo {
  final clipboardCollection =
      FirebaseFirestore.instance.collection('clipboard');

  Future<List<ClipBoardContent>> getClipBoardContent() {
    print("he;l;pp");
    clipboardCollection
        .get()
        .then((value) => value.docs.map((e) => print("check this ${e.id}")));
    try {
      return clipboardCollection.get().then((value) => value.docs
          .map((e) => ClipBoardContent.fromJson(e.data())..id = e.id)
          .toList());
    } catch (e) {
      print(e.toString());
      throw e.toString();
    }
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

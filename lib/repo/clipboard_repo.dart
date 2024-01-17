import 'package:clipy/model/clipboard_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClipBoardRepo {
  final clipboardCollection =
      FirebaseFirestore.instance.collection('clipboard');

  Future<List<ClipBoardContent>> getClipBoardContent() {
    try {
      return clipboardCollection.get().then((value) =>
          value.docs.map((e) => ClipBoardContent.fromJson(e.data())).toList());
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> createClipboardContent() async {
    try {
      await clipboardCollection.add({
        "content": "Hello world",
        "type": "Text",
        "createdAt": DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw e.toString();
    }
  }
}

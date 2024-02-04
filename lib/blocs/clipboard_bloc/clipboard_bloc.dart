import 'dart:async';

import 'package:clipy/model/clipboard_model.dart';
import 'package:clipy/repo/clipboard_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'clipboard_state.dart';
part 'clipboard_event.dart';

class ClipBoardBloc extends Bloc<ClipBoardEvent, ClipBoardState> {
  ClipBoardRepo clipBoardRepo = ClipBoardRepo();

  late StreamSubscription<QuerySnapshot> _subscription;

  ClipBoardBloc() : super(Uninitialized()) {
    _subscription = clipBoardRepo.getContentStream().listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        add(GetUpdatedClipBoardContent(
            clipBoardContent: snapshot.docs
                .map((e) =>
                    ClipBoardContent.fromJson(e.data() as Map<String, dynamic>)
                      ..id = e.id)
                .toList()));
      }
    });

    on<LoadClipBoardContent>((event, emit) async {
      await _loadClipboardContent(event, emit);
    });
    on<CreateClipboardContent>((event, emit) async {
      await _createClipboardContent(event, emit);
    });
    on<DeleteClipboardContent>((event, emit) async {
      await _deleteClipboardContent(event, emit);
    });
    on<GetUpdatedClipBoardContent>((event, emit) {
      emit(ClipboardLoading(currentEvent: event));
      emit(UpdatedClipboardContentLoaded(
          clipBoardContent: event.clipBoardContent));
    });
    on<UpdateClipboardContent>(_updateClipboardContent);
  }

  Future<void> _loadClipboardContent(
      LoadClipBoardContent event, Emitter<ClipBoardState> emit) async {
    emit(ClipboardLoading(currentEvent: event));
    try {
      List<ClipBoardContent> clipboard =
          await clipBoardRepo.getClipBoardContent();
      emit(ClipBoardContentLoaded(clipboardContent: clipboard));
    } catch (e) {
      emit(ClipBoardFailed(errorMsg: e.toString(), currentEvent: event));
    }
  }

  Future<void> _createClipboardContent(
      CreateClipboardContent event, Emitter<ClipBoardState> emit) async {
    emit(ClipboardLoading(currentEvent: event));
    try {
      await clipBoardRepo.createClipboardContent(
          content: event.content, type: event.type);
      emit(ClipBoardContentCreated());
      add(LoadClipBoardContent());
    } catch (e) {
      emit(ClipBoardFailed(errorMsg: e.toString(), currentEvent: event));
    }
  }

  Future<void> _deleteClipboardContent(
      DeleteClipboardContent event, Emitter<ClipBoardState> emit) async {
    emit(ClipboardLoading(currentEvent: event));
    try {
      await clipBoardRepo.deleteClipboard(id: event.id);
      emit(ClipboardContentDeleted());
      add(LoadClipBoardContent());
    } catch (e) {
      emit(ClipBoardFailed(errorMsg: e.toString(), currentEvent: event));
    }
  }

  Future<void> _updateClipboardContent(
      UpdateClipboardContent event, Emitter<ClipBoardState> emit) async {
    emit(ClipboardLoading(currentEvent: event));
    try {
      await clipBoardRepo.updateClipBoardContent(
          event.content, event.contentId);
      emit(ClipboardContentUpdated(contentId: event.contentId));
    } catch (e) {
      emit(ClipBoardFailed(errorMsg: e.toString(), currentEvent: event));
    }
  }
}

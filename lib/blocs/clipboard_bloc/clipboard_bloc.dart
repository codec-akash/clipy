import 'package:clipy/model/clipboard_model.dart';
import 'package:clipy/repo/clipboard_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'clipboard_state.dart';
part 'clipboard_event.dart';

class ClipBoardBloc extends Bloc<ClipBoardEvent, ClipBoardState> {
  ClipBoardRepo clipBoardRepo = ClipBoardRepo();
  ClipBoardBloc() : super(Uninitialized()) {
    on<LoadClipBoardContent>((event, emit) async {
      await _loadClipboardContent(event, emit);
    });
    on<CreateClipboardContent>((event, emit) async {
      await _createClipboardContent(event, emit);
    });
    on<DeleteClipboardContent>((event, emit) async {
      await _deleteClipboardContent(event, emit);
    });
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
}

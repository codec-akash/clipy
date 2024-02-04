part of 'clipboard_bloc.dart';

class ClipBoardState extends Equatable {
  const ClipBoardState();

  @override
  List<Object?> get props => [];
}

class Uninitialized extends ClipBoardState {
  @override
  String toString() => 'Uninitialized';
}

class ClipboardLoading extends ClipBoardState {
  final ClipBoardEvent currentEvent;

  const ClipboardLoading({required this.currentEvent});
}

class ClipBoardFailed extends ClipBoardState {
  final String errorMsg;
  final ClipBoardEvent currentEvent;

  const ClipBoardFailed({
    required this.errorMsg,
    required this.currentEvent,
  });
}

class ClipBoardContentLoaded extends ClipBoardState {
  final List<ClipBoardContent> clipboardContent;

  const ClipBoardContentLoaded({required this.clipboardContent});
}

class ClipBoardContentCreated extends ClipBoardState {}

class ClipboardContentDeleted extends ClipBoardState {}

class UpdatedClipboardContentLoaded extends ClipBoardState {
  final List<ClipBoardContent> clipBoardContent;

  const UpdatedClipboardContentLoaded({required this.clipBoardContent});
}

class ClipboardContentUpdated extends ClipBoardState {
  final String contentId;

  const ClipboardContentUpdated({required this.contentId});
}

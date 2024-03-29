part of 'clipboard_bloc.dart';

class ClipBoardEvent extends Equatable {
  const ClipBoardEvent();

  @override
  List<Object?> get props => [];
}

class LoadClipBoardContent extends ClipBoardEvent {}

class CreateClipboardContent extends ClipBoardEvent {
  final String content;
  final String type;

  const CreateClipboardContent({
    required this.content,
    required this.type,
  });
}

class DeleteClipboardContent extends ClipBoardEvent {
  final String id;

  const DeleteClipboardContent({required this.id});
}

class GetUpdatedClipBoardContent extends ClipBoardEvent {
  final List<ClipBoardContent> clipBoardContent;

  const GetUpdatedClipBoardContent({required this.clipBoardContent});
}

class UpdateClipboardContent extends ClipBoardEvent {
  final String content;
  final String contentId;

  const UpdateClipboardContent({
    required this.content,
    required this.contentId,
  });
}

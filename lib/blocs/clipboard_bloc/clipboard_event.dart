part of 'clipboard_bloc.dart';

class ClipBoardEvent extends Equatable {
  const ClipBoardEvent();

  @override
  List<Object?> get props => [];
}

class LoadClipBoardContent extends ClipBoardEvent {}

class CreateClipboardContent extends ClipBoardEvent {}

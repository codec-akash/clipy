part of 'login_bloc.dart';

class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginWithGoogle extends LoginEvent {}

class AppStarted extends LoginEvent {}

class Logout extends LoginEvent {}

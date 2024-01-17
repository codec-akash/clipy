part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class Uninitialized extends LoginState {
  @override
  String toString() => 'Uninitialized';
}

class LoginLoadingState extends LoginState {}

class LogInFailedState extends LoginState {
  final String errorMsg;
  final LoginEvent loginEvent;

  const LogInFailedState({required this.loginEvent, required this.errorMsg});
}

class LoggedInWithGoogle extends LoginState {
  final User userCredential;

  const LoggedInWithGoogle({required this.userCredential});
}

class LoggInRequired extends LoginState {}

class LoggedOut extends LoginState {}

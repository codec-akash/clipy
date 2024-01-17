import 'package:clipy/repo/auth_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepo authRepo;
  late User userDetials;

  LoginBloc(this.authRepo) : super(Uninitialized()) {
    on<AppStarted>((event, emit) async {
      await isuserLoggedIn(event, emit);
    });
    on<LoginWithGoogle>((event, emit) async {
      await logInWithGoogle(event, emit);
    });
    on<Logout>((event, emit) async {
      await logout(emit, event);
    });
  }

  Future<void> logInWithGoogle(
      LoginWithGoogle event, Emitter<LoginState> emit) async {
    try {
      emit(LoginLoadingState());
      User user = await authRepo.logginWithGoogle();
      userDetials = user;
      emit(LoggedInWithGoogle(userCredential: user));
    } catch (e) {
      emit(LogInFailedState(loginEvent: event, errorMsg: e.toString()));
    }
  }

  Future<void> isuserLoggedIn(
      AppStarted event, Emitter<LoginState> emit) async {
    try {
      emit(LoginLoadingState());
      User? user = await authRepo.isUserLoggedIn();
      if (user != null) {
        userDetials = user;
        emit(LoggedInWithGoogle(userCredential: user));
      } else {
        emit(LoggInRequired());
      }
    } catch (e) {
      emit(LogInFailedState(loginEvent: event, errorMsg: e.toString()));
    }
  }

  Future<void> logout(Emitter<LoginState> emit, Logout event) async {
    try {
      emit(LoginLoadingState());
      await authRepo.signOut();
      emit(LoggedOut());
    } catch (e) {
      emit(LogInFailedState(loginEvent: event, errorMsg: e.toString()));
    }
  }
}

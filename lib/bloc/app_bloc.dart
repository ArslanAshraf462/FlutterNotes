import 'package:flutter_bloc/flutter_bloc.dart';
import '../api/login_api.dart';
import '../api/notes_api.dart';
import '../models/models.dart';
import './actions.dart';
import 'app_state.dart';

class AppBloc extends Bloc<AppActions, AppState> {
  final LoginApiProtocol loginApi;
  final NotesApiProtocol notesApi;

  AppBloc({
    required this.loginApi,
    required this.notesApi,
  }) : super(const AppState.empty()) {
    on<LoginAction>((event, emit) async {
      emit(
        const AppState(
          isLoading: true,
          loginError: null,
          loginHandle: null,
          fetchedNotes: null,
        ),
      );
      final fooBarHandle = await loginApi.login(
        email: event.email,
        password: event.password,
      );

      if (fooBarHandle == null) {
        emit(
          const AppState(
            isLoading: false,
            loginError: LoginErrors.invalidHandle,
            loginHandle: null,
            fetchedNotes: null,
          ),
        );
      } else {
        emit(
          AppState(
            isLoading: false,
            loginError: null,
            loginHandle: fooBarHandle,
            fetchedNotes: null,
          ),
        );
      }
    });

    on<LoadNotes>((event, emit) async {
      emit(
        AppState(
          isLoading: true,
          loginError: null,
          loginHandle: state.loginHandle,
          fetchedNotes: null,
        ),
      );
      final loginHandle = state.loginHandle;
      if (loginHandle == const LoginHandle.fooBar()) {
        final notes = await notesApi.getNotes(
          loginHandle: loginHandle!,
        );
        emit(
          AppState(
            isLoading: false,
            loginError: null,
            loginHandle: loginHandle,
            fetchedNotes: notes,
          ),
        );
      } else {
        emit(
          AppState(
            isLoading: false,
            loginError: LoginErrors.invalidHandle,
            loginHandle: loginHandle,
            fetchedNotes: null,
          ),
        );
      }
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_notes/views/iterable_list_view.dart';
import 'package:flutter_notes/views/login_view.dart';

import 'api/login_api.dart';
import 'api/notes_api.dart';
import 'bloc/actions.dart';
import 'bloc/app_bloc.dart';
import 'bloc/app_state.dart';
import 'constants/app_strings.dart';
import 'dialogs/generic_dilog.dart';
import 'dialogs/loading_screen.dart';
import 'models/models.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends HookWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: bloc,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (_) => AppBloc(
          loginApi: LoginApi(),
          notesApi: NotesApi(),
        ),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(homePage),
          ),
          body: BlocConsumer<AppBloc, AppState>(
            listener: (context, state) {
              final loading = LoadingScreen.instance();
              // loading screen
              if (state.isLoading) {
                loading.show(
                  context: context,
                  text: pleaseWait,
                );
              } else {
                loading.hide();
              }
              // display possible errors
              final loginError = state.loginError;
              if (loginError != null) {
                showGenericDialog(
                  context: context,
                  title: loginErrorDialogTitle,
                  content: loginErrorDialogContent,
                  optionBuilder: () => {
                    ok: true,
                  },
                );
              }
              // if logged in but notes are not fetched yet, then fetch notes here
              if (state.isLoading == false &&
                  state.loginError == null &&
                  state.loginHandle == const LoginHandle.fooBar() &&
                  state.fetchedNotes == null) {
                context.read<AppBloc>().add(const LoadNotes());
              }
            },
            builder: (context, state) {
              final notes = state.fetchedNotes;
              if (notes == null) {
                return LoginView(
                  onLoginTap: (email, password) {
                    context.read<AppBloc>().add(
                      LoginAction(
                        email: email,
                        password: password,
                      ),
                    );
                  },
                );
              }else{
                return notes.toListView();
              }
            },
          ),
        ),
      ),
    );
  }
}

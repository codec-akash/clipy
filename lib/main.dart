import 'package:clipy/blocs/clipboard_bloc/clipboard_bloc.dart';
import 'package:clipy/blocs/login_bloc/login_bloc.dart';
import 'package:clipy/env/env.dart';
import 'package:clipy/repo/auth_repo.dart';
import 'package:clipy/repo/firebase_api.dart';
import 'package:clipy/screens/home_screen/home_page.dart';
import 'package:clipy/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: Env.apikey,
      appId: Env.appId,
      messagingSenderId: Env.messageId,
      projectId: Env.projectId,
      authDomain: Env.authDomain,
    ),
  );
  await FirebaseApi().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthRepo authRepo = AuthRepo();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clipy',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        textTheme:
            GoogleFonts.oldStandardTtTextTheme(Typography.whiteCupertino),
        primaryColor: const Color(0xff307477),
        secondaryHeaderColor: const Color(0xffF6F740),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff18302e),
        ),
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<LoginBloc>(create: (context) => LoginBloc(authRepo)),
          BlocProvider(create: (context) => ClipBoardBloc())
        ],
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            if (state is LoggedInWithGoogle) {
              return HomePage();
            }
            return LoginScreen();
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            GestureDetector(
              onTap: () {
                context.read<LoginBloc>().add(Logout());
              },
              child: const Text("logout"),
            )
          ],
        ),
      ),
    );
  }
}

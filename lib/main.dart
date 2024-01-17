import 'package:clipy/blocs/clipboard_bloc/clipboard_bloc.dart';
import 'package:clipy/blocs/login_bloc/login_bloc.dart';
import 'package:clipy/env/env.dart';
import 'package:clipy/repo/auth_repo.dart';
import 'package:clipy/screens/home_screen.dart/home_page.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        textTheme:
            GoogleFonts.oldStandardTtTextTheme(Typography.whiteCupertino),
        primaryColor: const Color(0xff307477),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

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
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            GestureDetector(
              onTap: () {
                context.read<LoginBloc>().add(Logout());
              },
              child: Text("logout"),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

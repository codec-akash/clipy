import 'package:clipy/blocs/clipboard_bloc/clipboard_bloc.dart';
import 'package:clipy/blocs/login_bloc/login_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User userDetials;

  @override
  void initState() {
    userDetials = context.read<LoginBloc>().userDetials;
    context.read<ClipBoardBloc>().add(LoadClipBoardContent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home page"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
        child: CustomScrollView(
          slivers: [
            BlocListener<ClipBoardBloc, ClipBoardState>(
              listener: (context, state) {
                if (state is ClipBoardContentLoaded) {
                  print(
                      "Hello world - ${state.clipboardContent.map((e) => e.content).toList()}");
                }
                if (state is ClipBoardFailed) {
                  print("hello");
                  print(state.errorMsg);
                }
                if (state is ClipBoardContentCreated) {
                  print("Wohooo");
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("created")));
                }
              },
              child: SliverToBoxAdapter(child: Container()),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (userDetials.displayName != null) ...[
                    Row(
                      children: [
                        Text(
                          "Logged in as -",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 10),
                        Text(userDetials.displayName!),
                      ],
                    ),
                  ],
                  GestureDetector(
                    onTap: () {
                      context
                          .read<ClipBoardBloc>()
                          .add(CreateClipboardContent());
                    },
                    child: Text("Create"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

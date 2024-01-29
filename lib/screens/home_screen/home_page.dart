import 'package:clipy/blocs/clipboard_bloc/clipboard_bloc.dart';
import 'package:clipy/blocs/login_bloc/login_bloc.dart';
import 'package:clipy/model/clipboard_model.dart';
import 'package:clipy/screens/home_screen/clipboard_card.dart';
import 'package:clipy/utils/extension_function.dart';
import 'package:clipy/widgets/disable_widget.dart';
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
  TextEditingController textEditingController = TextEditingController();
  List<ClipBoardContent> clipboardContents = [];

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
                  setState(() {
                    clipboardContents = state.clipboardContent;
                  });
                }
                if (state is ClipBoardFailed) {
                  if (state.currentEvent is DeleteClipboardContent) {
                    context.showSnackBar(state.errorMsg);
                  }
                }
                if (state is ClipBoardContentCreated) {
                  setState(() {
                    textEditingController.clear();
                  });
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
                          "Logged in as testing deploy -",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 10),
                        Text(userDetials.displayName!),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            context.read<LoginBloc>().add(Logout());
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(8)),
                            child: const Text("Logout"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(color: Colors.white.withOpacity(0.3), height: 1),
                  ],
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: textEditingController,
                          onChanged: (value) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                bottom: 0, left: 10, right: 20),
                            hintText: "Enter the text for clipboard",
                            hintStyle: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                      DisableWidget(
                        isDisable: textEditingController.text.isEmpty,
                        child: GestureDetector(
                          onTap: () {
                            context.read<ClipBoardBloc>().add(
                                CreateClipboardContent(
                                    content: textEditingController.text,
                                    type: "text"));
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text("Add"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: clipboardContents
                        .map((clipboard) =>
                            ClipboardCard(clipBoardContent: clipboard))
                        .toList(),
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

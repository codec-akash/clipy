import 'package:clipy/blocs/clipboard_bloc/clipboard_bloc.dart';
import 'package:clipy/model/clipboard_model.dart';
import 'package:clipy/utils/date_time.dart';
import 'package:clipy/utils/extension_function.dart';
import 'package:clipy/widgets/show_more_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClipboardCard extends StatefulWidget {
  final ClipBoardContent clipBoardContent;
  const ClipboardCard({super.key, required this.clipBoardContent});

  @override
  State<ClipboardCard> createState() => _ClipboardCardState();
}

class _ClipboardCardState extends State<ClipboardCard> {
  bool isEditOn = false;
  bool isLoading = false;
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocListener<ClipBoardBloc, ClipBoardState>(
              listener: (context, state) {
                if (state is ClipboardLoading &&
                    state.currentEvent is UpdateClipboardContent) {
                  setState(() {
                    isLoading = true;
                  });
                }
                if (state is ClipboardContentUpdated &&
                    state.contentId == widget.clipBoardContent.id) {
                  setState(() {
                    isEditOn = false;
                    isLoading = false;
                  });
                  context.showSnackBar("clipboard content updated");
                }
                if (state is ClipBoardFailed) {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              child: Container(),
            ),
            if (isEditOn) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(controller: contentController),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      if (contentController.text ==
                          widget.clipBoardContent.content) {
                        setState(() {
                          isEditOn = false;
                        });
                      } else {
                        context.read<ClipBoardBloc>().add(
                            UpdateClipboardContent(
                                content: contentController.text,
                                contentId: widget.clipBoardContent.id));
                      }
                    },
                    icon: const Icon(Icons.done),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
            Row(
              children: [
                Expanded(
                    child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isEditOn ? 0.4 : 1.0,
                  // child: SelectableText(widget.clipBoardContent.content),
                  child: ShowMoreText(text: widget.clipBoardContent.content),
                )),
                if (!isEditOn) ...[
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      setState(() {
                        contentController.text =
                            widget.clipBoardContent.content;
                        isEditOn = true;
                      });
                    },
                    icon: const Icon(Icons.mode_edit_outlined),
                  ),
                ],
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    await Clipboard.setData(
                        ClipboardData(text: widget.clipBoardContent.content));
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("content clipboard")));
                    }
                  },
                  icon: const Icon(Icons.copy_outlined),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    context.read<ClipBoardBloc>().add(
                        DeleteClipboardContent(id: widget.clipBoardContent.id));
                  },
                  icon: Icon(
                    Icons.delete_outline_outlined,
                    color: Colors.redAccent.withOpacity(0.7),
                  ),
                )
              ],
            ),
            const SizedBox(height: 5),
            Text(
              DateTimeUtil.dayDateMonthFormat(
                  DateTime.parse(widget.clipBoardContent.createdAt).toLocal()),
              textAlign: TextAlign.left,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall!
                  .copyWith(color: Theme.of(context).secondaryHeaderColor),
            ),
          ],
        ),
      ),
    );
  }
}

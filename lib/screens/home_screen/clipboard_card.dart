import 'package:clipy/blocs/clipboard_bloc/clipboard_bloc.dart';
import 'package:clipy/model/clipboard_model.dart';
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
      child: Row(
        children: [
          Expanded(child: Text(widget.clipBoardContent.content)),
          IconButton(
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
            onPressed: () async {
              context
                  .read<ClipBoardBloc>()
                  .add(DeleteClipboardContent(id: widget.clipBoardContent.id));
            },
            icon: Icon(
              Icons.delete_outline_outlined,
              color: Colors.redAccent.withOpacity(0.7),
            ),
          )
        ],
      ),
    );
  }
}

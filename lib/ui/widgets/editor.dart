import 'package:flutter/material.dart';

const editorColor = Color(0xff191B1C);

showEditor(BuildContext context, String raw, String name, Function(String newText) onPressed) {
  TextEditingController controller = TextEditingController(text: raw);

  return showModalBottomSheet(
    context: context,
    backgroundColor: editorColor,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  color: Colors.white10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(
                        name,
                        style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onPressed.call(controller.text);
                        },
                        child: const Text(
                          'Save',
                          style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Editor(
                    controller: controller,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class Editor extends StatefulWidget {
  const Editor({
    Key? key,
    required this.controller,
    this.nestedScroll = false,
    this.readOnly = false,
  }) : super(key: key);

  final TextEditingController controller;
  final bool nestedScroll;
  final bool readOnly;

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  late int numLines;

  @override
  void initState() {
    super.initState();
    numLines = '\n'.allMatches(widget.controller.text).length + 1;
  }

  @override
  Widget build(BuildContext context) {
    final child = Container(
      color: editorColor,
      child: ConstrainedBox(
        constraints:
            widget.nestedScroll ? const BoxConstraints.tightFor(width: 800) : const BoxConstraints.expand(width: 800),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: ListView.builder(
                  itemBuilder: (context, index) => Text(
                    (index + 1).toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: numLines,
                ),
              ),
            ),
            Expanded(
              flex: 9,
              child: TextField(
                readOnly: widget.readOnly,
                autofocus: true,
                controller: widget.controller,
                decoration: const InputDecoration(
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      )),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      )),
                  contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      )),
                ),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onChanged: (value) {
                  setState(() {
                    numLines = '\n'.allMatches(value).length + 1;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
    return widget.nestedScroll
        ? child
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: child,
          );
  }
}

import 'package:flutter/material.dart';

class CodeTextField extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  const CodeTextField({
    super.key,
    this.hintText,
    this.controller,
    this.onChanged,
  });

  @override
  State<CodeTextField> createState() => _CodeTextFieldState();
}

class _CodeTextFieldState extends State<CodeTextField> {
  late TextEditingController _controller;
  late ScrollController _scrollController;
  int _lineCount = 1;

  static const double _fontSize = 14.0;
  static const double _lineHeight = 20.0;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _scrollController = ScrollController();
    _controller.addListener(_updateLineCount);
  }

  void _updateLineCount() {
    final text = _controller.text;
    setState(() {
      _lineCount = text.split('\n').length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.black54,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Line numbers
                SizedBox(
                  width: 48,
                  child: Column(
                    children: List.generate(
                      _lineCount,
                      (index) => SizedBox(
                        height: _lineHeight,
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: _fontSize,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Vertical divider
                // Container(
                //   width: 1,
                //   color: Colors.grey.shade300,
                // ),
                // Code editor
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: TextField(
                      controller: _controller,
                      onChanged: (value) {
                        if (widget.onChanged != null) {
                          widget.onChanged!(value);
                        }
                      },
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: _fontSize,
                        height: 1.4,
                      ),
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 0,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }
}

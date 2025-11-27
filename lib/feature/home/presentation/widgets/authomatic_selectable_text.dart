import 'package:flutter/material.dart';

class AutoScrollSelectableText extends StatefulWidget {
  final String text;

  const AutoScrollSelectableText({super.key, required this.text});

  @override
  State<AutoScrollSelectableText> createState() =>
      _AutoScrollSelectableTextState();
}

class _AutoScrollSelectableTextState extends State<AutoScrollSelectableText>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10), // scroll speed
    );

    _controller.addListener(() {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(
          _controller.value * _scrollController.position.maxScrollExtent,
        );
      }
    });
  }

  void _startScroll() {
    _controller.repeat(reverse: true);
  }

  void _stopScroll() {
    _controller.stop();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _startScroll()),
      onExit: (_) => setState(() => _stopScroll()),

      // height: 50, // height of marquee area
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: SelectableText(widget.text, style: TextStyle(fontSize: 14)),
      ),
    );
  }
}

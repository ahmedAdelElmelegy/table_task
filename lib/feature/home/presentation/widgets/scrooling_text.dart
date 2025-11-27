// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:marquee/marquee.dart';

// class ScroolingText extends StatefulWidget {
//   final String text;

//   const ScroolingText({super.key, required this.text});

//   @override
//   State<ScroolingText> createState() => _HoverMarqueeState();
// }

// class _HoverMarqueeState extends State<ScroolingText> {
//   bool _hovering = false;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onLongPress: () {
//         Clipboard.setData(
//           ClipboardData(text: 'This is a scrolling text example'),
//         );
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Copied!')));
//       },
//       onTap: () {},
//       onHover: (value) => setState(() => _hovering = value),
//       // onEnter: (_) => setState(() => _hovering = true),
//       // onExit: (_) => setState(() => _hovering = false),
//       child: _hovering
//           ? Marquee(
//               text: widget.text,

//               blankSpace: 40,
//               startPadding: 8,
//               pauseAfterRound: const Duration(milliseconds: 0),
//             )
//           : Text(widget.text, maxLines: 1, overflow: TextOverflow.ellipsis),
//     );
//   }
// }

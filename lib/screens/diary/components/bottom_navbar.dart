// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:luna/providers/icon_color_provider.dart'; 
// import 'package:luna/widgets/emoji_picker.dart';
// import 'package:flutter_quill/flutter_quill.dart';

// class CustomBottomNavBar extends StatefulWidget {
//   final TextEditingController controller;
//   final FocusNode focusNode;
//   final QuillController quillController;

//   const CustomBottomNavBar({
//     Key? key, 
//     required this.controller,
//     required this.focusNode,
//     required this.quillController,
//   }) : super(key: key);
  
//   @override
//   State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
// }

// class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
//   bool _emojiShowing = false;
//   int _selectedIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     widget.focusNode.addListener(_onFocusChange);
//   }

//   @override
//   void dispose() {
//     widget.focusNode.removeListener(_onFocusChange);
//     super.dispose();
//   }

//   void _onFocusChange() {
//     if (widget.focusNode.hasFocus) {
//       setState(() {
//         _emojiShowing = false;
//         _selectedIndex = 0;
//       });
//     }
//   }

//   void _toggleEmojiPicker() {
//     setState(() {
//       _emojiShowing = !_emojiShowing;
//       if (_emojiShowing) {
//         FocusScope.of(context).unfocus(); 
//       }
//     });
//   }

// void _onItemTapped(int index) {
//   setState(() {
//     _selectedIndex = index;
//     if (index == 2) { 
//       _toggleEmojiPicker();
//     } else {
//       _emojiShowing = false;
//       if (index == 0) {
//         FocusScope.of(context).requestFocus(widget.focusNode);
//         widget.quillController.formatSelection(Attribute.clone(Attribute.bold, null)); 
//       } else if (index == 1) {
//         // Aplicar formato de negrita
//         widget.quillController.formatSelection(Attribute.bold);
//       } else {
//         widget.quillController.formatSelection(Attribute.clone(Attribute.bold, null)); 
//       }
//     }
//   });
// }


//   @override
//   Widget build(BuildContext context) {
//     final iconColor = Provider.of<IconColorProvider>(context).iconColor;
//     final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

//     return WillPopScope(
//       onWillPop: () async {
//         if (_emojiShowing) {
//           setState(() {
//             _emojiShowing = false;
//           });
//           return false;
//         }
//         return true;
//       },
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(20.0),
//                 topRight: Radius.circular(20.0),
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   spreadRadius: 3,
//                   blurRadius: 3,
//                 ),
//               ],
//             ),
//             child: ClipRRect(
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(15.0),
//                 topRight: Radius.circular(15.0),
//               ),
//               child: BottomNavigationBar(
//                 items: const [
//                   BottomNavigationBarItem(
//                     icon: Icon(Icons.text_fields),
//                     label: 'Normal',
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Icon(Icons.format_bold),
//                     label: 'Negrita',
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Icon(Icons.emoji_emotions),
//                     label: 'Emoji',
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Icon(Icons.image),
//                     label: 'Imagen',
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Icon(Icons.favorite),
//                     label: 'Favorito',
//                   ),
//                 ],
//                 currentIndex: _selectedIndex,
//                 selectedItemColor: iconColor,
//                 unselectedItemColor: Colors.grey[400],
//                 onTap: _onItemTapped,
//                 iconSize: 25.0,
//               ),
//             ),
//           ),
//           if (_emojiShowing)
//             SizedBox(
//               child: EmojiPickerWidget(controller: widget.controller),
//             ),
//           SizedBox(height: _emojiShowing ? 0 : bottomPadding),
//         ],
//       )
//     );
//   }
// }
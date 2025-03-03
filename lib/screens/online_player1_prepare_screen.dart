import 'dart:async';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tic_tac_toe/reusable_widgets.dart';
import 'package:tic_tac_toe/screens/online_multiplayer_screen.dart';
import 'package:tic_tac_toe/style.dart';

enum ClickableThings { back, none, clipboard, forward }

class OnlinePlayer1PrepareScreen extends StatefulWidget {
  final String roomID;
  final bool isRoomOwner;
  // ignore: use_key_in_widget_constructors
  const OnlinePlayer1PrepareScreen(
      {required this.roomID, required this.isRoomOwner});

  @override
  State<OnlinePlayer1PrepareScreen> createState() =>
      _OnlinePlayer1PrepareScreenState();
}

class _OnlinePlayer1PrepareScreenState
    extends State<OnlinePlayer1PrepareScreen> {
  final Color onTapColor = const Color(0xff035956);
  String id = '';
  List<int> gameData = [0, 0, 0, 0, 0, 0, 0, 0, 0];
  String roomId = '';
  ClickableThings clickedThings = ClickableThings.none;
  // ignore: non_constant_identifier_names
  int TouchedIndex = -1;
  @override
  void initState() {
    super.initState();
    id = widget.roomID;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'You are player1',
              style: bigFont,
            ),
            const SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              margin: const EdgeInsets.all(36),
              child: const Text(
                'Room ID',
                style: normalFont,
              ),
            ),
            IDCopyboard(
              id: id,
              onTap: () {
                setState(() {
                  clickedThings = ClickableThings.clipboard;
                  Clipboard.setData(ClipboardData(text: id));
                  resetTouchAnimation();
                });
              },
              color: clickedThings == ClickableThings.clipboard
                  ? onTapColor
                  : Colors.white,
              icon: Icons.file_copy_outlined,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ButtonBack(
                    onTap: () {
                      setState(() {
                        clickedThings = ClickableThings.back;
                        resetTouchAnimation();
                        Navigator.pop(context);
                      });
                    },
                    color: clickedThings == ClickableThings.back
                        ? onTapColor
                        : Colors.white,
                  ),
                  ForwardButton(
                    onTap: () {
                      clickedThings = ClickableThings.forward;
                      resetTouchAnimation();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OnlineMultiplayerScreen(
                            isRoomOwner: widget.isRoomOwner,
                            roomID: id,
                          ),
                        ),
                      );
                    },
                    color: clickedThings == ClickableThings.forward
                        ? onTapColor
                        : Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Timer resetTouchAnimation() {
    return Timer(const Duration(milliseconds: 600), () {
      clickedThings = ClickableThings.none;
    });
  }
}

class IDCopyboard extends StatefulWidget {
  final String id;
  final Function onTap;
  final Color color;
  final IconData icon;
  const IDCopyboard(
      {Key? key,
      required this.id,
      required this.onTap,
      required this.color,
      required this.icon})
      : super(key: key);

  @override
  State<IDCopyboard> createState() => _IDCopyboardState();
}

class _IDCopyboardState extends State<IDCopyboard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        dashPattern: const [20, 10],
        color: widget.color,
        strokeWidth: 2,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 20),
              Text(
                widget.id,
                style: smallFont.copyWith(fontSize: 16),
              ),
              IconButton(
                onPressed: () {
                  widget.onTap();
                },
                icon: Icon(widget.icon),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

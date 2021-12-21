import 'dart:ui';
import 'package:flutter/material.dart';

/// Partially visible bottom sheet that can be dragged into the screen. Provides different views for expanded and collapsed states
class DraggableBottomSheet extends StatefulWidget {
  /// Alignment of the sheet
  final Alignment alignment;

  /// This widget will hide behind the sheet when expanded.
  final Widget backgroundWidget;

  /// Whether to blur the background while sheet expnasion (true: modal-sheet false: persistent-sheet)
  final bool blurBackground;

  /// Child of expended sheet
  final Widget expandedChild;

  /// Extent from the min-height to change from previewChild to expandedChild
  final double expansionExtent;

  /// Max-extent for sheet expansion
  final double maxExtent;

  /// Min-extent for the sheet, also the original height of the sheet
  final double minExtent;

  /// Child to be displayed when sheet is not expended
  final Widget previewChild;

  /// Scroll direction of the sheet
  final Axis scrollDirection;

  DraggableBottomSheet({
    this.alignment = Alignment.bottomCenter,
    required this.backgroundWidget,
    this.blurBackground = true,
    required this.expandedChild,
    this.expansionExtent = 10,
    this.maxExtent = double.infinity,
    this.minExtent = 10,
    required this.previewChild,
    this.scrollDirection = Axis.vertical,
  });

  @override
  _DraggableBottomSheetState createState() => _DraggableBottomSheetState();
}

class _DraggableBottomSheetState extends State<DraggableBottomSheet> {
  late double currentHeight;
  late double newHeight;

  @override
  void initState() {
    this.currentHeight = widget.minExtent;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        widget.backgroundWidget,
        (currentHeight - widget.minExtent < 10 || !widget.blurBackground)
            ? SizedBox()
            : Positioned.fill(
            child: GestureDetector(
              onTap: () => setState(() => currentHeight = widget.minExtent),
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                ),
              ),
            )),
        Align(
          alignment: widget.alignment,
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              if (widget.scrollDirection == Axis.horizontal) return;
              newHeight = currentHeight - details.delta.dy;
              if (newHeight > widget.minExtent &&
                  newHeight < widget.maxExtent) {
                setState(() => currentHeight = newHeight);
              }
            },
            child: Container(
              width: double.infinity,
              height: currentHeight,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(blurRadius: 10.0)],
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (currentHeight - widget.minExtent < widget.expansionExtent) ? Container(
                      width: 40,
                      height: 6,
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(10),
                      ),
                    ):  Icon(Icons.keyboard_arrow_down, size: 50, color: Colors.black12,) ,
                    SizedBox(height: 10,),
                    (currentHeight - widget.minExtent < widget.expansionExtent)
                        ? widget.previewChild
                        : widget.expandedChild
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

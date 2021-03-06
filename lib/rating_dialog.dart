library rating_dialog;

import 'package:flutter/material.dart';

class _RatingDialogState extends State<RatingDialog> {
  int _rating = 0;

  @override
  void initState() {
    if (widget.initialRating != null)
      _rating = widget.initialRating;
    super.initState();
  }

  String _comment = '';
  List<Widget> _buildStarRatingButtons() {
    List<Widget> buttons = [];

    for (int rateValue = 1; rateValue <= 5; rateValue++) {
      final starRatingButton = IconButton(
          icon: Icon(_rating >= rateValue ? Icons.star : Icons.star_border,
              color: widget.accentColor, size: 35),
          onPressed: () {
            setState(() {
              _rating = rateValue;
            });
          });
      buttons.add(starRatingButton);
    }

    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    final String commentText =
        _rating >= 4 ? widget.positiveComment : widget.negativeComment;
    // final Color commentColor = _rating >= 4 ? Colors.green[600] : Colors.red;

    return AlertDialog(
      contentPadding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          widget.icon,
          const SizedBox(height: 4),
          widget.title,
          const SizedBox(height: 4),
            widget.description,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildStarRatingButtons(),
          ),
          Visibility(
            visible: _rating > 0,
            child: _buildUserComment(),
          ),
          Visibility(
            visible: _rating > 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Divider(),
                FlatButton(
                  child:
                    widget.submitButton,
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onSubmitPressed(
                      _rating,
                    );
                  },
                ),
                Visibility(
                  visible: commentText.isNotEmpty,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 7),
                      Text(
                        commentText,
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
                Visibility(
                  visible: _rating <= 3 && widget.alternativeButton.isNotEmpty,
                  child: FlatButton(
                    child: Text(
                      widget.alternativeButton,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onAlternativePressed();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserComment() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          maxLines: 1,
          onChanged: (value) {
            _comment = value;
          },
          decoration: InputDecoration(
            hintText: 'Add Comment',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        FlatButton(
            color: widget.accentColor,
            onPressed: () {
              widget.onCommentPressed(_comment);
            },
            child: Text('Comment'))
      ],
    );
  }
}

class RatingDialog extends StatefulWidget {
  final Text title;
  final int initialRating;
  final Text description;
  final Text submitButton;
  final String alternativeButton;
  final String positiveComment;
  final String negativeComment;
  final Widget icon;
  final Color accentColor;
  final ValueSetter<int> onSubmitPressed;
  final ValueSetter<String> onCommentPressed;

  final VoidCallback onAlternativePressed;

  RatingDialog(
      {@required this.icon,
      @required this.title,
      @required this.description,
      @required this.onSubmitPressed,
      @required this.submitButton,
      this.initialRating,
      this.accentColor,
      this.alternativeButton = "",
      this.positiveComment = "",
      this.negativeComment = "",
      this.onAlternativePressed,
      this.onCommentPressed});

  @override
  _RatingDialogState createState() => new _RatingDialogState();
}

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:blizzard_wizzard/models/channel_type.dart';

/// Created by Marcin Szałek

///NumberPicker is a widget designed to pick a number between #minValue and #maxValue
class ChannelTypePicker extends StatelessWidget {
  ///height of every list element
  static const double DEFAULT_ITEM_EXTENT = 89.0;

  ///width of list view
  static const double DEFAULT_LISTVIEW_WIDTH = 1.0;

  ///constructor for integer number picker
  ChannelTypePicker.integer({
    Key key,
    @required int initialValue,
    @required this.onChanged,
    this.itemExtent = DEFAULT_ITEM_EXTENT,
    this.listViewWidth = DEFAULT_LISTVIEW_WIDTH,
    this.step = 1,
  })
      : assert(initialValue != null),
        assert(step > 0),
        selectedIntValue = initialValue,
        intScrollController = new ScrollController(
          initialScrollOffset: (initialValue - 0) ~/ step * itemExtent,
        ),
        _listViewHeight = 3 * itemExtent,
        super(key: key);

  ///called when selected value changes
  final ValueChanged<ChannelTypeReturnValue> onChanged;

  ///min value user can pick
  final int minValue = 0;

  ///max value user can pick
  final int maxValue = ChannelTypes.types.length + 1;

  ///height of every list element in pixels
  final double itemExtent;

  ///view will always contain only 3 elements of list in pixels
  final double _listViewHeight;

  ///width of list view in pixels
  final double listViewWidth;

  ///ScrollController used for integer list
  final ScrollController intScrollController;

  ///Currently selected integer value
  final int selectedIntValue;

  ///Step between elements. Only for integer datePicker
  ///Examples:
  /// if step is 100 the following elements may be 100, 200, 300...
  /// if min=0, max=6, step=3, then items will be 0, 3 and 6
  /// if min=0, max=5, step=3, then items will be 0 and 3.
  final int step;

  //
  //----------------------------- PUBLIC ------------------------------
  //

  animateInt(int valueToSelect) {
    int diff = valueToSelect - minValue;
    int index = diff ~/ step;
    _animate(intScrollController, index * itemExtent);
  }

  //
  //----------------------------- VIEWS -----------------------------
  //

  ///main widget
  @override
  Widget build(BuildContext context) {

    return _integerListView();

  }

  Widget _integerListView() {
    int itemCount = (maxValue - minValue) ~/ step + 1;

    return new NotificationListener(
      child: new Container(
        height: _listViewHeight,
        width: listViewWidth,
        child: new ListView.builder(
          scrollDirection: Axis.horizontal, 
          controller: intScrollController,
          itemExtent: itemExtent,
          itemCount: itemCount,
          cacheExtent: _calculateCacheExtent(itemCount),
          itemBuilder: (BuildContext context, int index) {
            final int value = _intValueFromIndex(index);
            final bool isSelected = value == selectedIntValue;
            ChannelType type;

            bool isExtra = index == 0 || index == itemCount - 1;
            if(!isExtra){
              type = ChannelTypes.types[index - 1];
            }
            return isExtra
            ? Container() //empty first and last element
            : (isSelected) ?
            SelectedChannelType(type) : 
            NotSelectedChannelType(type);   
          },
        ),
      ),
      onNotification: _onIntegerNotification,
    );
  }

  

  //
  // ----------------------------- LOGIC -----------------------------
  //

  int _intValueFromIndex(int index) => minValue + (index - 1) * step;

  bool _onIntegerNotification(Notification notification) {
    if (notification is ScrollNotification) {
      //calculate
      int intIndexOfMiddleElement =
          (notification.metrics.pixels + _listViewHeight / 2) ~/ itemExtent;
      int intValueInTheMiddle = _intValueFromIndex(intIndexOfMiddleElement);
      intValueInTheMiddle = _normalizeIntegerMiddleValue(intValueInTheMiddle);

      if (_userStoppedScrolling(notification, intScrollController)) {
        //center selected value
        animateInt(intValueInTheMiddle);
      }

      //update selection
      if (intValueInTheMiddle != selectedIntValue) {
        ChannelType type = ChannelTypes.types[intValueInTheMiddle];


        onChanged(ChannelTypeReturnValue(
          type.name, 
          type.needsName, 
          type.canHaveSegments, 
          intValueInTheMiddle
        ));
      }
    }
    return true;
  }


  ///There was a bug, when if there was small integer range, e.g. from 1 to 5,
  ///When user scrolled to the top, whole listview got displayed.
  ///To prevent this we are calculating cacheExtent by our own so it gets smaller if number of items is smaller
  double _calculateCacheExtent(int itemCount) {
    double cacheExtent = 250.0; //default cache extent
    if ((itemCount - 2) * DEFAULT_ITEM_EXTENT <= cacheExtent) {
      cacheExtent = ((itemCount - 3) * DEFAULT_ITEM_EXTENT);
    }
    return cacheExtent;
  }

  ///When overscroll occurs on iOS,
  ///we can end up with value not in the range between [minValue] and [maxValue]
  ///To avoid going out of range, we change values out of range to border values.
  int _normalizeMiddleValue(int valueInTheMiddle, int min, int max) {
    return math.max(math.min(valueInTheMiddle, max), min);
  }

  int _normalizeIntegerMiddleValue(int integerValueInTheMiddle) {
    //make sure that max is a multiple of step
    int max = (maxValue ~/ step) * step;
    return _normalizeMiddleValue(integerValueInTheMiddle, minValue, max);
  }

  ///indicates if user has stopped scrolling so we can center value in the middle
  bool _userStoppedScrolling(Notification notification,
      ScrollController scrollController) {
    return notification is UserScrollNotification &&
        notification.direction == ScrollDirection.idle &&
        scrollController.position.activity is! HoldScrollActivity;
  }

  ///scroll to selected value
  _animate(ScrollController scrollController, double value) {
    scrollController.animateTo(value,
        duration: new Duration(seconds: 1), curve: new ElasticOutCurve());
  }
}

class NotSelectedChannelType extends StatelessWidget{
  final ChannelType type;

  NotSelectedChannelType(this.type);
  
  Widget build(BuildContext context) {
    return Center(
      child: Text(type.abv),
    );
  }
}

class SelectedChannelType extends StatelessWidget{
  final ChannelType type;

  SelectedChannelType(this.type);
  
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
            flex: 1,
            child: Text(type.abv),
          ),
          Expanded(
            flex: 1,
            child: Text(type.name),
          ),
          Expanded(
            flex: 1,
            child: Text(type.message),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
        ]
      )
    );
  }
}
import 'package:flutter/material.dart';

/**
 *   ________________
 *  |______888_____ |
 *  ||            ||
 *  ||            ||
 *  ||            ||
 *  ||____________||
 *  |___|__|___|___|
 *
 *
 *
 */

class MyScaffod extends StatefulWidget {
  final int index;
  final double iconSize;
  final IndexedWidgetBuilder appBarBuilder;
  final IndexedWidgetBuilder contentBuilder;
  final IndexedWidgetBuilder emptybuilder;
  final List<BottomNavigationBarItem> itembars;
  final Key key;
  final ValueChanged<int> onIndexChanged;

  const MyScaffod(
      {this.appBarBuilder,
      @required this.contentBuilder,
      @required this.itembars,
      @deprecated this.emptybuilder,
      this.iconSize = 24.0,
      this.index = 0,
      this.onIndexChanged,
      this.key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MaterialScaffodStack();
  }
}

class _EmptyHolder extends StatelessWidget {
  final IndexedWidgetBuilder emptybuilder;
  final int index;

  _EmptyHolder(this.emptybuilder, this.index);

  @override
  Widget build(BuildContext context) {
    return emptybuilder == null ? Center() : emptybuilder(context, index);
  }
}

class _LazyHolder {
  List<Widget> _widgets = [];

  _LazyHolder(IndexedWidgetBuilder builder, BuildContext context, int index,
      int size, IndexedWidgetBuilder emptybuilder) {
    for (int i = 0; i < size; i++) {
      if (index == i)
        _widgets.add(builder(context, index));
      else
        _widgets.add(_EmptyHolder(emptybuilder, i));
    }
  }

  List<Widget> get _widgetlist => _widgets;

  bool isIndexInit(int index) => _widgets[index] is _EmptyHolder;

  void addIfNull(
      IndexedWidgetBuilder builder, BuildContext context, int index) {
    if (isIndexInit(index)) {
      _widgets[index] = builder(context, index);
    }
  }
}

class _MaterialScaffodStack extends State<MyScaffod> {
  int _index;
  _LazyHolder _lazy;

  @override
  void initState() {
    _index = widget.index;
    _lazy = _LazyHolder(widget.contentBuilder, context, _index,
        widget.itembars.length, widget.emptybuilder);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: widget.appBarBuilder == null
            ? null
            : widget.appBarBuilder(context, _index),
        bottomNavigationBar: BottomNavigationBar(
            iconSize: widget.iconSize,
            currentIndex: _index,
            items: widget.itembars,
            onTap: (index) {
              _lazy.addIfNull(widget.contentBuilder, context, index);
              if (widget.onIndexChanged != null) {
                widget.onIndexChanged(index);
              }
              setState(() {
                _index = index;
              });
            },
            type: BottomNavigationBarType.fixed),
        body: IndexedStack(
          index: _index,
          children: _lazy._widgetlist,
        ));
  }
}

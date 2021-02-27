import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math show sin, pi;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HttpLoading {
  static OverlayEntry _overlayEntry;
  static bool _showing = false;

  static void loading(BuildContext context) async {
    try{
      OverlayState overlayState = Overlay.of(context);
      _showing = true;
      if (_overlayEntry == null) {
        _overlayEntry = OverlayEntry(
          builder: (BuildContext context) => Positioned(
            top: MediaQuery.of(context).size.height * 3 / 5,
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: AnimatedOpacity(
                  opacity: _showing ? 1.0 : 0.5,
                  duration: _showing ? Duration(milliseconds: 100) : Duration(milliseconds: 400),
                  child: _buildWidget(),
                ),
              )),
          ));
        overlayState?.insert(_overlayEntry);
      } else {
        _overlayEntry.markNeedsBuild();
      }
    }catch(e){
    }

  }

  static void remove() {
    try{
      if(_overlayEntry != null){
        _overlayEntry?.remove();
        _overlayEntry = null;
      }
    }catch(e){
    }
  }

  // 绘制
  static _buildWidget() {
    return Container(
//      color: Colors.deepOrange,
      width: double.infinity,
      height: 40,
      child: AnimatedCrossFade(
        firstChild: SizedBox(
          width: double.infinity,
          height: 40,
          child: SpinKitThreeBounce(
            color: Colors.deepOrange,
            size: 50.w,
          ),
        ),
        secondChild: SizedBox(
          width: double.infinity,
          height: 40,
        ),
        crossFadeState: CrossFadeState.showFirst,
        duration: Duration(milliseconds: 400),
      ),
    );
  }
}

class SpinKitThreeBounce extends StatefulWidget {
  final Color color;
  final double size;
  final IndexedWidgetBuilder itemBuilder;

  SpinKitThreeBounce({
    Key key,
    this.color,
    this.size,
    this.itemBuilder,
  })  : assert(
  !(itemBuilder is IndexedWidgetBuilder && color is Color) &&
    !(itemBuilder == null && color == null),
  'You should specify either a itemBuilder or a color'),
      assert(size != null),
      super(key: key);

  @override
  _SpinKitThreeBounceState createState() => _SpinKitThreeBounceState();
}

class _SpinKitThreeBounceState extends State<SpinKitThreeBounce>
  with SingleTickerProviderStateMixin {
  AnimationController _scaleCtrl;
  final _duration = const Duration(milliseconds: 1400);

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: _duration,
    )..repeat();
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.fromSize(
        size: Size(widget.size * 2, widget.size),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _circle(0, .0),
            SizedBox(width: 8.w),
            _circle(1, .2),
            SizedBox(width: 8.w),
            _circle(2, .4),
          ],
        ),
      ),
    );
  }

  Widget _circle(int index, double delay) {
    final _size = widget.size * 0.5;
    return ScaleTransition(
      scale: DelayTween(begin: 0.0, end: 1.0, delay: delay).animate(_scaleCtrl),
      child: SizedBox.fromSize(
        size: Size.square(_size),
        child: _itemBuilder(index),
      ),
    );
  }

  Widget _itemBuilder(int index) {
    return widget.itemBuilder != null
      ? widget.itemBuilder(context, index)
      : DecoratedBox(
      decoration: BoxDecoration(
        color: widget.color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class DelayTween extends Tween<double> {
  final double delay;

  DelayTween({
    double begin,
    double end,
    this.delay,
  }) : super(begin: begin, end: end);

  @override
  double lerp(double t) {
    return super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);
  }

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}


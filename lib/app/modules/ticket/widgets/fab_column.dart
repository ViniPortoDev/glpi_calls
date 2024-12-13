import 'package:app_glpi_ios/app/modules/ticket/widgets/expanding_action_button_column.dart';
import 'package:flutter/material.dart';

class ExpandableFabColumn extends StatefulWidget {
  final bool isExpanded;
  final double distance;
  final List<Widget> children;
  final Color backgroundColor;
  final Color foregroundColor;

  const ExpandableFabColumn({
    super.key,
    required this.isExpanded,
    required this.distance,
    required this.children,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  @override
  ExpandableFabColumnState createState() => ExpandableFabColumnState();
}

class ExpandableFabColumnState extends State<ExpandableFabColumn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _expandAnimation;
  bool _isExpanded = false;
  final int _animationDuration = 500;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
    _animationController = AnimationController(
      value: _isExpanded ? 1.0 : 0.0,
      vsync: this,
      duration: Duration(milliseconds: _animationDuration),
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _animationController,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onExpansionChanged() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandigActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
        width: 56,
        height: 56,
        child: Center(
            child: Material(
          color: widget.foregroundColor,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: InkWell(
            onTap: _onExpansionChanged,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.close,
                color: widget.backgroundColor,
              ),
            ),
          ),
        )));
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _isExpanded,
      child: AnimatedContainer(
        //alignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _isExpanded ? 0.1 : 1.0,
          _isExpanded ? 0.1 : 1.0,
          1.0,
        ),
        duration: Duration(milliseconds: _animationDuration),
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
        child: AnimatedOpacity(
          opacity: _isExpanded ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: Duration(milliseconds: _animationDuration),
          child: FloatingActionButton(
            onPressed: () => _onExpansionChanged(),
            backgroundColor: widget.foregroundColor,
            child: SizedBox(
              height: 60,
              width: 60,
              child: Image.asset('assets/images/color_bg.png'),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandigActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    const step = 45;
    for (var i = 0, height = 60.0; i < count; i++, height += step) {
      children.add(
        ExpandingActionButtonColumn(
          height: height,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }
}

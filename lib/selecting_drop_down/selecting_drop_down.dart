// Import necessary packages and files
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Constants for menu animations and dimensions
const double _kMenuCloseIntervalEnd = 2.0 / 3.0;
const Duration _kMenuDuration = Duration(milliseconds: 100);
const double _kMenuScreenPadding = 8.0;
// const double _kMenuWidthStep = 56.0;

/// A stateful widget that keeps its child alive
class BuilderWidgetAlive extends StatefulWidget {
  final Widget child;
  const BuilderWidgetAlive({super.key, required this.child});

  @override
  State<BuilderWidgetAlive> createState() => _BuilderWidgetAliveState();
}

/// A generic dropdown widget
class GeneraicDropDown<T> extends StatelessWidget {
  final Widget Function(BuildContext) child;
  final Offset? offset;
  final Widget Function(
      BuildContext context, Future Function(BuildContext context) onTap) button;
  const GeneraicDropDown(
      {super.key, required this.child, required this.button, this.offset});

  @override
  Widget build(BuildContext context) {
    return button(context, showMenu);
  }

  /// Shows the dropdown menu
  Future<void> showMenu(BuildContext context) async {
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    final RenderBox buttonRenderBox = context.findRenderObject()! as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    final Offset offset;
    offset = const Offset(0.0, -.5);

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        buttonRenderBox.localToGlobal(offset, ancestor: overlay),
        buttonRenderBox.localToGlobal(
            buttonRenderBox.size.bottomRight(Offset.zero) + offset,
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    await Navigator.of(context).push(_SelectingButtonRouter(
        position: RelativeRect.fromLTRB(
            position.left,
            position.top + (this.offset?.dy ?? 0),
            position.right,
            position.bottom),
        elevation: 5,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        shape: popupMenuTheme.shape,
        color: popupMenuTheme.color,
        capturedThemes: InheritedTheme.capture(
            from: context, to: Navigator.of(context).context),
        child: child(context)));
  }
}

/// A widget for selecting items from a list
class SelectingWidget<T> extends StatelessWidget {
  final T? selectedValue;
  final Widget Function(TextEditingController searchText)? searchBar;
  final Widget Function(T value, int) itemBuilder;
  final void Function(T value, int)? onSelect;
  final double? height;
  final double? width;
  final Offset? offset;
  final bool addNone;

  final Widget hintWidget;
  final ValueNotifier<bool> isLoadingAll;
  final ValueNotifier<List<T>> listNotifier;
  final ValueNotifier<bool> isLoadingMore;

  final BoxDecoration decoration;
  final void Function()? onOpen;

  final Widget fullLoadingWidgetPlaceHolder;

  final Widget loadMoreWidgetPlaceHolder;

  final double hintHight;

  const SelectingWidget({
    super.key,
    this.selectedValue,
    this.searchBar,
    required this.itemBuilder,
    this.height,
    this.width,
    this.offset,
    this.addNone = false,
    this.onOpen,
    required this.onSelect,
    required this.hintWidget,
    required this.isLoadingAll,
    required this.listNotifier,
    required this.decoration,
    required this.isLoadingMore,
    required this.fullLoadingWidgetPlaceHolder,
    required this.loadMoreWidgetPlaceHolder,
    required this.hintHight,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: decoration,
      child: InkWell(
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          borderRadius: BorderRadius.circular(8),
          onTap: onSelect != null
              ? () {
                  if (onOpen != null) {
                    onOpen!();
                  }
                  showMenu(context);
                }
              : null,
          child: SizedBox(
            height: hintHight,
            child: Row(
              children: [
                Expanded(
                  child: DefaultTextStyle(
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Theme.of(context).textTheme.bodyLarge!.color),
                    child: hintWidget,
                  ),
                ),
                const Opacity(opacity: 0.7, child: Icon(Icons.arrow_drop_down)),
              ],
            ),
          )),
    );
  }

  /// Shows the selection menu
  showMenu(BuildContext context) async {
    // final size = MediaQuery.of(context).size;
    final width = this.width ?? context.size?.width;

    // final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    final RenderBox buttonRenderBox = context.findRenderObject()! as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    final Offset offset;
    offset = const Offset(0.0, -.5);

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        buttonRenderBox.localToGlobal(offset, ancestor: overlay),
        buttonRenderBox.localToGlobal(
            buttonRenderBox.size.bottomRight(Offset.zero) + offset,
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    await Navigator.of(context).push(_SelectingButtonRouter(
      position: RelativeRect.fromLTRB(
          position.left,
          position.top + (this.offset?.dy ?? 0) + (overlay.size.height * 0.056),
          position.right,
          position.bottom),
      elevation: 0,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      // shape: popupMenuTheme.shape,
      // color: popupMenuTheme.color,
      capturedThemes: InheritedTheme.capture(
          from: context, to: Navigator.of(context).context),
      child: LayoutBuilder(builder: (context, cnt) {
        return DecoratedBox(
          decoration: decoration,
          child: Material(
            color: Colors.transparent,
            child: _BoxPage<T>(
              fullLoadingWidgetPlaceHolder: fullLoadingWidgetPlaceHolder,
              loadMoreWidgetPlaceHolder: loadMoreWidgetPlaceHolder,
              isLoadingMore: isLoadingMore,
              width: width,
              height: height,
              searchBar: searchBar,
              itemBuilder: itemBuilder,
              onSelect: onSelect,
              listNotifier: listNotifier,
              isLoadingAll: isLoadingAll,
              selectedValue: selectedValue,
            ),
          ),
        );
      }),
    ));
  }
}

/// State for the _BoxPage widget
class __BoxPageState<T> extends State<_BoxPage<T>> {
  final searchController = TextEditingController();
  bool preLoading = false;

  Widget box(BuildContext context) => Container(
      height: widget.height ?? 300,
      width: widget.width ?? 400,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 10)),
        ],
      ),
      child: Column(children: [
        if (widget.searchBar != null) widget.searchBar!(searchController),
        AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Visibility(
              key: ValueKey(preLoading),
              visible: preLoading,
              child: const LinearProgressIndicator(
                minHeight: 1,
              ),
            )),
        Expanded(
          child: ValueListenableBuilder(
              valueListenable: widget.isLoadingAll,
              builder: (context, loading, _) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: loading
                      ? widget.fullLoadingWidgetPlaceHolder
                      : ValueListenableBuilder(
                          valueListenable: widget.isLoadingMore,
                          builder: (context, loadingMore, _) {
                            return ValueListenableBuilder(
                                valueListenable: widget.listNotifier,
                                builder: (context, list, _) {
                                  return Column(
                                    children: [
                                      AnimatedSize(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        child: Visibility(
                                            visible: loadingMore,
                                            key: ValueKey(loadingMore),
                                            child: widget
                                                .loadMoreWidgetPlaceHolder),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          addAutomaticKeepAlives: true,
                                          itemCount: list.length,
                                          itemBuilder: (context, index) {
                                            // loadMore(index);
                                            final value = list[index];
                                            return BuilderWidgetAlive(
                                                child: InkWell(
                                                    key: ValueKey(index),
                                                    hoverColor: Colors.grey
                                                        .withOpacity(0.2),
                                                    onTap: widget.onSelect ==
                                                            null
                                                        ? null
                                                        : () {
                                                            widget.onSelect!(
                                                                value, index);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: widget.itemBuilder(
                                                          value, index),
                                                    )));
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          }),
                );
              }),
        ),
      ]));

  @override
  Widget build(BuildContext context) => box(context);

  @override
  dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // controller.loadAll(limit: 10).then((value) {
    //   if (mounted) {
    //     setState(() {
    //       loading = false;
    //       list.addAll(value);
    //     });
    //     controller.stream.forEach((value) {
    //       if (mounted) {
    //         setState(() {
    //           preLoading = value.loading;
    //           list.clear();
    //           list.addAll(controller.elements);
    //         });
    //       }
    //     });
    //   }
    // });

    super.initState();
  }

  // void loadMore(int index) async {
  //   if (controller.data.length <= 9) return;
  //   if (!controller.currentState.loading &&
  //       index == controller.elements.length - 3 &&
  //       controller.hasNext) {
  //     await controller.loadMore();
  //   }
  // }
}

/// A widget that displays a box with a list of selectable items
class _BoxPage<T> extends StatefulWidget {
  final T? selectedValue;
  final Widget Function(TextEditingController searchText)? searchBar;
  final Widget Function(T value, int) itemBuilder;
  final void Function(T value, int)? onSelect;
  final double? height;
  final double? width;

  final ValueNotifier<List<T>> listNotifier;
  final ValueNotifier<bool> isLoadingAll;
  final ValueNotifier<bool> isLoadingMore;

  final Widget fullLoadingWidgetPlaceHolder;

  final Widget loadMoreWidgetPlaceHolder;

  const _BoxPage(
      {super.key,
      this.selectedValue,
      required this.searchBar,
      required this.itemBuilder,
      required this.onSelect,
      this.height,
      this.width,
      required this.listNotifier,
      required this.isLoadingAll,
      required this.isLoadingMore,
      required this.fullLoadingWidgetPlaceHolder,
      required this.loadMoreWidgetPlaceHolder});

  @override
  State<_BoxPage<T>> createState() => __BoxPageState<T>();
}

/// State for the BuilderWidgetAlive
class _BuilderWidgetAliveState extends State<BuilderWidgetAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

/// A layout delegate for positioning the popup menu
class _PopupMenuRouteLayout extends SingleChildLayoutDelegate {
  // Rectangle of underlying button, relative to the overlay's dimensions.
  final RelativeRect position;

  // The sizes of each item are computed when the menu is laid out, and before
  // the route is laid out.
  List<Size?> itemSizes;

  // Whether to prefer going to the left or to the right.
  final TextDirection textDirection;

  // The padding of unsafe area.
  EdgeInsets padding;

  // List of rectangles that we should avoid overlapping. Unusable screen area.
  final Set<Rect> avoidBounds;

  _PopupMenuRouteLayout(
    this.position,
    this.itemSizes,
    this.textDirection,
    this.padding,
    this.avoidBounds,
  );

  // We put the child wherever position specifies, so long as it will fit within
  // the specified parent size padded (inset) by 8. If necessary, we adjust the
  // child's position so that it fits.

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // The menu can be at most the size of the overlay minus 8.0 pixels in each
    // direction.
    return BoxConstraints.loose(constraints.biggest).deflate(
      const EdgeInsets.all(_kMenuScreenPadding) + padding,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // Find the ideal vertical position.
    double y = position.top;

    // Find the ideal horizontal position.
    double x;
    if (position.left > position.right) {
      // Menu button is closer to the right edge, so grow to the left, aligned to the right edge.
      x = size.width - position.right - childSize.width;
    } else if (position.left < position.right) {
      // Menu button is closer to the left edge, so grow to the right, aligned to the left edge.
      x = position.left;
    } else {
      // Menu button is equidistant from both edges, so grow in reading direction.
      switch (textDirection) {
        case TextDirection.rtl:
          x = size.width - position.right - childSize.width;
          break;
        case TextDirection.ltr:
          x = position.left;
          break;
      }
    }
    final Offset wantedPosition = Offset(x, y);
    final Offset originCenter = position.toRect(Offset.zero & size).center;
    final Iterable<Rect> subScreens =
        DisplayFeatureSubScreen.subScreensInBounds(
            Offset.zero & size, avoidBounds);
    final Rect subScreen = _closestScreen(subScreens, originCenter);
    return _fitInsideScreen(subScreen, childSize, wantedPosition);
  }

  @override
  bool shouldRelayout(_PopupMenuRouteLayout oldDelegate) {
    // If called when the old and new itemSizes have been initialized then
    // we expect them to have the same length because there's no practical
    // way to change length of the items list once the menu has been shown.
    assert(itemSizes.length == oldDelegate.itemSizes.length);

    return position != oldDelegate.position ||
        textDirection != oldDelegate.textDirection ||
        !listEquals(itemSizes, oldDelegate.itemSizes) ||
        padding != oldDelegate.padding ||
        !setEquals(avoidBounds, oldDelegate.avoidBounds);
  }

  /// Finds the closest screen to a given point
  Rect _closestScreen(Iterable<Rect> screens, Offset point) {
    Rect closest = screens.first;
    for (final Rect screen in screens) {
      if ((screen.center - point).distance <
          (closest.center - point).distance) {
        closest = screen;
      }
    }
    return closest;
  }

  /// Adjusts the position to fit inside the screen
  Offset _fitInsideScreen(Rect screen, Size childSize, Offset wantedPosition) {
    double x = wantedPosition.dx;
    double y = wantedPosition.dy;
    // Avoid going outside an area defined as the rectangle 8.0 pixels from the
    // edge of the screen in every direction.
    if (x < screen.left + _kMenuScreenPadding + padding.left) {
      x = screen.left + _kMenuScreenPadding + padding.left;
    } else if (x + childSize.width >
        screen.right - _kMenuScreenPadding - padding.right) {
      x = screen.right - childSize.width - _kMenuScreenPadding - padding.right;
    }
    if (y < screen.top + _kMenuScreenPadding + padding.top) {
      y = _kMenuScreenPadding + padding.top;
    } else if (y + childSize.height >
        screen.bottom - _kMenuScreenPadding - padding.bottom) {
      y = screen.bottom -
          childSize.height -
          _kMenuScreenPadding -
          padding.bottom;
    }

    return Offset(x, y);
  }
}

/// A custom popup route for the selecting button
class _SelectingButtonRouter extends PopupRoute {
  @override
  String? barrierLabel;

  final RelativeRect position;
  final Widget child;
  final double? elevation;
  final ShapeBorder? shape;
  final Color? color;
  final CapturedThemes capturedThemes;

  _SelectingButtonRouter(
      {required this.position,
      required this.child,
      this.elevation,
      this.shape,
      this.color,
      required this.capturedThemes,
      this.barrierLabel});
  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => true;
  List<Size?> get itemSizes => [];
  @override
  Duration get transitionDuration => _kMenuDuration;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: SizeTransition(
        sizeFactor: animation,
        child: Builder(
          builder: (BuildContext context) {
            return CustomSingleChildLayout(
              delegate: _PopupMenuRouteLayout(
                position,
                itemSizes,
                Directionality.of(context),
                mediaQuery.padding,
                _avoidBounds(mediaQuery),
              ),
              child: capturedThemes.wrap(child),
            );
          },
        ),
      ),
    );
  }

  @override
  Animation<double> createAnimation() {
    return CurvedAnimation(
      parent: super.createAnimation(),
      curve: Curves.linear,
      reverseCurve: const Interval(0.0, _kMenuCloseIntervalEnd),
    );
  }

  /// Calculates the bounds to avoid when positioning the popup
  Set<Rect> _avoidBounds(MediaQueryData mediaQuery) {
    return DisplayFeatureSubScreen.avoidBounds(mediaQuery).toSet();
  }
}

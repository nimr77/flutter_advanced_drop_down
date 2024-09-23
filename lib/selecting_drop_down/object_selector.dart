import 'package:flutter/material.dart';

import 'selecting_drop_down.dart';

/// A widget that allows selecting an object from a list with optional search and add functionality.
///
/// This widget creates a dropdown-like selector with customizable appearance and behavior.
class FlutterAdvancedDropDown<T> extends StatelessWidget {
  /// Callback function when the add button is tapped.
  final void Function()? onAddTap;

  /// The label text displayed above the selector.
  final String label;

  /// Callback function when an item is selected. It provides the selected item and its index.
  final void Function(T?, int)? onSelect;

  /// Function to build the appearance of each item in the list.
  final Widget Function(T, int) builder;

  /// Widget to display as the title/hint when no item is selected.
  final Widget titleWidget;

  /// Whether to add a "None" option to the list.
  final bool addNone;

  /// Function to build the search bar widget.
  final Widget Function(TextEditingController) searchBarBuilder;

  /// Notifier to indicate whether the list is currently loading.
  final ValueNotifier<bool> isLoadingAll;

  /// Notifier to indicate whether more items are being loaded.
  final ValueNotifier<bool> isLoadingMore;

  /// Notifier that holds the list of selectable items.
  final ValueNotifier<List<T>> listNotifier;

  /// The currently selected value.
  final T? selectedValue;

  /// The decoration applied to the dropdown container.
  final BoxDecoration decoration;

  /// Callback function when the dropdown is opened.
  final void Function()? onOpen;

  /// The height of the hint widget.
  final double hintHight;

  /// Widget to display when the full list is loading.
  final Widget fullLoadingWidgetPlaceHolder;

  /// Widget to display when loading more items.
  final Widget loadMoreWidgetPlaceHolder;

  /// Creates an [FlutterAdvancedDropDown] widget.
  ///
  /// The [builder], [onSelect], [searchBarBuilder], [titleWidget], [isLoadingAll],
  /// [listNotifier], [decoration], [isLoadingMore], [fullLoadingWidgetPlaceHolder],
  /// and [loadMoreWidgetPlaceHolder] parameters are required.
  const FlutterAdvancedDropDown({
    super.key,
    this.onAddTap,
    this.label = "",
    this.addNone = false,
    this.onOpen,
    required this.builder,
    required this.onSelect,
    required this.searchBarBuilder,
    required this.titleWidget,
    required this.isLoadingAll,
    required this.listNotifier,
    this.selectedValue,
    required this.decoration,
    required this.isLoadingMore,
    this.hintHight = 50,
    required this.fullLoadingWidgetPlaceHolder,
    required this.loadMoreWidgetPlaceHolder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              label,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        Padding(
          padding:
              label.isEmpty ? EdgeInsets.zero : const EdgeInsets.only(top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SelectingWidget<T>(
                  onOpen: onOpen,
                  decoration: decoration,
                  isLoadingAll: isLoadingAll,
                  listNotifier: listNotifier,
                  addNone: addNone,
                  selectedValue: selectedValue,
                  onSelect: onSelect,
                  hintWidget: titleWidget,
                  searchBar: (str) => Container(
                    height: 50,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
                    child: searchBarBuilder(str),
                  ),
                  itemBuilder: builder,
                  isLoadingMore: isLoadingMore,
                  fullLoadingWidgetPlaceHolder: fullLoadingWidgetPlaceHolder,
                  loadMoreWidgetPlaceHolder: loadMoreWidgetPlaceHolder,
                  hintHight: hintHight,
                ),
              ),
              if (onAddTap != null) const SizedBox(width: 16),
              if (onAddTap != null)
                OutlinedButton(
                  onPressed: onAddTap,
                  child: const Icon(Icons.add),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

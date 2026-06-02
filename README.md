# Flutter Advanced Dropdown

An advanced and customizable dropdown widget for Flutter applications.

## Features

- Custom item UI with your own `builder`
- Search support through a custom `searchBarBuilder`
- Optional add button with `onAddTap`
- Loading states for initial load and incremental loading
- Works well with async APIs using `ValueNotifier`
- Fully customizable container decoration

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_advanced_drop_down: ^0.5.2
```

Then run:

```bash
flutter pub get
```

## Import

```dart
import 'package:flutter_advanced_drop_down/selecting_drop_down/object_selector.dart';
```

## Quick Start

```dart
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drop_down/selecting_drop_down/object_selector.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const DropdownDemoPage(),
      theme: ThemeData(useMaterial3: true),
    );
  }
}

class DropdownDemoPage extends StatefulWidget {
  const DropdownDemoPage({super.key});

  @override
  State<DropdownDemoPage> createState() => _DropdownDemoPageState();
}

class _DropdownDemoPageState extends State<DropdownDemoPage> {
  final allItems = List<String>.generate(100, (i) => 'Item $i');

  final isLoadingAll = ValueNotifier<bool>(false);
  final isLoadingMore = ValueNotifier<bool>(false);
  final listNotifier = ValueNotifier<List<String>>([]);

  String? selectedValue;

  @override
  void initState() {
    super.initState();
    _loadInitialItems();
  }

  Future<void> _loadInitialItems() async {
    isLoadingAll.value = true;
    await Future.delayed(const Duration(milliseconds: 700));
    listNotifier.value = allItems;
    isLoadingAll.value = false;
  }

  Future<void> _searchItems(String query) async {
    isLoadingMore.value = true;
    await Future.delayed(const Duration(milliseconds: 250));

    if (query.isEmpty) {
      listNotifier.value = allItems;
    } else {
      listNotifier.value = allItems
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    isLoadingMore.value = false;
  }

  @override
  void dispose() {
    isLoadingAll.dispose();
    isLoadingMore.dispose();
    listNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Advanced Dropdown')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FlutterAdvancedDropDown<String>(
              label: 'Choose an option',
              titleWidget: Text(selectedValue ?? 'Select an item'),
              selectedValue: selectedValue,
              listNotifier: listNotifier,
              isLoadingAll: isLoadingAll,
              isLoadingMore: isLoadingMore,
              builder: (item, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(item),
              ),
              searchBarBuilder: (controller) => TextField(
                controller: controller,
                onChanged: _searchItems,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  border: OutlineInputBorder(),
                ),
              ),
              onSelect: (value, index) {
                setState(() => selectedValue = value);
              },
              onAddTap: () {
                // Add new item logic
              },
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              fullLoadingWidgetPlaceHolder: const Center(
                child: CircularProgressIndicator(),
              ),
              loadMoreWidgetPlaceHolder: const LinearProgressIndicator(),
            ),
            const SizedBox(height: 16),
            Text('Selected value: ${selectedValue ?? 'None'}'),
          ],
        ),
      ),
    );
  }
}
```

## Required Parameters

- `builder`: builds each list item
- `onSelect`: called when an item is selected
- `searchBarBuilder`: builds the search input
- `titleWidget`: widget shown in closed state
- `isLoadingAll`: notifier for initial/full loading state
- `isLoadingMore`: notifier for loading-more/search state
- `listNotifier`: notifier containing current options
- `decoration`: decoration for the dropdown container
- `fullLoadingWidgetPlaceHolder`: widget shown when fully loading
- `loadMoreWidgetPlaceHolder`: widget shown when loading more

## Optional Parameters

- `label`: text shown above the dropdown
- `selectedValue`: currently selected value
- `onOpen`: callback invoked when dropdown opens
- `onAddTap`: shows add button and handles add action
- `addNone`: includes a "None" option
- `hintHight`: closed dropdown height

## Notes

- Update `listNotifier.value` whenever your API/search results change.
- Use `isLoadingAll` for first load and `isLoadingMore` for search/pagination.
- The package includes a full runnable example in the `example` folder.

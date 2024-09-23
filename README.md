# Flutter Advanced Dropdown

A customizable and feature-rich dropdown widget for Flutter applications.

## Features

- Customizable appearance with BoxDecoration
- Optional search functionality
- "Add" button for creating new items
- Support for loading indicators (full list and load more)
- Customizable item builder
- Optional "None" selection
- Callback for item selection
- Support for asynchronous data loading
- Support for search by using the value notifier

## Getting started

To use this package, add `flutter_advanced_dropdown` as a dependency in your `pubspec.yaml` file.


dependencies:
  flutter_advanced_dropdown: ^1.0.0


Then, import the package in your Dart code:


import 'package:flutter_advanced_dropdown/flutter_advanced_dropdown.dart';


## Usage

Here's a basic example of how to use the FlutterAdvancedDropDown widget:


FlutterAdvancedDropDown<String>(
  label: 'Select an item',
  titleWidget: Text('Choose an option'),
  onSelect: (value, index) {
    print('Selected: $value at index $index');
  },
  builder: (item, index) => Text(item),
  searchBarBuilder: (controller) => TextField(controller: controller),
  isLoadingAll: ValueNotifier<bool>(false),
  isLoadingMore: ValueNotifier<bool>(false),
  listNotifier: ValueNotifier<List<String>>(['Option 1', 'Option 2', 'Option 3']),
  decoration: BoxDecoration(
    border: Border.all(color: Colors.grey),
    borderRadius: BorderRadius.circular(8),
  ),
  fullLoadingWidgetPlaceHolder: CircularProgressIndicator(),
  loadMoreWidgetPlaceHolder: Text('Loading more...'),
)


## Additional information

For more advanced usage and customization options, please refer to the API documentation. If you encounter any issues or have feature requests, please file them on the [GitHub repository](https://github.com/yourusername/flutter_advanced_dropdown/issues).

Contributions are welcome! Please see our [contributing guidelines](https://github.com/yourusername/flutter_advanced_dropdown/blob/main/CONTRIBUTING.md) for more information on how to get started.

For updates and announcements, follow us on [Twitter](https://twitter.com/yourusername).

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
      title: 'DynamicDropdown Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'DynamicDropdown Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final staticList = List<String>.generate(100, (index) => 'Item $index');

  String? selectedValue;

  final loading = ValueNotifier<bool>(false);
  final loadingMore = ValueNotifier<bool>(false);
  final listNotifier = ValueNotifier<List<String>>([]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Select an option:',
            ),
            FlutterAdvancedDropDown<String>(
                builder: (item, _) => Text(item),
                onOpen: () {
                  loading.value = true;
                  Future.delayed(
                    const Duration(seconds: 2),
                    () {
                      listNotifier.value = staticList;
                      loading.value = false;
                    },
                  );
                },
                isLoadingAll: loading,
                isLoadingMore: loadingMore,
                listNotifier: listNotifier,
                titleWidget: const Text('Select an option:'),
                label: 'Select an option',
                searchBarBuilder: (p0) => TextField(onChanged: (value) async {
                      if (value.isEmpty) {
                        listNotifier.value = staticList;
                        return;
                      }
                      loadingMore.value = true;
                      await Future.delayed(
                        const Duration(seconds: 2),
                        () {
                          listNotifier.value = staticList
                              .where((element) => element.contains(value))
                              .toList();
                        },
                      );
                      loadingMore.value = false;
                    }),
                onSelect: (p0, p1) {
                  setState(() {
                    selectedValue = p0;
                  });
                },
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                fullLoadingWidgetPlaceHolder: const Center(
                    child: CircularProgressIndicator(
                  color: Colors.blue,
                )),
                loadMoreWidgetPlaceHolder: const LinearProgressIndicator(
                  color: Colors.blue,
                )),
            const SizedBox(height: 20),
            Text(
              'Selected value: ${selectedValue ?? "None"}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    loading.value = true;
    Future.delayed(const Duration(seconds: 2)).then((value) {
      loading.value = false;
      listNotifier.value = staticList;
    });
  }
}

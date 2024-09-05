import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'user_model.dart';

class DialogExamplesPage extends StatefulWidget {
  @override
  _DialogExamplesPageState createState() => _DialogExamplesPageState();
}

class _DialogExamplesPageState extends State<DialogExamplesPage> {
  final _formKey = GlobalKey<FormState>();
  final _openDropDownProgKey = GlobalKey<DropdownSearchState<int>>();
  final _multiKey = GlobalKey<DropdownSearchState<String>>();
  final _popupCustomValidationKey = GlobalKey<DropdownSearchState<int>>();
  final _userEditTextController = TextEditingController(text: 'Mrs');
  final myKey = GlobalKey<DropdownSearchState<MultiLevelString>>();
  var w = Icon(Icons.alarm);
  final List<MultiLevelString> myItems = [
    MultiLevelString(level1: "1"),
    MultiLevelString(level1: "2"),
    MultiLevelString(
      level1: "3",
      subLevel: [
        MultiLevelString(level1: "sub3-1"),
        MultiLevelString(level1: "sub3-2"),
      ],
    ),
    MultiLevelString(level1: "4")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("DropdownSearch Demo")),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: EdgeInsets.all(4),
            children: <Widget>[
              ///************************[simple examples for single and multi selection]************///
              Text("[simple examples for single and multi selection]"),
              Divider(),
              Row(
                children: [
                  DropdownSearch<int>(
                    mode: Mode.CUSTOM,
                    items: (f, cs) => [10000],
                    dropdownBuilder: (context, selectedItem) => w,
                    popupProps: PopupProps.menu(
                      menuProps: MenuProps(),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  Expanded(
                    child: DropdownSearch<int>.multiSelection(
                      clearButtonProps: ClearButtonProps(isVisible: true),
                      items: (f, cs) => [1, 2, 3, 4, 5, 6, 7],
                      popupProps: PopupPropsMultiSelection.menu(),
                    ),
                  )
                ],
              ),

              ///************************[simple examples for each mode]*************************///
              Padding(padding: EdgeInsets.all(8)),
              Text("[simple examples for each mode]"),
              Divider(),
              Row(
                children: [
                  Expanded(
                    child: DropdownSearch<int>(
                      items: (f, cs) => [1, 2, 3, 4, 5, 6, 7],
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  Expanded(
                    child: DropdownSearch<int>.multiSelection(
                      key: _popupCustomValidationKey,
                      items: (f, cs) => [1, 2, 3, 4, 5, 6, 7],
                      popupProps: PopupPropsMultiSelection.dialog(
                        validationWidgetBuilder: (ctx, selectedItems) {
                          return Container(
                            color: Colors.blue[200],
                            height: 56,
                            child: Align(
                              alignment: Alignment.center,
                              child: MaterialButton(
                                child: Text('OK'),
                                onPressed: () {
                                  _popupCustomValidationKey.currentState?.popupOnValidate();
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.all(4)),
              Row(
                children: [
                  Expanded(
                    child: DropdownSearch<int>(
                      items: (f, cs) => [1, 2, 3, 4, 5, 6, 7],
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "BottomSheet mode",
                          hintText: "Select an Int",
                        ),
                      ),
                      popupProps: PopupProps.bottomSheet(
                          bottomSheetProps: BottomSheetProps(elevation: 16, backgroundColor: Color(0xFFAADCEE))),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  Expanded(
                    child: DropdownSearch<int>(
                      items: (f, cs) => [1, 2, 3, 4, 5, 6, 7],
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Modal mode",
                          hintText: "Select an Int",
                          filled: true,
                        ),
                      ),
                      popupProps: PopupPropsMultiSelection.modalBottomSheet(
                        disabledItemFn: (int i) => i <= 3,
                      ),
                    ),
                  )
                ],
              ),

              ///************************[Favorites examples]**********************************///
              Padding(padding: EdgeInsets.all(8)),
              Text("[Favorites examples]"),
              Divider(),
              Row(
                children: [
                  Expanded(
                    child: DropdownSearch<UserModel>(
                      items: (filter, t) => getData(filter),
                      compareFn: (i, s) => i.isEqual(s),
                      popupProps: PopupPropsMultiSelection.modalBottomSheet(
                        showSelectedItems: true,
                        showSearchBox: true,
                        itemBuilder: _customPopupItemBuilderExample2,
                        suggestedItemProps: SuggestedItemProps(
                          showSuggestedItems: true,
                          suggestedItems: (us) {
                            return us.where((e) => e.name.contains("Mrs")).toList();
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  Expanded(
                    child: DropdownSearch<UserModel>.multiSelection(
                      items: (filter, s) => getData(filter),
                      compareFn: (i, s) => i.isEqual(s),
                      popupProps: PopupPropsMultiSelection.modalBottomSheet(
                        showSearchBox: true,
                        itemBuilder: _customPopupItemBuilderExample2,
                        suggestedItemProps: SuggestedItemProps(
                          showSuggestedItems: true,
                          suggestedItems: (us) {
                            return us.where((e) => e.name.contains("Mrs")).toList();
                          },
                          suggestedItemBuilder: (context, item, isSelected) {
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey[100]),
                              child: Row(
                                children: [
                                  Text(
                                    "${item.name}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.indigo),
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 8)),
                                  isSelected ? Icon(Icons.check_box_outlined) : SizedBox.shrink(),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              ///************************[validation examples]********************************///
              Padding(padding: EdgeInsets.all(8)),
              Text("[validation examples]"),
              Divider(),
              Row(
                children: [
                  Expanded(
                    child: DropdownSearch<int>(
                      items: (f, cs) => [1, 2, 3, 4, 5, 6, 7],
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      validator: (int? i) {
                        if (i == null)
                          return 'required filed';
                        else if (i >= 5) return 'value should be < 5';
                        return null;
                      },
                      clearButtonProps: ClearButtonProps(isVisible: true),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  Expanded(
                    child: DropdownSearch<int>.multiSelection(
                      items: (f, cs) => [1, 2, 3, 4, 5, 6, 7],
                      validator: (List<int>? items) {
                        if (items == null || items.isEmpty)
                          return 'required filed';
                        else if (items.length > 3) return 'only 1 to 3 items are allowed';
                        return null;
                      },
                    ),
                  )
                ],
              ),

              ///************************[custom popup background examples]********************************///
              Padding(padding: EdgeInsets.all(8)),
              Text("[custom popup background examples]"),
              Divider(),
              DropdownSearch<String>(
                items: (f, cs) => List.generate(5, (index) => "$index"),
                popupProps: PopupProps.menu(
                  fit: FlexFit.loose,
                  menuProps: MenuProps(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  containerBuilder: (ctx, popupWidget) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Image.asset(
                            'assets/images/arrow-up.png',
                            color: Color(0xFF2F772A),
                            height: 12,
                          ),
                        ),
                        Flexible(
                          child: Container(
                            child: popupWidget,
                            color: Color(0xFF2F772A),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Padding(padding: EdgeInsets.all(8)),
              Row(
                children: [
                  Expanded(
                    child: _dropdownWithGlobalCheckBox(),
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  Expanded(
                    child: DropdownSearch<String>.multiSelection(
                      key: _multiKey,
                      items: (f, cs) => List.generate(30, (index) => "$index"),
                      popupProps: PopupPropsMultiSelection.dialog(
                        showSearchBox: true,
                        containerBuilder: (ctx, popupWidget) {
                          return Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: OutlinedButton(
                                      onPressed: () {
                                        // How should I unselect all items in the list?
                                        _multiKey.currentState?.closeDropDownSearch();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: OutlinedButton(
                                      onPressed: () {
                                        // How should I select all items in the list?
                                        _multiKey.currentState?.popupSelectAllItems();
                                      },
                                      child: const Text('All'),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: OutlinedButton(
                                      onPressed: () {
                                        // How should I unselect all items in the list?
                                        _multiKey.currentState?.popupDeselectAllItems();
                                      },
                                      child: const Text('None'),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(child: popupWidget),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),

              ///************************[dropdownBuilder examples]********************************///
              Padding(padding: EdgeInsets.all(8)),
              Text("[DropDownSearch builder examples]"),
              Divider(),
              Row(
                children: [
                  Expanded(
                    child: DropdownSearch<UserModel>.multiSelection(
                      items: (filter, t) => getData(filter),
                      clearButtonProps: ClearButtonProps(isVisible: true),
                      popupProps: PopupPropsMultiSelection.modalBottomSheet(
                        showSelectedItems: true,
                        itemBuilder: _customPopupItemBuilderExample2,
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          controller: _userEditTextController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                _userEditTextController.clear();
                              },
                            ),
                          ),
                        ),
                      ),
                      compareFn: (item, selectedItem) => item.id == selectedItem.id,
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: 'Users *',
                          filled: true,
                          fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                        ),
                      ),
                      dropdownBuilder: _customDropDownExampleMultiSelection,
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  Expanded(
                    child: DropdownSearch<UserModel>(
                      items: (filter, t) => getData(filter),
                      popupProps: PopupPropsMultiSelection.modalBottomSheet(
                        showSelectedItems: true,
                        itemBuilder: _customPopupItemBuilderExample2,
                        showSearchBox: true,
                      ),
                      compareFn: (item, sItem) => item.id == sItem.id,
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: 'User *',
                          filled: true,
                          fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              ///************************[Dynamic height depending on items number]********************************///
              Padding(padding: EdgeInsets.all(8)),
              Text("[popup dynamic height examples]"),
              Divider(),
              Row(
                children: [
                  Expanded(
                    child: DropdownSearch<int>(
                      items: (f, cs) => List.generate(50, (i) => i),
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        title: Text('default fit'),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  Expanded(
                    child: DropdownSearch<int>(
                      items: (f, cs) => List.generate(50, (i) => i),
                      popupProps: PopupProps.menu(
                        title: Text('With fit to loose and no constraints'),
                        showSearchBox: true,
                        fit: FlexFit.loose,
                        //comment this if you want that the items do not takes all available height
                        constraints: BoxConstraints.tightFor(),
                      ),
                    ),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.all(4)),
              Row(
                children: [
                  Expanded(
                    child: DropdownSearch<int>(
                      items: (f, cs) => List.generate(50, (i) => i),
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        fit: FlexFit.loose,
                        title: Text('fit to a specific max height'),
                        constraints: BoxConstraints(maxHeight: 300),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  Expanded(
                    child: DropdownSearch<int>(
                      items: (f, cs) => List.generate(50, (i) => i),
                      popupProps: PopupProps.menu(
                        title: Text('fit to a specific width and height'),
                        showSearchBox: true,
                        fit: FlexFit.loose,
                        constraints: BoxConstraints.tightFor(
                          width: 300,
                          height: 300,
                        ),
                      ),
                    ),
                  )
                ],
              ),

              ///************************[Handle dropdown programmatically]********************************///
              Padding(padding: EdgeInsets.all(8)),
              Text("[handle dropdown programmatically]"),
              Divider(),
              DropdownSearch<int>(
                key: _openDropDownProgKey,
                items: (f, cs) => [1, 2, 3],
              ),
              Padding(padding: EdgeInsets.all(4)),
              ElevatedButton(
                onPressed: () {
                  _openDropDownProgKey.currentState?.changeSelectedItem(100);
                },
                child: Text('set to 100'),
              ),
              Padding(padding: EdgeInsets.all(4)),
              ElevatedButton(
                onPressed: () {
                  _openDropDownProgKey.currentState?.openDropDownSearch();
                },
                child: Text('open popup'),
              ),

              ///************************[multiLevel items example]********************************///
              Padding(padding: EdgeInsets.all(8)),
              Text("[multiLevel items example]"),
              Divider(),
              DropdownSearch<MultiLevelString>(
                key: myKey,
                items: (f, cs) => myItems,
                compareFn: (i1, i2) => i1.level1 == i2.level1,
                popupProps: PopupProps.menu(
                  showSelectedItems: true,
                  interceptCallBacks: true, //important line
                  itemBuilder: (ctx, item, isSelected) {
                    return ListTile(
                      selected: isSelected,
                      title: Text(item.level1),
                      trailing: item.subLevel.isEmpty
                          ? null
                          : (item.isExpanded
                              ? IconButton(
                                  icon: Icon(Icons.arrow_drop_down),
                                  onPressed: () {
                                    item.isExpanded = !item.isExpanded;
                                    myKey.currentState?.updatePopupState();
                                  },
                                )
                              : IconButton(
                                  icon: Icon(Icons.arrow_right),
                                  onPressed: () {
                                    item.isExpanded = !item.isExpanded;
                                    myKey.currentState?.updatePopupState();
                                  },
                                )),
                      subtitle: item.subLevel.isNotEmpty && item.isExpanded
                          ? Container(
                              height: item.subLevel.length * 50,
                              child: ListView(
                                children: item.subLevel
                                    .map(
                                      (e) => ListTile(
                                        selected: myKey.currentState?.getSelectedItem?.level1 == e.level1,
                                        title: Text(e.level1),
                                        onTap: () {
                                          myKey.currentState?.popupValidate([e]);
                                        },
                                      ),
                                    )
                                    .toList(),
                              ),
                            )
                          : null,
                      onTap: () => myKey.currentState?.popupValidate([item]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _customDropDownExampleMultiSelection(BuildContext context, List<UserModel> selectedItems) {
    if (selectedItems.isEmpty) {
      return ListTile(
        contentPadding: EdgeInsets.all(0),
        leading: CircleAvatar(),
        title: Text("No item selected"),
      );
    }

    return Wrap(
      children: selectedItems.map((e) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            child: ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(e.avatar),
              ),
              title: Text(e.name),
              subtitle: Text(
                e.createdAt.toString(),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _customPopupItemBuilderExample2(BuildContext context, UserModel item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item.name),
        subtitle: Text(item.createdAt.toString()),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(item.avatar),
        ),
      ),
    );
  }

  Future<List<UserModel>> getData(filter) async {
    var response = await Dio().get(
      "https://63c1210999c0a15d28e1ec1d.mockapi.io/users",
      queryParameters: {"filter": filter},
    );

    final data = response.data;
    if (data != null) {
      return UserModel.fromJsonList(data);
    }

    return [];
  }
}

class _dropdownWithGlobalCheckBox extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _dropdownWithGlobalCheckBoxState();
}

class _dropdownWithGlobalCheckBoxState extends State<_dropdownWithGlobalCheckBox> {
  final _popupBuilderKey = GlobalKey<DropdownSearchState<int>>();
  final ValueNotifier<bool?> longListCheckBoxValueNotifier = ValueNotifier(false);
  final longList = List.generate(110, (i) => i + 1);

  bool? _getCheckBoxState() {
    var selectedItem = _popupBuilderKey.currentState?.popupGetSelectedItems ?? [];
    var isAllSelected = _popupBuilderKey.currentState?.popupIsAllItemSelected ?? false;
    return selectedItem.isEmpty ? false : (isAllSelected ? true : null);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<int>.multiSelection(
      key: _popupBuilderKey,
      items: (f, ic) {
        return Future.delayed(Duration(seconds: 1), () {
          var list = f.isEmpty ? longList : longList.where((l) => l.toString().contains(f));

          return list.skip(ic!.skip).take(ic.take).toList();
        });
      },
      popupProps: PopupPropsMultiSelection.dialog(
        onItemAdded: (l, s) => longListCheckBoxValueNotifier.value = _getCheckBoxState(),
        onItemRemoved: (l, s) => longListCheckBoxValueNotifier.value = _getCheckBoxState(),
        onItemsLoaded: (value) => longListCheckBoxValueNotifier.value = _getCheckBoxState(),
        infiniteScrollProps: InfiniteScrollProps(skip: 0, take: 10),
        showSearchBox: true,
        containerBuilder: (ctx, popupWidget) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(24)),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xF44336), Colors.blue],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Select: '),
                      ValueListenableBuilder(
                        valueListenable: longListCheckBoxValueNotifier,
                        builder: (context, value, child) {
                          return Checkbox(
                            value: longListCheckBoxValueNotifier.value,
                            tristate: true,
                            onChanged: (bool? v) {
                              if (v == null) v = false;
                              if (v == true)
                                _popupBuilderKey.currentState?.popupSelectAllItems();
                              else if (v == false) _popupBuilderKey.currentState?.popupDeselectAllItems();
                              longListCheckBoxValueNotifier.value = v;
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(child: popupWidget),
              ],
            ),
          );
        },
      ),
    );
  }
}

class MultiLevelString {
  final String level1;
  final List<MultiLevelString> subLevel;
  bool isExpanded;

  MultiLevelString({
    this.level1 = "",
    this.subLevel = const [],
    this.isExpanded = false,
  });

  MultiLevelString copy({
    String? level1,
    List<MultiLevelString>? subLevel,
    bool? isExpanded,
  }) =>
      MultiLevelString(
        level1: level1 ?? this.level1,
        subLevel: subLevel ?? this.subLevel,
        isExpanded: isExpanded ?? this.isExpanded,
      );

  @override
  String toString() => level1;
}
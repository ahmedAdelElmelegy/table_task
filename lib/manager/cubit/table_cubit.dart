import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:table_task2/feature/home/presentation/model/item_model.dart';

part 'table_state.dart';

class TableCubit extends Cubit<TableState> {
  TableCubit() : super(TableInitial());

  List<GlobalKey<FormState>> formKey = List.generate(
    4,
    (_) => GlobalKey<FormState>(),
  );

  List<bool> formHasError = List.generate(4, (_) => false);
  List<ItemModel> items = [];
  int numberOfForms = 4;

  List<TextEditingController> nameControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  List<TextEditingController> priceControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  List<TextEditingController> descControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  List<List<dynamic>> tagsControllers = List.generate(4, (index) => []);
  PageController pageController = PageController();
  bool isUpdate = false;
  void updateValue(bool value) {
    isUpdate = value;
    // emit(TableUpdated());
  }

  // Validate all forms
  bool validateAllForms() {
    bool allValid = true;

    for (int i = 0; i < numberOfForms; i++) {
      final formState = formKey[i].currentState;
      if (formState != null) {
        if (formState.validate()) {
          formHasError[i] = false;
        } else {
          formHasError[i] = true;
          allValid = false;
        }
      } else {
        formHasError[i] = true;
        allValid = false;
      }
    }

    emit(TableValidationUpdated());
    return allValid;
  }

  // Add items to table with validation
  void addItemsToTable() async {
    emit(TableLoading());
    await Future.delayed(Duration(milliseconds: 500));

    try {
      for (int i = 0; i < numberOfForms; i++) {
        items.add(
          ItemModel(
            name: nameControllers[i].text,
            price: double.parse(priceControllers[i].text),
            description: descControllers[i].text,
            tags: tagsControllers[i].map((e) => e.toString()).toList(),
            actions: Icon(Icons.edit),
          ),
        );
      }
      // clearAllForms();

      emit(TableLoaded());
      clearAllForms();
    } catch (e) {
      emit(TableError('Error saving items: $e'));
    }
  }

  // Clear all forms
  void clearAllForms() {
    for (int i = 0; i < numberOfForms; i++) {
      nameControllers[i].clear();
      priceControllers[i].clear();
      descControllers[i].clear();
      tagsControllers[i].clear();
      formKey[i] = GlobalKey<FormState>(); // Reset form key
      formHasError[i] = false;
    }
    emit(TableCleared());
  }

  // Check if form has data
  bool formHasData(int index) {
    return nameControllers[index].text.isNotEmpty ||
        priceControllers[index].text.isNotEmpty ||
        descControllers[index].text.isNotEmpty ||
        tagsControllers[index].isNotEmpty;
  }

  @override
  Future<void> close() {
    // Dispose all controllers
    for (var controller in nameControllers) {
      controller.dispose();
    }
    for (var controller in priceControllers) {
      controller.dispose();
    }
    for (var controller in descControllers) {
      controller.dispose();
    }
    return super.close();
  }

  void updateItem(int index, ItemModel item) async {
    updateValue(true);
    emit(TableLoading());
    await Future.delayed(Duration(milliseconds: 500));

    debugPrint('Updating item at index: $index, name: ${item.name}');

    // Populate the form with existing data
    nameControllers[index].text = item.name;
    priceControllers[index].text = item.price.toString();
    descControllers[index].text = item.description;
    tagsControllers[index] = List.from(item.tags);

    // Navigate to the specific form page
    pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    emit(UpdateItem());
  }

  // Save updated item
  void saveUpdatedItem(int index) async {
    emit(TableLoading());
    await Future.delayed(Duration(milliseconds: 500));
    // Update the item in the list
    if (index < items.length) {
      items[index] = ItemModel(
        name: nameControllers[index].text,
        price: double.parse(priceControllers[index].text),
        description: descControllers[index].text,
        tags: tagsControllers[index].map((e) => e.toString()).toList(),
        actions: Icon(Icons.edit),
      );
      emit(TableLoaded());
      clearAllForms();
      updateValue(false);
    }
  }

  void deleteItem(int index) {
    items.removeAt(index);
    emit(TableDeleted());
  }
}

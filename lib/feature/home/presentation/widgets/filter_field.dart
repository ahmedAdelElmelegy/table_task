import 'package:flutter/material.dart';
import 'package:table_task2/core/widgets/custom_input_field.dart';
import 'package:table_task2/manager/cubit/table_cubit.dart';

class FilteredFields extends StatelessWidget {
  const FilteredFields({super.key, required this.cubit});

  final TableCubit cubit;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: Colors.grey),
            left: BorderSide(color: Colors.grey),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                  vertical: 6.0,
                ),
                child: CustomInputField(
                  type: InputType.text,
                  label: 'Name',
                  controller: cubit.nameSearchController,
                  isHeader: false,
                  suffixIcon: IconButton(
                    onPressed: () {
                      cubit.nameSearchController.clear();
                    },
                    icon: Icon(Icons.clear, color: Colors.red),
                  ),
                ),
              ),
            ),
            Container(color: Colors.grey, width: 1),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                  vertical: 6.0,
                ),
                child: CustomInputField(
                  type: InputType.text,
                  label: 'Price ',
                  controller: cubit.priceSearchController,
                  isHeader: false,
                  suffixIcon: IconButton(
                    onPressed: () {
                      cubit.priceSearchController.clear();
                    },
                    icon: Icon(Icons.clear, color: Colors.red),
                  ),
                ),
              ),
            ),
            Container(color: Colors.grey, width: 1),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                  vertical: 6.0,
                ),
                child: CustomInputField(
                  type: InputType.text,
                  label: 'Description ',
                  controller: cubit.descriptionSearchController,
                  isHeader: false,
                  suffixIcon: IconButton(
                    onPressed: () {
                      cubit.descriptionSearchController.clear();
                    },
                    icon: Icon(Icons.clear, color: Colors.red),
                  ),
                ),
              ),
            ),
            Container(color: Colors.grey, width: 1),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                  vertical: 6.0,
                ),
                child: CustomInputField(
                  type: InputType.dropdown,
                  asyncItems: (filter, page) async {
                    return ['Tag 1', 'Tag 2', 'Tag 3', 'Tag 4', 'Tag 5'];
                  },
                  selectedValues: cubit.tagsSearchController,

                  label: 'Tags ',
                  isHeader: false,
                ),
              ),
            ),
            Container(color: Colors.grey, width: 1),

            Expanded(
              child: IconButton(
                icon: Icon(Icons.search, color: Colors.blue, size: 30),
                onPressed: () {
                  cubit.searchItem();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_task2/core/widgets/custom_input_field.dart';
import 'package:table_task2/manager/cubit/table_cubit.dart';

class FormItemDesktopAndTablet extends StatefulWidget {
  final int index;
  const FormItemDesktopAndTablet({super.key, required this.index});

  @override
  State<FormItemDesktopAndTablet> createState() =>
      _FormItemDesktopAndTabletState();
}

class _FormItemDesktopAndTabletState extends State<FormItemDesktopAndTablet>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final tableCubit = BlocProvider.of<TableCubit>(context);

    return BlocBuilder<TableCubit, TableState>(
      builder: (context, state) {
        return Form(
          key: tableCubit.formKey[widget.index],
          child: Column(
            children: [
              Row(
                children: [
                  // Form header with error indicator
                  Row(
                    children: [
                      Text(
                        'Item ${widget.index + 1}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: tableCubit.formHasError[widget.index]
                              ? Colors.red
                              : Colors.black,
                        ),
                      ),
                      if (tableCubit.formHasError[widget.index])
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.error, color: Colors.red, size: 16),
                        ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
              SizedBox(height: 8),
              const Divider(),
              Column(
                children: [
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: CustomInputField(
                          controller: tableCubit.nameControllers[widget.index],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a name';
                            }
                            if (value.length < 2) {
                              return 'Name must be at least 2 characters';
                            }
                            return null;
                          },
                          type: InputType.text,
                          label: 'Name',
                        ),
                      ),
                      SizedBox(width: 24),
                      Expanded(
                        child: CustomInputField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a price';
                            }
                            final price = double.tryParse(value);
                            if (price == null) {
                              return 'Please enter a valid number';
                            }
                            if (price <= 0) {
                              return 'Price must be greater than 0';
                            }
                            return null;
                          },
                          controller: tableCubit.priceControllers[widget.index],
                          type: InputType.text,
                          keyboardType: TextInputType.number,
                          label: 'Price',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: CustomInputField(
                          controller: tableCubit.descControllers[widget.index],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a description';
                            }

                            return null;
                          },
                          type: InputType.text,
                          keyboardType: TextInputType.text,
                          label: 'Description',
                        ),
                      ),
                      SizedBox(width: 24),
                      Expanded(
                        child: CustomInputField(
                          onChanged: (value) {
                            tableCubit.tagsControllers[widget.index] = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter at least one tag';
                            }
                            return null;
                          },
                          type: InputType.dropdown,
                          selectedValues:
                              tableCubit.tagsControllers[widget.index],
                          asyncItems: (filter, page) async {
                            return [
                              'Tag 1',
                              'Tag 2',
                              'Tag 3',
                              'Tag 4',
                              'Tag 5',
                            ];
                          },
                          label: 'Tags',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

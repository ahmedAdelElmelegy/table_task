import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:table_task2/feature/home/presentation/model/item_model.dart';
import 'package:table_task2/manager/cubit/table_cubit.dart';

class TableAction extends StatelessWidget {
  const TableAction({
    super.key,
    required this.cubit,
    required this.index,
    required this.oldItem,
    required this.context,
  });

  final TableCubit cubit;
  final int index;
  final List<DataGridCell<dynamic>> oldItem;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            cubit.updateItem(
              index,
              ItemModel(
                name: oldItem[0].value,
                price: oldItem[1].value,
                description: oldItem[2].value,
                tags: oldItem[3].value,
                actions: oldItem[4].value,
              ),
            );
          },
          child: Icon(Icons.edit),
        ),
        SizedBox(width: 16),
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Delete Item'),
                  content: Text('Are you sure you want to delete this item?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        cubit.deleteItem(index);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          child: Icon(Icons.delete, color: Colors.red),
        ),
      ],
    );
  }
}

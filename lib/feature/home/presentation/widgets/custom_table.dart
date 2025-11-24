import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:table_task2/feature/home/presentation/model/item_model.dart';
import 'package:table_task2/feature/home/presentation/widgets/filter_field.dart';
import 'package:table_task2/feature/home/presentation/widgets/table_action.dart';
import 'package:table_task2/manager/cubit/table_cubit.dart';

class CustomTable extends StatefulWidget {
  const CustomTable({super.key});

  @override
  State<CustomTable> createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TableCubit, TableState>(
      builder: (context, state) {
        final cubit = BlocProvider.of<TableCubit>(context);

        return Container(
          width: double.infinity,
          height: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.blue, width: 4)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                spreadRadius: 0,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              FilteredFields(cubit: cubit),
              SfDataGrid(
                autoExpandGroups: true,
                selectionMode: SelectionMode.singleDeselect,

                isScrollbarAlwaysShown: true,
                gridLinesVisibility: GridLinesVisibility.both,
                // defaultColumnWidth: 120,
                rowsPerPage: cubit.numberOfForms,
                columnSizer: _customGridColumnSizer,
                allowSorting: true,
                headerGridLinesVisibility: GridLinesVisibility.both,
                columnWidthMode: ColumnWidthMode.fill,
                frozenColumnsCount: 0,

                headerRowHeight: 55,

                source: EmployeeDataSource(
                  employees: cubit.searchItems.isEmpty
                      ? cubit.items
                      : cubit.searchItems,
                  context: context,
                ),
                columns: _tableColumns(),
              ),
            ],
          ),
        );
      },
    );
  }

  List<GridColumn> _tableColumns() {
    return [
      GridColumn(columnName: 'name', label: _headerText('Name')),
      GridColumn(columnName: 'price', label: _headerText('Price')),
      GridColumn(columnName: 'description', label: _headerText('Description')),
      GridColumn(columnName: 'tags', label: _headerText('Tags')),
      GridColumn(columnName: 'actions', label: _headerText('Actions')),
    ];
  }

  Widget _headerText(String title) {
    return Container(
      padding: EdgeInsets.all(16),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'Urbanist',
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}

class CustomGridColumnSizer extends ColumnSizer {
  @override
  double computeHeaderCellWidth(GridColumn column, TextStyle style) {
    return super.computeHeaderCellWidth(column, style);
  }

  @override
  double computeCellWidth(
    GridColumn column,
    DataGridRow row,
    Object? cellValue,
    TextStyle textStyle,
  ) {
    return super.computeCellWidth(column, row, cellValue, textStyle);
  }

  @override
  double computeHeaderCellHeight(GridColumn column, TextStyle textStyle) {
    return super.computeHeaderCellHeight(column, textStyle);
  }

  @override
  double computeCellHeight(
    GridColumn column,
    DataGridRow row,
    Object? cellValue,
    TextStyle textStyle,
  ) {
    return super.computeCellHeight(column, row, cellValue, textStyle);
  }
}

final CustomGridColumnSizer _customGridColumnSizer = CustomGridColumnSizer();

class EmployeeDataSource extends DataGridSource {
  final BuildContext context;

  EmployeeDataSource({
    required List<ItemModel> employees,
    required this.context,
  }) {
    _employees = employees
        .map<DataGridRow>(
          (e) => DataGridRow(
            cells: [
              DataGridCell<String>(columnName: 'name', value: e.name),
              DataGridCell<double>(columnName: 'price', value: e.price),
              DataGridCell<String>(
                columnName: 'description',
                value: e.description,
              ),
              DataGridCell<List<dynamic>>(columnName: 'tags', value: e.tags),
              DataGridCell<Widget>(columnName: 'actions', value: e.actions),
            ],
          ),
        )
        .toList();
  }

  List<DataGridRow> _employees = [];

  @override
  List<DataGridRow> get rows => _employees;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final index = _employees.indexOf(row);

    final oldItem = _employees[index].getCells();
    final cubit = BlocProvider.of<TableCubit>(context);

    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(16.0),
          child: dataGridCell.columnName == 'actions'
              ? TableAction(
                  cubit: cubit,
                  index: index,
                  oldItem: oldItem,
                  context: context,
                )
              : dataGridCell.columnName == 'tags'
              ? Text(
                  dataGridCell.value.join(', '),
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Urbanist',
                    // fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                )
              : Text(
                  dataGridCell.value.toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Urbanist',
                    // fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
        );
      }).toList(),
    );
  }
}

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

enum InputType { text, dropdown, checkbox }

class CustomInputField extends StatefulWidget {
  final InputType type;
  final String label;

  // 🧩 Common
  final String? Function(String?)? validator;

  // 🧩 Text Field

  final TextEditingController? controller;
  final Widget? suffixIcon;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;

  // 🧩 Dropdown
  final Future<List<dynamic>> Function(String?, int page)? asyncItems;
  final List<dynamic>? selectedValues;
  final ValueChanged<dynamic>? onChanged;
  final bool isHeader;

  // 🧩 Checkbox
  final bool? boolValue;
  final ValueChanged<bool?>? onChangedBool;

  const CustomInputField({
    super.key,
    this.isHeader = true,
    required this.type,
    required this.label,
    this.validator,
    this.controller,
    this.keyboardType,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap,
    this.asyncItems,
    this.selectedValues,
    this.onChanged,
    this.boolValue,
    this.onChangedBool,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case InputType.text:
        return _buildTextField();

      case InputType.dropdown:
        return _buildDropdown();

      case InputType.checkbox:
        return _buildCheckbox();
    }
  }

  Widget _buildTextField() {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isHeader)
          Text(
            widget.label,
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        const SizedBox(height: 8),
        TextFormField(
          readOnly: widget.readOnly,
          keyboardType: widget.keyboardType,
          onTap: widget.onTap,
          controller: widget.controller,
          validator: widget.validator,
          decoration: InputDecoration(
            hintText: widget.label,
            hintStyle: TextStyle(color: Colors.black, fontSize: 14),
            suffixIcon: widget.suffixIcon,
            border: border,
            enabledBorder: border,
            focusedBorder: border.copyWith(
              borderSide: const BorderSide(color: Colors.blue),
            ),
            errorBorder: border.copyWith(
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: border.copyWith(
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
        ),
      ],
    );
  }

  /// 🧩 Modern Dropdown (using dropdown_search)
  Widget _buildDropdown() {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isHeader)
          Text(
            widget.label,
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        const SizedBox(height: 8),
        DropdownSearch<dynamic>.multiSelection(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select at least one option';
            }
            return null;
          },
          items: (filter, loadProps) async {
            final page = ((loadProps?.skip ?? 0) ~/ 25) + 1;
            return await widget.asyncItems!(filter, page);
          },
          itemAsString: (item) => item.toString(),

          onChanged: widget.onChanged,

          selectedItems: widget.selectedValues ?? [],
          compareFn: (a, b) => a == b,
          popupProps: PopupPropsMultiSelection.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                labelText: 'Search...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            menuProps: MenuProps(
              backgroundColor: Colors.white,
              elevation: 5,
              borderRadius: BorderRadius.circular(12),
            ),
            loadingBuilder: (context, _) => const Center(
              child: CircularProgressIndicator(color: Colors.black),
            ),
            infiniteScrollProps: InfiniteScrollProps(
              loadProps: LoadProps(skip: 0, take: 25),
              loadingMoreBuilder: (context, _) => const Center(
                child: CircularProgressIndicator(color: Colors.black),
              ),
            ),
          ),
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              labelText: widget.label,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: border,
              enabledBorder: border,
              focusedBorder: border.copyWith(
                borderSide: const BorderSide(color: Colors.blue),
              ),
              errorBorder: border.copyWith(
                borderSide: const BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: border.copyWith(
                borderSide: const BorderSide(color: Colors.red, width: 1.5),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: widget.boolValue ?? false,
          onChanged: widget.onChangedBool,
        ),
        Flexible(
          child: Text(
            widget.label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

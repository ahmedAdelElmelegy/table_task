import 'package:flutter/material.dart';
import 'package:table_task2/feature/home/presentation/widgets/form_item_desktop_and_tablet.dart';
import 'package:table_task2/feature/home/presentation/widgets/form_item_mobile.dart';
import 'package:table_task2/manager/cubit/table_cubit.dart';

class FormPageView extends StatelessWidget {
  const FormPageView({super.key, required this.size, required this.tableCubit});

  final Size size;
  final TableCubit tableCubit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.width < 600 ? 650 : 420,

      child: PageView.builder(
        controller: tableCubit.pageController,
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: tableCubit.numberOfForms,

        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width < 1000 ? 24 : 80,
              vertical: 36,
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: tableCubit.formHasError[index]
                        ? Colors.red
                        : Colors.blue,
                    width: 4,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: size.width < 600
                  ? FormItemMobile(index: index)
                  : FormItemDesktopAndTablet(index: index),
            ),
          );
        },
      ),
    );
  }
}

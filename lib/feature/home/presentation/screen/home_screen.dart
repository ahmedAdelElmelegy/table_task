import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_task2/feature/home/presentation/widgets/action_btn.dart';
import 'package:table_task2/feature/home/presentation/widgets/custom_table.dart';
import 'package:table_task2/feature/home/presentation/widgets/form_item_desktop_and_tablet.dart';
import 'package:table_task2/feature/home/presentation/widgets/form_item_mobile.dart';
import 'package:table_task2/feature/home/presentation/widgets/validation_summary.dart';
import 'package:table_task2/manager/cubit/table_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    debugPrint(size.width.toString());
    final tableCubit = BlocProvider.of<TableCubit>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<TableCubit, TableState>(
        listener: (context, state) {
          if (state is TableError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is TableLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('All items saved successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is TableDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(' items deleted successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is TableUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('All items updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // Validation Summary
                    ValidationSummary(),

                    SizedBox(
                      height: size.width < 600 ? 650 : 420,
                      child: PageView.builder(
                        allowImplicitScrolling: true,

                        controller: tableCubit.pageController,
                        scrollDirection: Axis.vertical,
                        pageSnapping: true,

                        physics: const BouncingScrollPhysics(),

                        itemCount: tableCubit.numberOfForms,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width < 1000 ? 24 : 80,
                              vertical: 36,
                            ),
                            child: AnimatedContainer(
                              padding: const EdgeInsets.all(16),
                              duration: const Duration(milliseconds: 500),

                              curve: Curves.easeInOut,
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
                                    spreadRadius: 0,
                                    offset: Offset(0, 5),
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
                    ),
                    const SizedBox(height: 24),

                    // Action Buttons
                    ActionBtn(tableCubit: tableCubit),
                    const SizedBox(height: 24),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width < 1000 ? 24 : 80,
                      ),
                      child: const CustomTable(),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              if (state is TableLoading)
                Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_task2/feature/home/presentation/widgets/action_btn.dart';
import 'package:table_task2/feature/home/presentation/widgets/custom_table.dart';
import 'package:table_task2/feature/home/presentation/widgets/form_page_view.dart';
import 'package:table_task2/feature/home/presentation/widgets/validation_summary.dart';
import 'package:table_task2/manager/cubit/table_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final tableCubit = BlocProvider.of<TableCubit>(context);
    tableCubit.pageController = PageController();
  }

  @override
  void dispose() {
    final tableCubit = BlocProvider.of<TableCubit>(context);
    tableCubit.pageController.dispose();
    super.dispose();
  }

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
          bool isMobile = size.width < 1000;
          return Stack(
            children: [
              SingleChildScrollView(
                physics: tableCubit.isInsidePageView
                    ? const NeverScrollableScrollPhysics()
                    : const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // Validation Summary
                    ValidationSummary(),

                    isMobile
                        ? FormPageView(size: size, tableCubit: tableCubit)
                        : MouseRegion(
                            onEnter: (_) => setState(
                              () => tableCubit.isInsidePageView = true,
                            ),
                            onExit: (_) => setState(
                              () => tableCubit.isInsidePageView = false,
                            ),

                            child: Listener(
                              onPointerSignal: (event) async {
                                final cubit = BlocProvider.of<TableCubit>(
                                  context,
                                );

                                // اشتغل بس لو الماوس جوه المنطقة

                                // when move `mouse` out of the page view
                                if (!cubit.isInsidePageView) return;

                                if (event is PointerScrollEvent &&
                                    !cubit.isWheelScrolling) {
                                  cubit.isWheelScrolling = true;

                                  // Scroll Down
                                  if (event.scrollDelta.dy > 0) {
                                    cubit.currentPage++;
                                  }
                                  // Scroll Up
                                  else if (event.scrollDelta.dy < 0) {
                                    cubit.currentPage--;
                                  }

                                  cubit.currentPage = cubit.currentPage.clamp(
                                    0,
                                    cubit.numberOfForms - 1,
                                  );

                                  await cubit.pageController.animateToPage(
                                    cubit.currentPage,
                                    duration: const Duration(milliseconds: 800),
                                    curve: Curves.easeOut,
                                  );

                                  Future.delayed(
                                    const Duration(milliseconds: 100),
                                    () => cubit.isWheelScrolling = false,
                                  );
                                }
                              },

                              child: FormPageView(
                                size: size,
                                tableCubit: tableCubit,
                              ),
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

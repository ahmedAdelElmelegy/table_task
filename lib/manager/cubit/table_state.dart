part of 'table_cubit.dart';

@immutable
sealed class TableState {}

final class TableInitial extends TableState {}

final class TableLoading extends TableState {}

final class TableLoaded extends TableState {}

final class TableError extends TableState {
  final String message;

  TableError(this.message);
}

final class TableValidationUpdated extends TableState {}

final class TableCleared extends TableState {}

final class TableUpdated extends TableState {}

final class TableDeleted extends TableState {}

final class UpdateItem extends TableState {}

final class SearchItems extends TableState {}

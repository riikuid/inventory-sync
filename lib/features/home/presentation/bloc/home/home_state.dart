// lib/features/inventory/presentation/bloc/home/home_state.dart
part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  final List<CategorySummary> categories;
  final List<CompanyItemListRow> companyItems;

  HomeLoaded({required this.categories, required this.companyItems});
}

final class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}

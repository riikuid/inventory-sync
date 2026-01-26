part of 'company_item_detail_cubit.dart';

abstract class CompanyItemDetailState extends Equatable {
  const CompanyItemDetailState();

  @override
  List<Object?> get props => [];
}

class CompanyItemDetailInitial extends CompanyItemDetailState {}

class CompanyItemDetailLoading extends CompanyItemDetailState {}

class CompanyItemDetailLoaded extends CompanyItemDetailState {
  final CompanyItemDetail detail;
  const CompanyItemDetailLoaded(this.detail);

  @override
  List<Object?> get props => [detail];
}

class CompanyItemDetailError extends CompanyItemDetailState {
  final String message;
  const CompanyItemDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

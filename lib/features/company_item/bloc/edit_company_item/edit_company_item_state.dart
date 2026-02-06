part of 'edit_company_item_cubit.dart';

enum EditCompanyItemStatus { initial, loading, loaded, success, failure }

class EditCompanyItemState extends Equatable {
  final String? rackId;
  final String? rackName;
  final EditCompanyItemStatus status;
  final String? errorMessage;

  const EditCompanyItemState({
    required this.rackId,
    required this.rackName,
    required this.status,
    required this.errorMessage,
  });

  factory EditCompanyItemState.initial() => const EditCompanyItemState(
    rackId: null,
    rackName: null,
    status: EditCompanyItemStatus.initial,
    errorMessage: null,
  );

  EditCompanyItemState copyWith({
    String? rackId,
    String? rackName,
    EditCompanyItemStatus? status,
    String? errorMessage,
  }) {
    return EditCompanyItemState(
      rackId: rackId ?? this.rackId,
      rackName: rackName ?? this.rackName,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [rackId, rackName, status, errorMessage];
}

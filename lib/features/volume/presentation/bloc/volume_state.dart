part of 'volume_bloc.dart';

abstract class VolumeState extends Equatable {
  const VolumeState();  

  @override
  List<Object> get props => [];
}
class VolumeInitial extends VolumeState {}

class VolumeLoading extends VolumeState {}

class VolumeLoaded extends VolumeState {
  final VolumeModel volume;

  const VolumeLoaded({required this.volume});
}


class VolumeError extends VolumeState {
  final String message;

  const VolumeError({required this.message});
}

class VolumeLoadedByJournalId extends VolumeState {
  final List<VolumeModel> volumes;

  const VolumeLoadedByJournalId({required this.volumes});
}

class VolumeLoadingByJournalId extends VolumeState {}

class VolumeLoadedAll extends VolumeState {
  final List<VolumeModel> volumes;

  const VolumeLoadedAll({required this.volumes});
}

class VolumeLoadingAll extends VolumeState {}









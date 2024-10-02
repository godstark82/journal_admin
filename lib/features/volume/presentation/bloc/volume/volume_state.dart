part of 'volume_bloc.dart';

abstract class VolumeState extends Equatable {
  const VolumeState();

  @override
  List<Object> get props => [];
}

class VolumeInitial extends VolumeState {}

class VolumeLoading extends VolumeState {}

class VolumesLoaded extends VolumeState {
  final List<VolumeModel> volumes;

  const VolumesLoaded({required this.volumes});
}



class VolumeError extends VolumeState {
  final String message;

  const VolumeError({required this.message});
}

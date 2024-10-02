part of 'singlevolume_bloc.dart';

sealed class SinglevolumeState extends Equatable {
  const SinglevolumeState();

  @override
  List<Object> get props => [];
}

final class SinglevolumeInitial extends SinglevolumeState {}

class SingleVolumeLoaded extends SinglevolumeState {
  final VolumeModel volume;

  const SingleVolumeLoaded({required this.volume});
}

class SingleVolumeError extends SinglevolumeState {
  final String message;

  const SingleVolumeError({required this.message});
}

class SingleVolumeLoading extends SinglevolumeState {}

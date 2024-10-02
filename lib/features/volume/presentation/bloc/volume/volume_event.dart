part of 'volume_bloc.dart';

abstract class VolumeEvent extends Equatable {
  const VolumeEvent();

  @override
  List<Object> get props => [];
}

class GetVolumesEvent extends VolumeEvent {}



class AddVolumeEvent extends VolumeEvent {
  final VolumeModel volume;

  const AddVolumeEvent({required this.volume});
}

class DeleteVolumeEvent extends VolumeEvent {
  final String volumeId;

  const DeleteVolumeEvent({required this.volumeId});
}

class UpdateVolumeEvent extends VolumeEvent {
  final VolumeModel volume;

  const UpdateVolumeEvent({required this.volume});
}

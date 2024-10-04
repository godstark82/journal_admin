part of 'volume_bloc.dart';

abstract class VolumeEvent extends Equatable {
  const VolumeEvent();

  @override
  List<Object> get props => [];
}

class CreateVolumeEvent extends VolumeEvent {
  final VolumeModel volume;

  const CreateVolumeEvent({required this.volume});

  @override
  List<Object> get props => [volume];
}

class UpdateVolumeEvent extends VolumeEvent {
  final VolumeModel volume;

  const UpdateVolumeEvent({required this.volume});

  @override
  List<Object> get props => [volume];
}

class DeleteVolumeEvent extends VolumeEvent {
  final String volumeId;

  const DeleteVolumeEvent({required this.volumeId});

  @override
  List<Object> get props => [volumeId];
}

class GetVolumeEvent extends VolumeEvent {
  final String volumeId;

  const GetVolumeEvent({required this.volumeId});

  @override
  List<Object> get props => [volumeId];
}

class GetVolumesByJournalIdEvent extends VolumeEvent {
  final String journalId;

  const GetVolumesByJournalIdEvent({required this.journalId});

  @override
  List<Object> get props => [journalId];
}

class GetAllVolumesEvent extends VolumeEvent {}





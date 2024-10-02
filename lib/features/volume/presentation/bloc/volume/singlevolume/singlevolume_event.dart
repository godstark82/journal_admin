part of 'singlevolume_bloc.dart';

sealed class SinglevolumeEvent extends Equatable {
  const SinglevolumeEvent();

  @override
  List<Object> get props => [];
}

class GetSingleVolumeEvent extends SinglevolumeEvent {
  final String volumeId;

  const GetSingleVolumeEvent({required this.volumeId});
}

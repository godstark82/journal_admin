import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/features/volume/data/models/volume_model.dart';
import 'package:journal_web/features/volume/domain/usecases/volume_usecases.dart';

part 'singlevolume_event.dart';
part 'singlevolume_state.dart';

class SinglevolumeBloc extends Bloc<SinglevolumeEvent, SinglevolumeState> {
  final GetVolumeByIdUseCase getVolumeByIdUseCase;
  SinglevolumeBloc(this.getVolumeByIdUseCase) : super(SinglevolumeInitial()) {
    on<GetSingleVolumeEvent>(_onLoadSingleVolume);
  }
  Future<void> _onLoadSingleVolume(
      GetSingleVolumeEvent event, Emitter<SinglevolumeState> emit) async {
    emit(SingleVolumeLoading());
    log('Initiated OnLoadSingleVolume');
    final volume = await getVolumeByIdUseCase.call(event.volumeId);

    if (volume is DataSuccess) {
      emit(SingleVolumeLoaded(volume: volume.data!));
    } else if (volume is DataFailed) {
      emit(SingleVolumeError(
          message: volume.message ?? 'Failed to load volume'));
    }
  }
}

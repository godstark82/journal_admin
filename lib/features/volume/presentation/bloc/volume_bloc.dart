import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/features/volume/data/models/volume_model.dart';
import 'package:journal_web/features/volume/domain/usecases/create_v_uc.dart';
import 'package:journal_web/features/volume/domain/usecases/delete_v_uc.dart';
import 'package:journal_web/features/volume/domain/usecases/get_all_v_uc.dart';
import 'package:journal_web/features/volume/domain/usecases/get_v_uc.dart';
import 'package:journal_web/features/volume/domain/usecases/get_vby_jid_uc.dart';
import 'package:journal_web/features/volume/domain/usecases/update_v_uc.dart';

part 'volume_event.dart';
part 'volume_state.dart';

class VolumeBloc extends Bloc<VolumeEvent, VolumeState> {
  final CreateVolumeUC _createVolumeUC;
  final UpdateVolumeUC _updateVolumeUC;
  final DeleteVolumeUC _deleteVolumeUC;
  final GetVolumeUseCase _getVolumeUseCase;
  final GetVolumesByJournalIdUC _getVolumesByJournalIdUC;
  final GetAllVolumesUseCase _getAllVolumesUseCase;

  VolumeBloc(
      this._createVolumeUC,
      this._updateVolumeUC,
      this._deleteVolumeUC,
      this._getVolumeUseCase,
      this._getVolumesByJournalIdUC,
      this._getAllVolumesUseCase)
      : super(VolumeInitial()) {
    //
    on<GetAllVolumesEvent>(_onGetAllVolumes);
    on<GetVolumesByJournalIdEvent>(_onGetVolumesByJournalId);
    on<GetVolumeEvent>(_onGetVolume);
    on<DeleteVolumeEvent>(_onDeleteVolume);
    on<CreateVolumeEvent>(_onCreateVolume);
    on<UpdateVolumeEvent>(_onUpdateVolume);
  }

  Future<void> _onGetAllVolumes(
      GetAllVolumesEvent event, Emitter<VolumeState> emit) async {
    emit(VolumeLoadingAll());
    final result = await _getAllVolumesUseCase.call({});
    if (result is DataSuccess) {
      emit(VolumeLoadedAll(volumes: result.data!));
    } else if (result is DataFailed) {
      emit(VolumeError(message: result.message ?? 'SOME ERROR OCCURED'));
    }
  }

  Future<void> _onGetVolumesByJournalId(
      GetVolumesByJournalIdEvent event, Emitter<VolumeState> emit) async {
    emit(VolumeLoadingByJournalId());
    final result = await _getVolumesByJournalIdUC.call(event.journalId);
    if (result is DataSuccess) {
      emit(VolumeLoadedByJournalId(volumes: result.data!));
    } else if (result is DataFailed) {
      emit(VolumeError(message: result.message ?? 'SOME ERROR OCCURED'));
    }
  }

  Future<void> _onGetVolume(
      GetVolumeEvent event, Emitter<VolumeState> emit) async {
    emit(VolumeLoading());
    final result = await _getVolumeUseCase.call(event.volumeId);
    if (result is DataSuccess) {
      emit(VolumeLoaded(volume: result.data!));
    } else if (result is DataFailed) {
      emit(VolumeError(message: result.message ?? 'SOME ERROR OCCURED'));
    }
  }

  Future<void> _onDeleteVolume(
      DeleteVolumeEvent event, Emitter<VolumeState> emit) async {
    await _deleteVolumeUC.call(event.volumeId);
    add(GetAllVolumesEvent());
  }

  Future<void> _onCreateVolume(
      CreateVolumeEvent event, Emitter<VolumeState> emit) async {
    await _createVolumeUC.call(event.volume);
    add(GetAllVolumesEvent());
  }

  Future<void> _onUpdateVolume(
      UpdateVolumeEvent event, Emitter<VolumeState> emit) async {
    await _updateVolumeUC.call(event.volume);
    add(GetAllVolumesEvent());
  }
}

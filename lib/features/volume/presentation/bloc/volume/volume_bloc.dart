import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:journal_web/core/datastate/data_state.dart';
import 'package:journal_web/features/volume/data/models/volume_model.dart';
import 'package:journal_web/features/volume/domain/usecases/volume_usecases.dart';

part 'volume_event.dart';
part 'volume_state.dart';

class VolumeBloc extends Bloc<VolumeEvent, VolumeState> {
  final GetAllVolumeUseCase getAllVolumeUseCase;
  final GetVolumeByIdUseCase getVolumeByIdUseCase;
  final CreateVolumeUseCase createVolumeUseCase;
  final DeleteVolumeUseCase deleteVolumeUseCase;
  final UpdateVolumeUseCase updateVolumeUseCase;

  VolumeBloc(
    this.getAllVolumeUseCase,
    this.getVolumeByIdUseCase,
    this.createVolumeUseCase,
    this.deleteVolumeUseCase,
    this.updateVolumeUseCase,
  ) : super(VolumeInitial()) {
    on<GetVolumesEvent>(_onGetAllVolume);
    on<AddVolumeEvent>(_onAddVolume);
    on<UpdateVolumeEvent>(_onUpdateVolume);
    on<DeleteVolumeEvent>(_onDeleteVolume);
  }



  Future<void> _onGetAllVolume(
      GetVolumesEvent event, Emitter<VolumeState> emit) async {
    emit(VolumeLoading());
    final volume = await getAllVolumeUseCase.call();

    if (volume is DataSuccess) {
      emit(VolumesLoaded(volumes: volume.data!));
    } else {
      emit(VolumeError(message: 'Some Error Occured'));
    }
  }

  Future<void> _onAddVolume(
      AddVolumeEvent event, Emitter<VolumeState> emit) async {
    emit(VolumeLoading());
    await createVolumeUseCase.call(event.volume);
    add(GetVolumesEvent());
  }

  //! onUpdateVolume
  Future<void> _onUpdateVolume(
      UpdateVolumeEvent event, Emitter<VolumeState> emit) async {
    emit(VolumeLoading());
    await updateVolumeUseCase.call(event.volume);
    add(GetVolumesEvent());
  }

  //! onDeleteVolume
  Future<void> _onDeleteVolume(
      DeleteVolumeEvent event, Emitter<VolumeState> emit) async {
    emit(VolumeLoading());
    await deleteVolumeUseCase.call(event.volumeId);
    add(GetVolumesEvent());
  }

  //! onGetIssues
}

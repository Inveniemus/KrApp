part of 'vessel_bloc.dart';

@immutable
abstract class VesselState {}

class NoVesselDataState extends VesselState {}

class VesselDataState extends VesselState {
  final VesselData data;
  VesselDataState(this.data);
}
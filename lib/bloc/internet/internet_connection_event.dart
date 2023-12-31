part of 'internet_connection_bloc.dart';

@immutable
sealed class InternetConnectionEvent {}

final class InternetInitialEvent extends InternetConnectionEvent{}

final class InternetGainedEvent extends InternetConnectionEvent{}

final class InternetLostEvent  extends InternetConnectionEvent{}


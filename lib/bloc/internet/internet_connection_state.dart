part of 'internet_connection_bloc.dart';

@immutable
sealed class InternetConnectionState {}

final class NotChecked extends InternetConnectionState {}
final class Connected extends InternetConnectionState {}
final class NotConnected extends InternetConnectionState {}

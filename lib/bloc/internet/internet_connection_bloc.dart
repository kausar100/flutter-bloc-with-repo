import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:meta/meta.dart';

part 'internet_connection_event.dart';
part 'internet_connection_state.dart';

class InternetConnectionBloc
    extends Bloc<InternetConnectionEvent, InternetConnectionState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? connectivitySubscription;

  InternetConnectionBloc() : super(NotChecked()) {
    updateConnectionStatus(ConnectivityResult result) {
      
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        add(InternetGainedEvent());
      } else {
        add(InternetLostEvent());
      }
    }

    on<InternetGainedEvent>((event, emit) => emit(Connected()));

    on<InternetLostEvent>((event, emit) => emit(NotConnected()));

    on<InternetInitialEvent>((event, emit) async {
      try {
        final result = await _connectivity.checkConnectivity();
        updateConnectionStatus(result);
      } catch (e) {
        print("Connection checked failed");
      }
    });

    connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(updateConnectionStatus);
  }

  @override
  Future<void> close() {
    connectivitySubscription?.cancel();
    return super.close();
  }
}

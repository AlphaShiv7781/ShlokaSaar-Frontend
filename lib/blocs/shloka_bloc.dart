import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:shlokasaar/blocs/shloka_event.dart';
import 'package:shlokasaar/blocs/shloka_state.dart';
import '../core/api_service.dart';


class ShlokaBloc extends Bloc<ShlokaEvent, ShlokaState> {
  final ApiService apiService = ApiService();

  ShlokaBloc() : super(ShlokaInitialState()) {
    on<FetchShloka>((event, emit) async {
      emit(ShlokaLoading());
      try {
        Response response = await apiService.fetchShlokaTranslation(event.shloka);
        final data = jsonDecode(response.body);
        String translationEnglish = utf8.decode(latin1.encode(data['data']['translation']['en']));
        String translationHindi= utf8.decode(latin1.encode(data['data']['translation']['hi']));
        String explanationEnglish = utf8.decode(latin1.encode(data['data']['explanation']['en']));
        String explanationHindi= utf8.decode(latin1.encode(data['data']['explanation']['hi']));
        String summaryEnglish = utf8.decode(latin1.encode(data['data']['summary']['en']));
        String summaryHindi= utf8.decode(latin1.encode(data['data']['summary']['hi']));
        emit(ShlokaLoaded(translationEnglish , translationHindi , explanationEnglish , explanationHindi ,summaryEnglish , summaryHindi));
      } catch (e) {
        emit(ShlokaError('Failed to load translation'));
      }
    });
  }
}
import 'dart:developer';

import 'package:infinite_list/helpers/constant.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/movie_model.dart';

part 'movies_event.dart';
part 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  MoviesBloc() : super(const MoviesState()) {
    int page = 0;
    List<Results> movieResults = [];

    on<MoviesEvent>((event, emit) async {
      if (event is GetMoviesListEvent) {
        try {
          page++;
          List<Results> results = await fetchMovieList(page);
          if (results.isNotEmpty) {
            movieResults.addAll(results);
            emit(state.copyWith(status: Status.loaded, results: movieResults));
          } else {
            emit(state.copyWith(status: Status.error));
            page--;
          }
        } catch (e) {
          emit(state.copyWith(status: Status.error));
        }
      }
    }, transformer: droppable());
  }
}

Future<List<Results>> fetchMovieList(int page) async {
  List<Results> results = [];
  try {
    Response response = await Dio().get('$baseURL$apiKey&page=$page');
    List<dynamic> list = response.data['results'];
    list.map((data) => results.add(Results.fromJson(data))).toList();
  } catch (e) {
    log(e.toString());
  }

  return results;
}

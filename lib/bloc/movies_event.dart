part of 'movies_bloc.dart';

abstract class MoviesEvent {
  const MoviesEvent();
}

class GetMoviesListEvent extends MoviesEvent {}

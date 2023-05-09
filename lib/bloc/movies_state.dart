part of 'movies_bloc.dart';

enum Status { loading, loaded, error }

class MoviesState {
  final Status status;
  final List<Results> results;

  const MoviesState({
    this.status = Status.loading,
    this.results = const [],
  });

  MoviesState copyWith({
    Status? status,
    List<Results>? results,
  }) {
    return MoviesState(
      status: status ?? this.status,
      results: results ?? this.results,
    );
  }
}

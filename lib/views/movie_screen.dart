import 'package:infinite_list/helpers/constant.dart';
import 'package:infinite_list/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_list/bloc/movies_bloc.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    BlocProvider.of<MoviesBloc>(context).add(GetMoviesListEvent());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      BlocProvider.of<MoviesBloc>(context).add(GetMoviesListEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Popular Movies", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: BlocBuilder<MoviesBloc, MoviesState>(
        builder: (context, state) {
          switch (state.status) {
            case Status.loading:
              return const LoadingWidget();
            case Status.loaded:
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1 / 1.4,
                ),
                controller: _scrollController,
                itemCount: state.results.length + 1,
                itemBuilder: (context, index) {
                  return index == state.results.length
                      ? const LoadingWidget()
                      : Container(
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "$posterURL${state.results[index].posterPath}")),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 196, 193, 193),
                                  width: 0.2)),
                        );
                },
              );
            case Status.error:
              return const Center(
                child: Text("Error"),
              );
          }
        },
      ),
    );
  }
}

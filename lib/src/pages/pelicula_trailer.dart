import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/widgets/trailer_swiper.dart';


class VerTrailer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(pelicula.title),
        backgroundColor: Colors.black54,
      ),
      body: Container(
        child: CargarPelicula(trailer: pelicula.videokey),        
      ),
    );
  }


}

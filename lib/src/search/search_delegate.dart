import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_providers.dart';

class DataSearch extends SearchDelegate {

  final peliculaProvider = new PeliculasProvider();

  final peliculas = [
    'spiderman',
    'spiderman',
    'spiderman',
    'spiderman',
    'spiderman',
    'spiderman',
  ];

  final peliculasRecientes = [
    'spiderman',
    'super man'
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
      // Acciones del AppBar
      return [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            print('Click Search...!!');
            query = '';
          }
        ),
      ];
  }
  
  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        print('Leading Icons Press');
        close(context, null);
      }
    );
  }
  
  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blue,
        child: Text('selecion'),
      ),
    );
  }
  
  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias al momento de escribir

    if( query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: peliculaProvider.buscarPelicula(query),
      //initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if( snapshot.hasData ) {

          final peliculas = snapshot.data;

          return ListView(
            children: peliculas.map((pelicula) {
              return ListTile(
                leading: FadeInImage(
                  image: NetworkImage( pelicula.getPosterImg()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  width: 50.0,
                  fit: BoxFit.contain,                  
                ),
                title: Text(pelicula.title),
                subtitle: Text(pelicula.originalTitle),
                onTap: (){
                  close(context, null);
                  pelicula.uniqueId = '';
                  Navigator.pushNamed(context, 'detalle',arguments: pelicula);
                },
              );
            }).toList(),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        
      },
    );

  }

  /*
    Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias al momento de escribir

    final listaSugerida = (query.isEmpty)
                            ? peliculasRecientes
                            : peliculas.where(
                              (element) => element.toLowerCase().startsWith(query.toLowerCase())
                            ).toList();

    return ListView.builder(
      itemCount: listaSugerida.length,
      itemBuilder: (context, i) {
        return ListTile(
          leading: Icon(Icons.movie),
          title: Text(listaSugerida[i]),
          onTap: (){

          },
        );
      },
    );
  }
  */



}
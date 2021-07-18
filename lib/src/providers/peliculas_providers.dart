import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:peliculas/src/global/environment.dart';
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/models/trailer_model.dart';



class PeliculasProvider {

  String _apiKey   = Environment.apiKey;  
  String _url      = Environment.url;  
  String _language = 'es-ES';

  int _popularesPage = 0;
  bool _cargando = false;

  List<Pelicula> _populares = new List();

  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;

  void disposeStreams(){
    _popularesStreamController?.close();
  }


  Future<List<Pelicula>> _pocesarResultado( Uri url) async {
    final resp = await http.get( url );
    final decodedData = json.decode(resp.body);
    //print(decodedData['results']);
    final peliculas = new Peliculas.fromJsonList(decodedData['results']);
    //print( peliculas.items[0].title );
    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async{

    final url = Uri.https(_url, '3/movie/now_playing',{
      'api_key'  : _apiKey,
      'language' : _language
    });

    return await _pocesarResultado(url);

  }

  Future<List<Pelicula>> getPopulares() async {

    if( _cargando ) return [];

    _cargando = true;

    _popularesPage++;

    final url = Uri.https( _url , '3/movie/popular', {
      'api_key'  : _apiKey,
      'language' : _language,
      'page'     : _popularesPage.toString()
    });

    final resp = await _pocesarResultado(url);
    
    _populares.addAll(resp);
    popularesSink( _populares);

    _cargando = false;

    return resp;

  }

  Future<List<Actor>> getCast( String peliId ) async{

    final url = Uri.https( _url, '3/movie/$peliId/credits', {
      'api_key'  : _apiKey,
      'language' : _language
    });

    final resp = await http.get(url);
    final decodedData = json.decode( resp.body );

    final cast = new Cast.fromJsonList( decodedData['cast']);

    return cast.actores;

  }

  Future<List<Pelicula>> buscarPelicula( String query ) async{

    final url = Uri.https(_url, '3/search/movie',{
      'api_key'  : _apiKey,
      'language' : _language,
      'query'    : query
    });

    return await _pocesarResultado(url);

  }

  Future<List<TrailerPeli>> getTrailer( String peiId) async{
    
    final url = Uri.https( _url, '3/movie/$peiId/videos', {
      'api_key'  : _apiKey,
      //'language' : 'en-EN'
      'language' : _language
    });

    final resp = await http.get(url);
    final decodedData = json.decode( resp.body);
    
    if(decodedData['results'].toString() == '[]'){

      var dataPeli = decodedData['results'] = [
        {
          'id': null,
          'iso_639_1': null,
          'iso_3166_1': null,
          'key': 'nohayvideo',
          'name': null,
          'site': null,
          'size': null,
          'type': null
        }
      ];

      final videito = new VideoPeli.fromJsonList( dataPeli );
      //print('SE ENVIA DATOS VACIOS PARA CONTROLAR EL ERROR');
      //print('DECODEDDATA:  '+decodedData['results'].toString());
      //print('VIDEO DISPONIBLE '+ videito.trailers[0].key);
      return videito.trailers;

    }else{
      
      final videito = new VideoPeli.fromJsonList( decodedData['results'] );
     // print('SE ENVIA DATOS EXISTENTES DESDE themoviedb');
     // print(decodedData['results'].toString());      
      return videito.trailers;

    } 
  }

}
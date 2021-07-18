
class VideoPeli {
  List<TrailerPeli> trailers = new List();

  VideoPeli.fromJsonList( List<dynamic> jsonList ){
    if( jsonList == null ) return;

    jsonList.forEach(( item ) {
      final trailer = TrailerPeli.fromJsonMap( item );
      trailers.add( trailer );
    });

  }

}


class TrailerPeli {
  String id;
  String iso6391;
  String iso31661;
  String key;
  String name;
  String site;
  int size;
  String type;

  TrailerPeli({
    this.id,
    this.iso6391,
    this.iso31661,
    this.key,
    this.name,
    this.site,
    this.size,
    this.type,
  });

  TrailerPeli.fromJsonMap( Map<String, dynamic> json ) {
    id          = json['id'];
    iso6391     = json['iso6391'];
    iso31661    = json['iso31661'];
    key         = json['key'];
    name        = json['name'];
    site        = json['site'];
    size        = json['size'];
    type        = json['type'];
    
  }

}



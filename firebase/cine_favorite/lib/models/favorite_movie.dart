class FavoriteMovie {
  final int id;
  final String title;
  final String posterPath;
  double rating; 

  FavoriteMovie({
    required this.id,
    required this.title,
    required this.posterPath,
    this.rating = 0 
  });


// metodos de conversão de OBJ <-> Json

//toMap 
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'posterPath': posterPath,
      'rating': rating
    };
  }      

  
  factory FavoriteMovie.fromMap(Map<String, dynamic> map) {
    return FavoriteMovie(
      id: map['id'],
      title: map['title'],
      posterPath: map['posterPath'],
      rating: (map['rating']as num).toDouble(), 
    ); 
  }  

 
}
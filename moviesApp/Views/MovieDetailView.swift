//
//  MovieDetailView.swift
//  moviesApp
//
//  Created by Francisco Misael Landero Ychante on 12/10/20.
//

import SwiftUI

struct MovieDetailView: View {
    
    
    @ObservedObject var movieModel : MovieDetailModel
    
    init(id : Int) {
        movieModel = MovieDetailModel(id: id)
    }
    
    
    var body: some View {
        GeometryReader { geo in
            VStack{
                ScrollView(){
                    URLImageView(ulr:  movieModel.movie?.posterPath)
                        .frame(width: geo.size.width)
                    VStack{
                        HStack{
                            Text((movieModel.movie?.title) ?? "Cargando")
                                    .font(.largeTitle)
                            Spacer()
                        }
                        .padding(.bottom, 20)
                
                        DetailRow(title: "Duración", content: String("\(movieModel.movie?.runtime ?? 0) min"))
                        
                        DetailRow(title: "Fecha de estreno", content: movieModel.movie?.formatedDate ?? "0-0-0")
                        
                        DetailRow(title: "Calificación", content: (String(format: "%.1f", movieModel.movie?.voteAverage ?? 0.0)))
                        
                        DetailRow(title: "Géneros", content: String(movieModel.movie?.genresString.joined(separator: ", ") ?? "Nada"))
                        
                        DetailRow(title: "Descripción", content: String("\(movieModel.movie?.overview ?? "Nada")"))
                           
               
                    }
                    .padding(.leading,10)
                     
                }
                .navigationBarTitle(movieModel.movie?.title ?? "Cargando", displayMode: .inline)
            }
        }/*
        .onAppear{
            //detailModel = StateController()
            stateController.loadMovieDetails(id: id)
        }*/
        
    }
}
    

/*struct DetailMovieContent: View {
    
    @Binding var movie : MovieDetail
    
    var body: some View {
        GeometryReader { geo in
            VStack{
                ScrollView(){
                    URLImageView(ulr: movieModel.movie?.posterPath)
                        .frame(width: geo.size.width)
                    VStack{
                        HStack{
                            Text((movieModel.movie?.title) ?? "Cargando")
                                    .font(.largeTitle)
                            Spacer()
                        }
                        .padding(.bottom, 20)
                
                        DetailRow(title: "Duración", content: String("\(movieModel.movie?.runtime ?? 0) min"))
                        
                        DetailRow(title: "Fecha de estreno", content: movieModel.movie?.formatedDate ?? "0-0-0")
                        
                        DetailRow(title: "Calificación", content: (String(format: "%.1f", movieModel.movie?.voteAverage ?? 0.0)))
                        
                        DetailRow(title: "Géneros", content: String(movieModel.movie?.genresString.joined(separator: ", ") ?? "Nada"))
                        
                        DetailRow(title: "Descripción", content: String("\(movieModel.movie?.overview ?? "Nada")"))
                           
               
                    }
                    .padding(.leading,10)
                     
                }
                .navigationBarTitle(movieModel.movie?.title ?? "Cargando", displayMode: .inline)
            }
        }
        
    }
}*/

struct DetailRow: View {
    @State var title : String
    @State var content : String
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(title)
                    .fontWeight(.bold)
                Text(content)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
    }
}
    


 

 

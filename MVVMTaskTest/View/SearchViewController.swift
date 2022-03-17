//
//  SearchViewController.swift
//  MVVMTaskTest
//
//  Created by Nihad Ismayilov on 17.03.22.
//

import UIKit
import SDWebImage

class SearchViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var movieCollectionView: UICollectionView!
    
    var search = ""
    
    var searchVM = SearchViewModel()
    var post: Result?
    var details: DetailsData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Movie"
        
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        searchBar.delegate = self
    }
    
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post?.Search?.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = movieCollectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
        cell.movieTitleLabel.text = self.post?.Search?[indexPath.row].Title
        if let poster = self.post?.Search?[indexPath.row].Poster {
            
            cell.movieImageView.sd_setImage(with: URL(string: poster))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let movieId = post?.Search?[indexPath.row].imdbID else { return }
        guard let movieTitle = post?.Search?[indexPath.row].Title else { return }
        guard let moviePoster = post?.Search?[indexPath.row].Poster else { return }
        
        let board = UIStoryboard(name: "Main", bundle: nil)
        let detailsVC = board.instantiateViewController(withIdentifier: "details") as! DetailsViewController
        
        detailsVC.idAPI = movieId
        detailsVC.titleAPI = movieTitle
        detailsVC.posterAPI = moviePoster

        if Helper.sharedInstance.movieIdArray?.contains(detailsVC.idAPI ?? "") ?? false{
            detailsVC.saveButton.title = "Un-Save"
        }else {
            detailsVC.saveButton.title = "Save"
        }
        
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search = searchText
        searchVM.performMoviesRequest(search) { data in
            self.post = data
            DispatchQueue.main.async {
                self.movieCollectionView.reloadData()
            }
        }
        //print(self.post)
    }
}

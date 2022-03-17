//
//  DetailsViewController.swift
//  MVVMTaskTest
//
//  Created by Nihad Ismayilov on 17.03.22.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var idAPI: String?
    var posterAPI: String?
    var titleAPI: String?
    
    var detailsData: DetailsData?
    
    @IBOutlet var saveButton: UIBarButtonItem!
    
    var detailsViewModel = DetailsViewModel()
    
    @IBOutlet var movieNameLabel: UILabel!
    @IBOutlet var movieDirectorLabel: UILabel!
    @IBOutlet var movieImageView: UIImageView!
    @IBOutlet var movieReleaseLabel: UILabel!
    @IBOutlet var movieGenreLabel: UILabel!
    @IBOutlet var movieRuntimeLabel: UILabel!
    @IBOutlet var movieRatingLabel: UILabel!
    @IBOutlet var movieDescriptionLabel: UILabel!
    @IBOutlet var movieWriterLabel: UILabel!
    @IBOutlet var movieActorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieRatingLabel.layer.cornerRadius = 10
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showDetails()
        NotificationCenter.default.addObserver(self, selector: #selector(checkData), name: NSNotification.Name("passMovie"), object: nil)
    }
    
    @objc func showDetails() {
        
        self.detailsViewModel.performDetailRequest(idAPI ?? "") { details in
            self.detailsData = details
        
        DispatchQueue.main.async {
            
            self.movieNameLabel.text = self.detailsData?.Title
            self.movieDirectorLabel.text = self.detailsData?.Director
            self.movieImageView.sd_setImage(with: URL(string: self.detailsData?.Poster ?? "select"))
            self.movieRatingLabel.text = "\(self.detailsData?.imdbRating ?? "")/10"
            self.movieReleaseLabel.text = self.detailsData?.Released
            self.movieGenreLabel.text = self.detailsData?.Genre
            self.movieRuntimeLabel.text = self.detailsData?.Runtime
            self.movieDescriptionLabel.text = self.detailsData?.Plot
            self.movieActorLabel.text = "Starring:  \(self.detailsData?.Actors ?? "")"
            self.movieWriterLabel.text = "Writers: \(self.detailsData?.Writer ?? "")"
            
        }
        }
    }
    
    
    @objc func checkData() {
        if Helper.sharedInstance.movieIdArray?.contains(idAPI ?? "") ?? false {
            saveButton.title = "Un-Save"
        }else {
            saveButton.title = "Save"
        }
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        guard let idApi = idAPI else { return }
        guard let titleApi = titleAPI else { return }
        guard let posterApi = posterAPI else { return }
        
        if Helper.sharedInstance.movieIdArray?.contains(idApi) ?? false {
            
            if let idIndex = Helper.sharedInstance.movieIdArray?.firstIndex(of: idApi) {
                Helper.sharedInstance.movieIdArray?.remove(at: idIndex)
            }
            if let titleIndex = Helper.sharedInstance.movieTitleArray?.firstIndex(of: titleApi) {
                Helper.sharedInstance.movieTitleArray?.remove(at: titleIndex)
            }
            if let posterIndex = Helper.sharedInstance.moviePosterArray?.firstIndex(of: posterApi) {
                Helper.sharedInstance.moviePosterArray?.remove(at: posterIndex)
            }
            
            saveButton.title = "Save"
            
        }else {
            
            Helper.sharedInstance.movieIdArray?.append(idApi)
            Helper.sharedInstance.moviePosterArray?.append(posterApi)
            Helper.sharedInstance.movieTitleArray?.append(titleApi)
            
            UserDefaults.standard.set(Helper.sharedInstance.movieIdArray, forKey: "savedIdDefaults")
            UserDefaults.standard.set(Helper.sharedInstance.movieTitleArray, forKey: "savedTitleDefaults")
            UserDefaults.standard.set(Helper.sharedInstance.moviePosterArray, forKey: "savedPosterDefaults")
            
            saveButton.title = "Un-Save"
            
        }
        NotificationCenter.default.post(name: NSNotification.Name("passMovie"), object: nil)
        
        
    }
    
}

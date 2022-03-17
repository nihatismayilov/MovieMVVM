//
//  SavesViewController.swift
//  MVVMTaskTest
//
//  Created by Nihad Ismayilov on 17.03.22.
//

import UIKit

class SavesViewController: UIViewController {
    
    @IBOutlet var saveCollectionView: UICollectionView!
    
    var detailsViewModel = DetailsViewModel()
    var detailData: DetailsData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        saveCollectionView.dataSource = self
        saveCollectionView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(data), name: NSNotification.Name(rawValue: "passMovie"), object: nil)
        
        Helper.sharedInstance.movieTitleArray = UserDefaults.standard.array(forKey: "savedTitleDefaults") as? [String]
        Helper.sharedInstance.moviePosterArray = UserDefaults.standard.array(forKey: "savedPosterDefaults") as? [String]
        Helper.sharedInstance.movieIdArray = UserDefaults.standard.array(forKey: "savedIdDefaults") as? [String]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.saveCollectionView.reloadData()
        }

        
    }
    
    @objc func data() {
        if let data = Helper.sharedInstance.movieIdArray {
            for movieId in data {
                detailsViewModel.performDetailRequest(movieId) { details in
                    self.detailData = details
                }
            }
        }
    }
}

extension SavesViewController: UICollectionViewDelegate, UICollectionViewDataSource {

func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return Helper.sharedInstance.movieIdArray?.count ?? 0
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = saveCollectionView.dequeueReusableCell(withReuseIdentifier: "saveCell", for: indexPath) as! SaveCollectionViewCell
    
    DispatchQueue.main.async {
        
        cell.saveTitleLabel.text = Helper.sharedInstance.movieTitleArray?[indexPath.row]
        if let imageUrl = Helper.sharedInstance.moviePosterArray?[indexPath.row] {
            cell.saveImageView.sd_setImage(with: URL(string: imageUrl))
        }
        
    }
    
    return cell
}

func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    let board = UIStoryboard(name: "Main", bundle: nil)
    let detailsVC = board.instantiateViewController(withIdentifier: "details") as! DetailsViewController
    
    detailsVC.idAPI = Helper.sharedInstance.movieIdArray?[indexPath.row]
    detailsVC.titleAPI = Helper.sharedInstance.movieTitleArray?[indexPath.row]
    detailsVC.posterAPI = Helper.sharedInstance.moviePosterArray?[indexPath.row]
    
    if Helper.sharedInstance.movieIdArray?.contains(detailsVC.idAPI ?? "") ?? false {
        detailsVC.saveButton.title = "Un-Save"
        
    }else {
        detailsVC.saveButton.title = "Save"
    }
    
    navigationController?.pushViewController(detailsVC, animated: true)
}

}

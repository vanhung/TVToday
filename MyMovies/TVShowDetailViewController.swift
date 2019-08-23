//
//  TVShowDetailViewController.swift
//  MyMovies
//
//  Created by Jeans on 8/21/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class TVShowDetailViewController: UITableViewController {

    public var tvShowGeneral: TVShow!
    
    private var tvShow: TVShowDetail!
    
    @IBOutlet weak private var backDropImage: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var yearInitLabel: UILabel!
    @IBOutlet weak private var yearEndLabel: UILabel!
    @IBOutlet weak private var durationLabel: UILabel!
    @IBOutlet weak private var genreLabel: UILabel!
    @IBOutlet weak private var numberOfEpisodes: UILabel!
    @IBOutlet weak private var posterImage: UIImageView!
    @IBOutlet weak private var overViewLabel: UITextView!
    @IBOutlet weak private var scoreLabel: UILabel!
    @IBOutlet weak private var countVoteLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false

        if let idShow = tvShowGeneral.id{
            updateLayoutGeneral()
            TMDBClient.getTVShowDetail(id: idShow, completion: handleGetTVShowDetail(tvShow:error:))
            downloadImages()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        print("Table View Size: \(tableView.frame.size)")
//        print("Table View Parent: \(tableView.superview?.frame.size )")
//
//        print("Safe Area: \(view.safeAreaLayoutGuide.layoutFrame)")
//        print("UIScreen Bounds:\(UIScreen.main.bounds)")
    }
    
    
    private func handleGetTVShowDetail(tvShow:TVShowDetail?, error: Error?){
        if let show = tvShow{
            
            self.tvShow = show
            DispatchQueue.main.async {
                self.updateLayout()
            }
        }
    }
    
    private func updateLayoutGeneral(){
        nameLabel.text = tvShowGeneral.name
        yearInitLabel.text = getYear(from: tvShowGeneral.firstAirDate)
        overViewLabel.text = tvShowGeneral.overview
        scoreLabel.text = "\(String(tvShowGeneral.voteAverage)) "
        countVoteLabel.text = String(tvShowGeneral.voteCount)
    }
    
    private func updateLayout(){
        yearEndLabel.text = getYear(from: tvShow.lasttAirDate)
        if let runtime = tvShow.episodeRunTime.first{
            durationLabel.text = "\(String(runtime)) min"
        }else{
            durationLabel.text = "--"
        }
        genreLabel.text = tvShow.genreIds.first?.name
        numberOfEpisodes.text = String(tvShow.numbeOfEpisodes)
    }
    
    private func getYear(from dateString: String?) -> String{
        guard let dateString = dateString else{
            return "-"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = formatter.date(from: dateString){
            formatter.dateFormat = "yyyy"
            let yearString = formatter.string(from: date)
            return yearString
        }else{
            return "-"
        }
    }
    
    private func downloadImages(){
        if let backDropPath = tvShowGeneral.backDropPath{
            TMDBClient.getImage(size: .mediumBackDrop, path: backDropPath, completion: {
                data, error in
                if let data = data{
                    DispatchQueue.main.async {
                        self.backDropImage.image = UIImage(data: data)
                    }
                }
            })
        }
        
        if let posterPath = tvShowGeneral.posterPath{
            TMDBClient.getImage(size: .mediumPoster, path: posterPath, completion: {
                data, error in
                if let data = data{
                    DispatchQueue.main.async {
                        self.posterImage.image = UIImage(data: data)
                    }
                }
            })
        }
    }
}

extension TVShowDetailViewController{
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let percentFirstRow = CGFloat(0.45)
        let fixedSecondRow = CGFloat(50.0)
        
        let totalHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let restOfHeight = (totalHeight * (1-percentFirstRow) ) - fixedSecondRow
        
        var heightrow = CGFloat(0.0)
        
        if indexPath.row == 0{
            heightrow =  totalHeight * ( percentFirstRow )
        }else if indexPath.row == 1{
            heightrow = fixedSecondRow
        }else if indexPath.row == 2{
            heightrow = restOfHeight * 0.65
        }else if indexPath.row == 3{
            heightrow = restOfHeight * 0.35
        }else{
            heightrow = 0
        }
        return CGFloat(heightrow)
    }
}

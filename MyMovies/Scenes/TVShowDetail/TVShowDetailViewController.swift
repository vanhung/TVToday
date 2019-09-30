//
//  TVShowDetailViewController.swift
//  MyMovies
//
//  Created by Jeans on 8/21/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class TVShowDetailViewController: UITableViewController {

    var viewModel: TVShowDetailViewModel?{
        didSet{
            setupViewModel()
        }
    }
    
    var idShow:Int!{
        didSet{
            self.viewModel = TVShowDetailViewModel(idShow)
        }
    }
    
    @IBOutlet weak private var backDropImage: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var yearsRelease: UILabel!
    @IBOutlet weak private var durationLabel: UILabel!
    @IBOutlet weak private var genreLabel: UILabel!
    @IBOutlet weak private var numberOfEpisodes: UILabel!
    @IBOutlet weak private var posterImage: UIImageView!
    @IBOutlet weak private var overViewLabel: UITextView!
    @IBOutlet weak private var scoreLabel: UILabel!
    @IBOutlet weak private var countVoteLabel: UILabel!
    
    private var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    deinit {
        print("deinit TVShowDetailViewController")
    }
    
    //MARK: - SetupViewModel
    private func setupViewModel(){
        setupBindables()
        viewModel?.getShowDetails(id: idShow)
    }
    
    private func setupBindables(){
        
        viewModel?.isLoading?.bind({[weak self] isLoading in
            DispatchQueue.main.async {
                isLoading ? self?.showLoader() : self?.hideLoader()
            }
        })
        
        viewModel?.updateUI = { [weak self] in
            DispatchQueue.main.async {
                self?.setupUI()
            }
        }
        
        viewModel?.dropData.bind({ [weak self] data in
            DispatchQueue.main.async {
                if let data = data{
                    self?.backDropImage.image = UIImage(data: data)
                }
            }
        })
        
        viewModel?.posterData.bind({ [weak self] data in
            DispatchQueue.main.async {
                if let data = data{
                    self?.posterImage.image = UIImage(data: data)
                }
            }
        })
    }
    
    func showLoader(){
        DispatchQueue.main.async {
            let containerView = UIView(frame: self.view.frame)
            containerView.backgroundColor = .white
            
            self.activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
            self.activityIndicator.color = .darkGray
            self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            self.activityIndicator.center = containerView.center
            
            containerView.addSubview(self.activityIndicator)
            self.view.addSubview(containerView)
            
            self.activityIndicator.startAnimating()
        }
    }
    
    func hideLoader(){
        DispatchQueue.main.async {
            guard let activityIndicator = self.activityIndicator,
                let containerView = activityIndicator.superview else { return }
            
            activityIndicator.stopAnimating()
            
            UIView.animate(withDuration: 0.5, animations: {
                containerView.alpha = 0
            }, completion: { _ in
                containerView.removeFromSuperview()
            })
        }
    }
    
    private func setupUI(){
        guard let viewModel = viewModel else { return }
        
        nameLabel.text = viewModel.nameShow
        yearsRelease.text = viewModel.yearsRelease
        
        durationLabel.text = viewModel.duration
        genreLabel.text = viewModel.genre
        
        numberOfEpisodes.text = viewModel.numberOfEpisodes
        overViewLabel.text = viewModel.overView
        scoreLabel.text = viewModel.score
        countVoteLabel.text = viewModel.countVote
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SeasonsListSegue"{
            if let vc = segue.destination as? SeasonsListViewController{
             vc.showDetail = viewModel?.showDetail
            }
        }
    }
    
}

extension TVShowDetailViewController{
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 1{
            return true
        }
        return false
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.row == 1{
            performSegue(withIdentifier: "SeasonsListSegue", sender: nil)
            return indexPath
        }else{
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
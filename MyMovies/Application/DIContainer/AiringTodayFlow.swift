//
//  AiringToday.swift
//  TVToday
//
//  Created by Jeans Ruiz on 4/7/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import RxFlow

public class AiringTodayFlow: Flow {
  
  public struct Dependencies {
    let apiDataTransferService: DataTransferService
    let imageTransferService: DataTransferService
  }
  
  private let dependencies: Dependencies
  
  public var root: Presentable {
    return self.rootViewController
  }
  
  private lazy var rootViewController: UINavigationController = {
    let navigationController = UINavigationController()
    return navigationController
  }()
  
  // MARK: - TODO, Repositories are be the Same??
  private lazy var showsRepository: TVShowsRepository = {
    return DefaultTVShowsRepository(dataTransferService: dependencies.apiDataTransferService)
  }()
  
  private lazy var showDetailsRepository: TVShowDetailsRepository = {
    return DefaultTVShowDetailsRepository(dataTransferService: dependencies.apiDataTransferService)
  }()
  
  private lazy var episodesRepository: TVEpisodesRepository = {
    return DefaultTVEpisodesRepository(dataTransferService: dependencies.apiDataTransferService)
  }()
  
  // MARK: - Life Cycle
  
  public init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  // MARK: - Navigation
  
  public func navigate(to step: Step) -> FlowContributors {
    switch step {
    case AiringTodayStep.todayFeatureInit:
      return navigateToTodayFeature()
      
    case AiringTodayStep.showIsPicked(let id):
      return navigateToShowDetailScreen(with: id)
      
    case ShowDetailsStep.seasonsAreRequired(let showId):
      return navigateToSeasonsScreen(with: showId)
      
    default:
      return .none
    }
  }
  
  fileprivate func navigateToTodayFeature() -> FlowContributors {
    let viewModel = AiringTodayViewModel(fetchTVShowsUseCase: makeFetchTodayShowsUseCase())
    let todayVC = AiringTodayViewController.create(with: viewModel)
    
    rootViewController.pushViewController(todayVC, animated: true)
    
    return .one(flowContributor: .contribute(
      withNextPresentable: todayVC, withNextStepper: viewModel))
  }
  
  fileprivate func navigateToShowDetailScreen(with id: Int) -> FlowContributors {
    let viewModel = TVShowDetailViewModel(id, fetchDetailShowUseCase: makeFetchShowDetailsUseCase())
    let detailVC = TVShowDetailViewController.create(with: viewModel)
    
    rootViewController.pushViewController(detailVC, animated: true)
    
    return .one(flowContributor: .contribute(
      withNextPresentable: detailVC, withNextStepper: viewModel))
  }
  
  fileprivate func navigateToSeasonsScreen(with id: Int) -> FlowContributors {
    let viewModel = EpisodesListViewModel(tvShowId: id, fetchDetailShowUseCase: makeFetchShowDetailsUseCase(), fetchEpisodesUseCase: makeFetchEpisodesUseCase())
    let seasonsVC = EpisodesListViewController.create(with: viewModel)
    
    rootViewController.pushViewController(seasonsVC, animated: true)
    
    return .one(flowContributor: .contribute(
      withNextPresentable: seasonsVC, withNextStepper: viewModel))
  }
  
  // MARK: - Uses Cases
  
  private func makeFetchTodayShowsUseCase() -> FetchTVShowsUseCase {
    return DefaultFetchTVShowsUseCase(tvShowsRepository: showsRepository)
  }
  
  private func makeFetchShowDetailsUseCase() -> FetchTVShowDetailsUseCase {
    return DefaultFetchTVShowDetailsUseCase(tvShowDetailsRepository: showDetailsRepository)
  }
  
  private func makeFetchEpisodesUseCase() -> FetchEpisodesUseCase {
    return DefaultFetchEpisodesUseCase(episodesRepository: episodesRepository)
  }
}

// MARK: - Steps

public enum AiringTodayStep: Step {
  
  case
  
  todayFeatureInit,
  
  showIsPicked(withId: Int)
}
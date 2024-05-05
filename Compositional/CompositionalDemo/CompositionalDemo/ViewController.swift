//
//  ViewController.swift
//  CompositionalDemo
//
//  Created by Avinash Mulewa on 21/05/22.
//

import UIKit
import AVFoundation


public typealias ContactDataSource  = UICollectionViewDiffableDataSource<Section, Int>
public typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Int>


public enum Section {
      case main
      case subtitle
    }

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    public var dataSource: ContactDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.collectionViewLayout = createLayout()
        collectionView.register(UINib(nibName: "DemoCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "DemoCell")
        configureDataSource()
        applySnapshot()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { _ in
        } completion: { [weak self] _ in
            guard let self = self else { return }
            self.collectionView.setCollectionViewLayout(createLayout(), animated: true)
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let countFirstRow: CGFloat = isLandscape ? 4 : 3
        let countSecondRow: CGFloat = isLandscape ? 3 : 2
        let cellHeight: CGFloat = 200
        let cellWidth: CGFloat = 200
        let cellSpace: CGFloat = 20
        
        let deviceWidth = UIScreen.main.bounds.size.width
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(cellWidth),
                                              heightDimension: .absolute(cellHeight))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(cellHeight))
        
        let groupFourItems = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: Int(countFirstRow))
        let contentWidthFirstRow = (cellWidth * countFirstRow) + (cellSpace * (countFirstRow - 1))
        let threeSpace =  (deviceWidth - contentWidthFirstRow) / 2
        groupFourItems.interItemSpacing = .fixed(cellSpace)
        groupFourItems.contentInsets.leading = threeSpace
        groupFourItems.contentInsets.trailing = threeSpace
        
        let groupThreeItems = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: Int(countSecondRow))
        let contentWidthSecondRow = (cellWidth * countSecondRow) + (cellSpace * (countSecondRow - 1))
        let twoSpace =  (deviceWidth - contentWidthSecondRow) / 2
        groupThreeItems.interItemSpacing = .fixed(cellSpace)
        groupThreeItems.contentInsets.leading = twoSpace
        groupThreeItems.contentInsets.trailing = twoSpace
        
        let secondRowGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let secondRowGroup = NSCollectionLayoutGroup.vertical(layoutSize: secondRowGroupSize, subitems: [groupFourItems, groupThreeItems])
        secondRowGroup.interItemSpacing = .fixed(-(cellSpace))
        let section = NSCollectionLayoutSection(group: secondRowGroup)
   
        section.interGroupSpacing = -(cellSpace)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func configureDataSource() {
        dataSource = .init(collectionView: collectionView!,
                           cellProvider: { (collectionView, indexPath, data) -> UICollectionViewCell? in

            let cellIdentifier = "DemoCell"
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                             for: indexPath) as? DemoCollectionViewCell {
                return cell
            } else {
                return UICollectionViewCell()
            }
        })
    }

    
    func applySnapshot() {
        var snapShot = DataSourceSnapshot()
        snapShot.appendSections([.main])
        for i in 0...40 {
            snapShot.appendItems([i], toSection: .main)
        }
        
        dataSource?.apply(snapShot, animatingDifferences: false)
        
    }
    
    var isLandscape: Bool {
        switch UIDevice.current.orientation {
        case .portrait,.portraitUpsideDown:
            return false
        case .landscapeLeft,.landscapeRight:
            return true
        default:
            let bounds = UIScreen.main.bounds
            let width = bounds.size.width
            let height = bounds.size.height
            if height > width {
                return false
            } else {
                return true
            }
        }
    }
}

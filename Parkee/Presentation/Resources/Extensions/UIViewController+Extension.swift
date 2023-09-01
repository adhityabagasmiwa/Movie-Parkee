//
//  UIViewController+Extension.swift
//  Parkee
//
//  Created by Adhitya Bagas on 31/08/23.
//

import Foundation
import UIKit
import FittedSheets

protocol TableViewConfigurable: UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView! { get set }
}

extension TableViewConfigurable where Self: UIViewController {
    func configureTableView(nibName: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: nibName)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
    }
}

protocol CollectionViewConfigurable: UICollectionViewDelegate, UICollectionViewDataSource {
    var collectionView: UICollectionView! { get set }
}

extension CollectionViewConfigurable where Self: UIViewController {
    func configurableCollectionView(nibName: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: nibName)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension UIViewController {
    func navigatePushToPage(_ toPage: UIViewController) {
        self.navigationController?.pushViewController(toPage, animated: true)
    }
    
    func navigatePop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showBottomSheet(controller: UIViewController, sizes: [SheetSize], dismissOnPull: Bool = true, dismissOnOverlayTap: Bool = true) {
        let options = SheetOptions(
            shrinkPresentingViewController: false
        )
        let sheetController = SheetViewController(controller: controller, sizes: sizes, options: options)
        sheetController.dismissOnPull = dismissOnPull
        sheetController.dismissOnOverlayTap = dismissOnOverlayTap
        sheetController.autoAdjustToKeyboard = true
        
        self.present(sheetController, animated: true, completion: nil)
    }

}

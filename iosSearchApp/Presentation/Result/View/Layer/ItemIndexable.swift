//
//  ItemIndexable.swift
//  iosSearchApp
//
//  Created by ejsong on 3/4/24.
//

import Foundation
import RxDataSources

protocol ItemIndexable {
  associatedtype Item
  
  subscript(indexPath: IndexPath) -> Item { get set }
}

extension ItemIndexable {
  func item(at index: IndexPath) throws -> Item { self[index] }
  func items(at indexes: [IndexPath]) throws -> [Item] { try indexes.map(self.item(at:)) }
}

extension TableViewSectionedDataSource: ItemIndexable { }
extension CollectionViewSectionedDataSource: ItemIndexable { }

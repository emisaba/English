import UIKit

// MARK: - UICollectionViewDataSource

extension CollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionType == .user ? userCollections.count : downloadCollections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CollectionViewCell
        
        let collection = collectionType == .user ? userCollections[indexPath.row] : downloadCollections[indexPath.row]
        cell.viewModel = CollectionViewmodel(collection: collection)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension CollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell else { return }
        guard let image = cell.imageView.image else { return }
        let selectedCollection = userCollections[indexPath.row]
        
        let itemInfo = ItemInfo(categoryID: selectedCollection.categoryID,
                                collectionID: selectedCollection.collectionID,
                                image: image)
        
        cell.hero.id = "moveToItemVC"
        
        let vc = ItemViewController(itemInfo: itemInfo, selectedCollection: cell)
        vc.modalPresentationStyle = .fullScreen
        vc.imageView.hero.id = "moveToItemVC"
        vc.visualEffectView.hero.id = "moveToItemVC"
        vc.isHeroEnabled = true
        
        present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row)) {
            cell.alpha = 1
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CollectionViewController: UICollectionViewDelegateFlowLayout  {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let gapSum: CGFloat = 20
        let width = (view.frame.width - gapSum) / 3
        let height = view.frame.height / 4
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

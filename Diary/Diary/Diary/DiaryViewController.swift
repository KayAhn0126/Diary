//
//  ViewController.swift
//  Diary
//
//  Created by Kay on 2022/11/26.
//

import UIKit

enum Section {
    case main
}

class DiaryViewController: UIViewController {
    typealias Item = Diary
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    private var diaryList = [Diary]() {
        didSet {
            saveDiaryList()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadDiaryList()
        self.applySnapshot()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let wrietDiaryViewController = segue.destination as? WriteDiaryViewController {
            wrietDiaryViewController.delegate = self
        }
    }
    
    private func saveDiaryList() {
        let data = self.diaryList.map {
            return Diary(titile: $0.titile, contents: $0.contents, date: $0.date, isStar: $0.isStar)
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(try? PropertyListEncoder().encode(data), forKey: "diary")
    }
    
    private func loadDiaryList() {
        let userDefaults = UserDefaults.standard
        if let data = userDefaults.value(forKey: "diary") as? Data {
            let realData = try? PropertyListDecoder().decode([Diary].self, from: data)
            self.diaryList = realData!
            self.diaryList = self.diaryList.sorted(by: {
                $0.date > $1.date
                // $0.date.compare($1.date) == .orderedDescending   이렇게도 작성할 수 있다.
            })
        }
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCollectionViewCell", for: indexPath) as? DiaryCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(diary: item)
            return cell
        })
        collectionView.collectionViewLayout = configureLayout()
    }
    
    private func configureLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(diaryList, toSection: .main)
        dataSource.apply(snapshot)
    }
}

extension DiaryViewController: WriteDiaryDelegateProtocol {
    func didSelectRegister(diary: Diary) {
        self.diaryList.append(diary)
        self.applySnapshot()
    }
}


extension DiaryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "DiaryDetailStoryboard", bundle: nil)
        guard let DiaryDetailViewController = storyboard.instantiateViewController(withIdentifier: "DiaryDetailViewController") as? DiaryDetailViewController else { return }
        DiaryDetailViewController.diary = diaryList[indexPath.row]
        DiaryDetailViewController.indexPath = indexPath
        DiaryDetailViewController.delegate = self
        self.navigationController?.pushViewController(DiaryDetailViewController, animated: true)
    }
}

extension DiaryViewController: DiaryDeleteDelegateProtocol {
    func didSelectDelete(cellLocation: IndexPath) {
        self.diaryList.remove(at: cellLocation.row)
        self.applySnapshot()
    }
}

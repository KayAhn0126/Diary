//
//  StarViewController.swift
//  Diary
//
//  Created by Kay on 2022/11/27.
//

import UIKit

class StarViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    private var diaryList = [Diary]()
    typealias Item = Diary
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        self.configureDataSource()
        
        NotificationCenter.default.addObserver(self, selector: #selector(editDiaryNotification(_:)), name: NSNotification.Name(NotificationPostIdentifier.editDiary), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(starDiaryNotification(_:)), name: NSNotification.Name(NotificationPostIdentifier.starDiary), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteDiaryNotification(_:)), name: NSNotification.Name(NotificationPostIdentifier.deleteDiary), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadStarDiaryList()
    }
    
    // MARK: - userDefaults에서 값을 불러오는 메서드
    private func loadStarDiaryList() {
        let userDefaults = UserDefaults.standard
        if let data = userDefaults.value(forKey: "diary") as? Data {
            let realData = try? PropertyListDecoder().decode([Diary].self, from: data)
            self.diaryList = realData!.filter { $0.isStar == true }
            self.diaryList = self.diaryList.sorted(by: {
                $0.date > $1.date
            })
        }
        self.applySnapShot()
    }
    
    // MARK: - "editDiary"로 noti를 받았을때 실행되는 메서드
    @objc func editDiaryNotification(_ notification: Notification) {
        guard let diary = notification.object as? Diary else { return }
        guard let index = self.diaryList.firstIndex(where: { $0.uuidString == diary.uuidString }) else { return }
        self.diaryList[index] = diary
        self.diaryList = self.diaryList.sorted(by: {
            $0.date > $1.date
        })
    }
    
    // MARK: - "starDiary"로 noti를 받았을때 실행되는 메서드
    @objc func starDiaryNotification(_ notification: Notification) {
        guard let starDiary = notification.object as? [String : Any] else { return }
        guard let diary = starDiary["diary"] as? Diary else { return }
        if diary.isStar {
            self.diaryList.append(diary)
            self.diaryList = self.diaryList.sorted(by: {
                $0.date > $1.date
            })
        } else {
            guard let index = self.diaryList.firstIndex(where: { $0.uuidString == diary.uuidString }) else { return }
            self.diaryList.remove(at: index)
        }
    }
    
    // MARK: - "deleteDiary"로 noti를 받았을때 실행되는 메서드
    @objc func deleteDiaryNotification(_ notification: Notification) {
        guard let uuidString = notification.object as? String else { return }
        guard let index = self.diaryList.firstIndex(where: { $0.uuidString == uuidString }) else { return }
        self.diaryList.remove(at: index)
    }
}

// MARK: - 즐겨찾기에서 셀이 클릭 되었을때 실행되는 메서드
extension StarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "DiaryDetailStoryboard", bundle: nil)
        guard let DiaryDetailViewController = storyboard.instantiateViewController(withIdentifier: "DiaryDetailViewController") as? DiaryDetailViewController else { return }
        let diary = diaryList[indexPath.row]
        DiaryDetailViewController.diary = diary
        DiaryDetailViewController.navigationItem.title = diary.title
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.pushViewController(DiaryDetailViewController, animated: true)
    }
}

// MARK: - collectionView 관련 메서드
extension StarViewController {
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StarCollectionViewCell", for: indexPath) as? StarCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configureCell(diary: item)
            return cell
        })
        collectionView.collectionViewLayout = configureLayout()
    }
    
    private func configureLayout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func applySnapShot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(diaryList, toSection: .main)
        dataSource.apply(snapshot)
    }
}

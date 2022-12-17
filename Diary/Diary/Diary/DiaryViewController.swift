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
        NotificationCenter.default.addObserver(self, selector: #selector(editDiaryNotification(_:)), name: Notification.Name("editDiary"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadDiaryList()
        self.applySnapshot()
    }
    
    // MARK: - segue로 show(navigation)하기전 실행되는 메서드
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let writeDiaryViewController = segue.destination as? WriteDiaryViewController {
            writeDiaryViewController.delegate = self
            writeDiaryViewController.navigationItem.title = "일기 작성"
        }
    }
    
    // MARK: - 현재 DiaryList를 userDefaults에 저장하는 메서드
    private func saveDiaryList() {
        let data = self.diaryList.map {
            return Diary(title: $0.title, contents: $0.contents, date: $0.date, isStar: $0.isStar)
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(try? PropertyListEncoder().encode(data), forKey: "diary")
    }
    
    // MARK: - userDefaults에서 DiaryList를 가져오는 메서드
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
    
    // MARK: - Notification.Name("editDiary")으로 노티가 왔을 때 실행되는 메서드
    @objc func editDiaryNotification(_ notification: Notification) {
        guard let diary = notification.object as? Diary else { return }
        guard let row = notification.userInfo?["indexPath.row"] as? Int else { return }
        self.diaryList[row] = diary
        self.diaryList = self.diaryList.sorted {
            $0.date > $1.date
        }
        self.applySnapshot()
    }
}

// MARK: - WriteDiaryDelegateProtocol 타입의 delegate가 실행할 메서드 정의
extension DiaryViewController: WriteDiaryDelegateProtocol {
    func didSelectRegister(diary: Diary) {
        self.diaryList.append(diary)
        self.applySnapshot()
    }
}

// MARK: - cell이 클릭되었을 때 실행될 메서드 정의
extension DiaryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "DiaryDetailStoryboard", bundle: nil)
        guard let DiaryDetailViewController = storyboard.instantiateViewController(withIdentifier: "DiaryDetailViewController") as? DiaryDetailViewController else { return }
        DiaryDetailViewController.diary = diaryList[indexPath.row]
        DiaryDetailViewController.indexPath = indexPath
        DiaryDetailViewController.deleteDelegate = self
        DiaryDetailViewController.starDelegate = self
        DiaryDetailViewController.navigationItem.title = diaryList[indexPath.row].title
        self.navigationController?.pushViewController(DiaryDetailViewController, animated: true)
    }
}

// MARK: - DiaryDeleteDelegateProtocol 타입의 delegate가 실행할 메서드 정의
extension DiaryViewController: DiaryDeleteDelegateProtocol {
    func didSelectDelete(cellLocation: IndexPath) {
        self.diaryList.remove(at: cellLocation.row)
        self.applySnapshot()
    }
}

// MARK: - DiaryStarDelegateProtocol 타입의 delegate가 실행할 메서드 정의
extension DiaryViewController: DiaryStarDelegateProtocol {
    func didSelectStar(cellLocation: IndexPath, isStar: Bool) {
        self.diaryList[cellLocation.row].isStar = isStar
    }
}


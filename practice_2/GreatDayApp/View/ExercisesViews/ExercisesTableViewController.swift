import UIKit

class ExercisesTableViewController: UITableViewController {
    var videos = [Video]()
    var video: Video?

    override func viewDidLoad() {
        super.viewDidLoad()
        createListOfVideos()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.editButtonItem.tintColor = .black
    }
}

// MARK: UITableViewDelegate
extension ExercisesTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = UITableViewCell()
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: ExercisesCell.identifier, for: indexPath) as? ExercisesCell {
            cell.configure(by: videos[indexPath.row])
            return cell
        } else {
            print("Can`t create the cell NewsCell")
            return defaultCell
        }
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            videos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }

    override func tableView(_ tableView: UITableView,
                            moveRowAt sourceIndexPath: IndexPath,
                            to destinationIndexPath: IndexPath) {
        let movedVideo = videos.remove(at: sourceIndexPath.row)
        videos.insert(movedVideo, at: destinationIndexPath.row)
        tableView.reloadData()
    }
}

// MARK: UITableViewDelegate
extension ExercisesTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.video = videos[indexPath.row]
        performSegue(withIdentifier: "exercisesVideoSegue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "exercisesVideoSegue" {
            guard let videoVC = segue.destination as? VideoViewController else { return }
            videoVC.video = video
        }
    }

    override func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        let favourite = favouriteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete, favourite])
    }

    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive,
                                        title: "Delete") { (_, _, completion) in
            self.videos.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        action.backgroundColor = .systemRed
        action.image = UIImage(systemName: "xmark.bin.fill")
        return action
    }

    func favouriteAction(at indexPath: IndexPath) -> UIContextualAction {
        var video = videos[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "Favourite") { _, _, completion in
            video.isFavourite = !video.isFavourite
            self.videos[indexPath.row] = video
            self.changeButtonColor(for: video, at: indexPath)
            completion(true)
        }
        action.backgroundColor = video.isFavourite ? .systemGreen : .systemGray
        action.image = UIImage(systemName: "heart")
        return action
    }
}

private extension ExercisesTableViewController {
    func createListOfVideos() {
        let firstVideo = Video(youtubeKey: "-uCumUWaJFs", title: "Утренняя йога (15 минут)")
        let secondVideo = Video(youtubeKey: "VTctZ-xWEjY", title: "Утренняя зарядка Цигун (20 минут)")
        let thirdVideo = Video(youtubeKey: "4prOwbTHPeI", title: "Утренняя кардио разминка (15 минут)")
        let fourthVideo = Video(youtubeKey: "Nh98By0Lb_Q", title: "Универсальная разминка (20 минут)")
        let fifthVideo = Video(youtubeKey: "zJNkxuechzY", title: "Утренняя гимнастика (18 минут)")
        let sixthVideo = Video(youtubeKey: "SjJs4VhvMy0", title: "Комплекс упражнений дома (7 минут)")
        videos = [firstVideo, secondVideo, thirdVideo, fourthVideo, fifthVideo, sixthVideo]
    }

    func changeButtonColor(for video: Video, at indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ExercisesCell {
            if video.isFavourite {
                cell.backgroundColor = .systemGreen
            } else {
                cell.backgroundColor = .white
            }
        }
    }
}

//
//  FeedViewController.swift
//  devslopes-showcase
//
//  Created by Egorio on 3/15/16.
//  Copyright © 2016 Egorio. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postField: MaterialTextField!
    @IBOutlet weak var chooseImageButton: UIImageView!

    var posts = [Post]()

    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 300

        imagePicker = UIImagePickerController()
        imagePicker.delegate = self

        DataService.instance.posts.observeEventType(.Value, withBlock: { (snapshot) in
            guard let snapshots = snapshot.children.allObjects as? [FDataSnapshot] else {
                return
            }

            self.posts = []
            for snapshot in snapshots {
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let post = Post(id: snapshot.key, dictionary: dictionary)

                    self.posts.append(post)
                }
            }

            self.tableView.reloadData()
        })
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCellWithIdentifier(Identifier.cellFeed) as? FeedTableCell) ?? FeedTableCell()

        let post = posts[indexPath.row]

        cell.configure(post)

        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let post = posts[indexPath.row]

        if post.imageUrl == nil {
            return 200
        }

        return tableView.estimatedRowHeight
    }

    /*
     * Shows error alert
     */
    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))

        presentViewController(alert, animated: true, completion: nil)
    }
}

extension FeedViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String: AnyObject]?) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        chooseImageButton.image = image
        chooseImageButton.highlighted = true
    }

    @IBAction func chooseImage(sender: UITapGestureRecognizer) {
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func createPost(sender: AnyObject) {

        guard let text = postField.text where text != "" else {
            return showErrorAlert("Post text is required", message: "Please enter post text before publish")
        }

        if let image = chooseImageButton.image where chooseImageButton.highlighted == true {
            let url = NSURL(string: "https://post.imageshack.us/upload_api.php")!
            let file = UIImageJPEGRepresentation(image, 0.5)!
            let key = "12DJKPSU5fc3afbd01b1630cc718cae3043220f3".dataUsingEncoding(NSUTF8StringEncoding)!
            let json = "json".dataUsingEncoding(NSUTF8StringEncoding)!

            Alamofire.upload(.POST, url,
                multipartFormData: { (multipartFormData) in
                    multipartFormData.appendBodyPart(data: file, name: "fileupload", fileName: "image", mimeType: "image/jpg")
                    multipartFormData.appendBodyPart(data: key, name: "key")
                    multipartFormData.appendBodyPart(data: json, name: "format")
                },
                encodingCompletion: { (encodingResult) in
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        upload.responseJSON(completionHandler: { (response) in
                            if let info = response.result.value as? [String: AnyObject],
                                let links = info["links"] as? [String: AnyObject],
                                let imageUrl = links["image_link"] as? String {
                                    self.savePost(["description": text, "imageUrl": imageUrl, "likes": 0])
                            }
                        })
                        case.Failure(let error):
                        print(error)
                    }
            })
        }
        else {
            savePost(["description": text, "likes": 0])
        }
    }

    func savePost(post: [String: AnyObject]) {
        DataService.instance.createPost(post)
        postField.text = ""
        chooseImageButton.highlighted = false
        chooseImageButton.image = UIImage(named: "camera")
    }
}

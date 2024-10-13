//
//  ViewController.swift
//  Project10
//
//  Created by Eren Elçi on 13.10.2024.
//

import UIKit

class ViewController: UICollectionViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.camera, target: self, action: #selector(photoAddClicked))
    }
    
    @objc func photoAddClicked(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
        
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell  else {
            fatalError("unable to dequeue PersonCell.")
        }
        
        let person = people[indexPath.item]
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius =  7
        
        cell.name.text = person.name
        return cell
    }
    
    //Kullanıcı bir resim seçtikten veya çektikten sonra çağrılır.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        //Her resme benzersiz bir isim vermek için kullanılır. Bu, resimlerin çakışmasını önler.
        let imageName = UUID().uuidString
        print(imageName)
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        print(imagePath)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        let person = Person(name: "Unknow", image: imageName)
        people.append(person)
        collectionView.reloadData()
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        //Uygulamanın belgeler dizinine (document directory) erişim sağlar. Bu dizin, uygulamanın verilerini saklamak için idealdir.
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        //Belgeler dizininin URL'sini alır. Genellikle tek bir yol döner, bu yüzden ilk eleman kullanılır
        return paths[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: UIAlertController.Style.alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Rename", style: UIAlertAction.Style.default) { [weak self , weak ac] _ in
            guard let newName = ac?.textFields?[0].text  else { return }
            person.name = newName
            self?.collectionView.reloadData()
        })
        
      
        ac.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        present(ac, animated: true)
        
    }
}


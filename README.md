<details>
    <summary><h2>Uygulma Amacı</h2></summary>
  Proje, kullanıcıların kendi fotoğraflarını yükleyebileceği ve bu fotoğrafların adını değiştirebileceği bir arayüz sağlamayı amaçlamaktadır. Kullanıcılar, uygulamaya fotoğraf ekleyebilir, yükledikleri fotoğrafları görüntüleyebilir ve her bir fotoğraf için bir isim verebilirler. Ayrıca, her bir fotoğraf üzerinde silme işlemi yapabilirler.
  </details> 
  
  <details>
    <summary><h2>collectionView(_:cellForItemAt:) Yöntemi</h2></summary>
    Bu metot, belirli bir hücreyi oluşturur. PersonCell tipinde bir hücre oluşturur, ilgili Person nesnesini alır ve görsel ve isim bilgilerinin ayarlanmasını sağlar. Ayrıca, görselin görünümünü düzenler.
    
    ```
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
        fatalError("unable to dequeue PersonCell.")
    }

    let person = people[indexPath.item]

    let path = getDocumentsDirectory().appendingPathComponent(person.image)
    cell.imageView.image = UIImage(contentsOfFile: path.path)

    cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
    cell.imageView.layer.borderWidth = 2
    cell.imageView.layer.cornerRadius = 3
    cell.layer.cornerRadius = 7

    cell.name.text = person.name
    return cell
    }




    ```
  </details> 

  <details>
    <summary><h2>imagePickerController(_:didFinishPickingMediaWithInfo:) Yöntemi</h2></summary>
    Kullanıcı bir resim seçtiğinde veya çektikten sonra çağrılır. Seçilen resmi alır, benzersiz bir isim oluşturur ve bu resmi belgeler dizinine kaydeder. Ayrıca, yeni bir Person nesnesi oluşturur ve people dizisine ekler.

    
    ```
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.editedImage] as? UIImage else { return }

    let imageName = UUID().uuidString
    let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

    if let jpegData = image.jpegData(compressionQuality: 0.8) {
        try? jpegData.write(to: imagePath)
    }
    let person = Person(name: "Unknown", image: imageName)
    people.append(person)
    collectionView.reloadData()
    dismiss(animated: true)
    }

    ```
  </details> 




<details>
    <summary><h2>getDocumentsDirectory() Yöntemi</h2></summary>
    Uygulamanın belgeler dizininin URL'sini alır. Bu dizin, uygulamanın verilerini saklamak için idealdir. Hata oluşursa, hata mesajı konsola yazdırılır.

    
    ```
    func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
    }


    ```
  </details>

  <details>
    <summary><h2>collectionView(_:didSelectItemAt:) Yöntemi</h2></summary>
    Kullanıcı bir hücreye tıkladığında, bir UIAlertController açılır. Bu kontrol, kullanıcıya kişiyi yeniden adlandırma veya silme seçenekleri sunar. Kullanıcı bir isim girerse, bu isim güncellenir. Eğer silme seçeneği seçilirse, kişi diziden kaldırılır ve görünüm güncellenir.

    
    ```
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let person = people[indexPath.item]

    let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: UIAlertController.Style.alert)
    ac.addTextField()

    ac.addAction(UIAlertAction(title: "Rename", style: UIAlertAction.Style.default) { [weak self, weak ac] _ in
        guard let newName = ac?.textFields?[0].text else { return }
        person.name = newName
        self?.collectionView.reloadData()
    })

    ac.addAction(UIAlertAction(title: "Sil", style: .destructive) { [weak self] _ in
        self?.people.remove(at: indexPath.item) // İlgili kişiyi diziden kaldır
        self?.collectionView.deleteItems(at: [indexPath]) // CollectionView'dan öğeyi sil
    })

    ac.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
    present(ac, animated: true)
    }


    ```
  </details>
  
  
<details>
    <summary><h2>Uygulama Görselleri </h2></summary>
    
    
 <table style="width: 100%;">
    <tr>
        <td style="text-align: center; width: 16.67%;">
            <h4 style="font-size: 14px;">Kullanuici Arayuz</h4>
            <img src="https://github.com/user-attachments/assets/edbdbfd9-d8ef-422e-88ff-a344bc74c808" style="width: 100%; height: auto;">
        </td>
        <td style="text-align: center; width: 16.67%;">
            <h4 style="font-size: 14px;">Duzeltme ve Silme Islemi</h4>
            <img src="https://github.com/user-attachments/assets/1ffea39a-680a-4135-a3e9-321b8bb5e066" style="width: 100%; height: auto;">
        </td>
    </tr>
</table>
  </details> 

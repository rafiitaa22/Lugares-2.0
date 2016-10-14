//
//  ViewController.swift
//  Lugares
//
//  Created by Rafael Larrosa Espejo on 13/9/16.
//  Copyright © 2016 es.elviejoroblesabadell.xCode. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    
    var places : [Place] = []
    var fetchResultsController : NSFetchedResultsController<Place>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // solo aparece el boton hacia atras sin texto
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        //mejorar la gestión de recarga de datos en la tabla
        let fetchRequest : NSFetchRequest<Place> = NSFetchRequest(entityName: "Place")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer{
            let context = container.viewContext
            self.fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            self.fetchResultsController.delegate = self
            do{
                try fetchResultsController.performFetch()
                self.places = fetchResultsController.fetchedObjects!
                
            }catch{
                print("Error al recuperar los lugares")
            }
        }
        

        // elimina las rows vacias de abajo cuando acaba la lista
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //solo oculta la barra de navegacion on swipe
        navigationController?.hidesBarsOnSwipe = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    // tres metodos (funciones) para delegar
    // secciones si vamos a mostrar todas las recetas juntas pondremos solo 1 sección
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //numero de filas por sección, el numero de recetas es el tamaño del array
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.places.count
    }
    
    
    // se llama para cada una y todas de las celdas que se muestran en pantalla, indexpath es el indicador de donde está la seccion y la fila
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let place = places[indexPath.row]
        let cellID = "PlaceCell"
        // la funcion dequeReusableCell solo muestra lo que cabe por pantalla y gesetiona mejor la memoria
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PlaceCell
        
        cell.thumbnailImageView.image = UIImage(data:place.image as! Data)
        cell.titleLabel.text = place.name
        cell.timeLabel.text = place.type
        cell.ingredientsLabel.text = place.location
        //hacer el borde circular y cortar lo que sobresale
        //cell.thumbnailImageView.layer.cornerRadius = 40
        //cell.thumbnailImageView.clipsToBounds = true
        //la otra manera de hacer lo del ciruclo se hace desde el storyboard
       
        
        return cell
    }
    //la vista dice al contrlador que borre el elemento y se ha borrado, pero falta implementar que se repinte la vista
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.places.remove(at: indexPath.row)
        }
        
        // self.tableView.reloadData() esto refrescaria la tabla entera y podria causar problemas si es muy larga
        //este hace el efecto de fade al borrar y no necesita refrescar la vista entera
        self.tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        //accion de compartir
        let shareAction = UITableViewRowAction(style: .default, title: "Compartir") { (action, indexPath) in
            
            let place = self.places[indexPath.row]
            
            let shareDefautText = "Estoy visitando \(place.name) en la app del Curso de iOS 10."
            let activityController = UIActivityViewController(activityItems: [shareDefautText,UIImage(data:place.image! as Data)!], applicationActivities: nil)
            self.present(activityController, animated: true, completion: nil)
        }
        shareAction.backgroundColor = UIColor(red: 30.00/255.0, green: 164.0/255.0, blue: 253.0/255.0, alpha: 1.0)
        // se debe añadir de nuevo la accion de eliminar porque esta la sobreescribe
        
        let deleteAction =  UITableViewRowAction(style: .default, title: "Eliminar") { (accion, indexPath) in
            if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer{
                let context = container.viewContext
                let placeToDelete = self.fetchResultsController.object(at: indexPath)
                context.delete(placeToDelete)
                do{
                    try context.save()
                }catch{
                    print("Error al guardar")
                }
            }
           /*Sin coredata estaba bien borrar así
             self.places.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)*/
        }
        deleteAction.backgroundColor = UIColor(red: 202/255.0, green: 202.0/255.0, blue: 202.0/255.0, alpha: 1.0)
        
        return [shareAction, deleteAction]
    }
    
    
    //MARK: UIVIEWTABLEDELEGATE, la comentamos porque al utilizar otra vista para ver detalles se mostrria el boton de favoritos
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // hemos pulsado en el cambio de viewcontroller de ver detalles
        if segue.identifier == "showDetail" {
            
            //primero detectar que elemento se ha seleccionado y luego sacar la receta y enviarla al viewcontroller nuevo
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let selectedPlace = self.places[indexPath.row]
                let destinationViewController = segue.destination as! DetailViewController
                destinationViewController.place = selectedPlace
            }
        }
    }
    
    
    @IBAction func unwindToMainViewController(segue:UIStoryboardSegue){
        if segue.identifier == "unwindToMainViewController" {
            if let addplaceVC = segue.source as? AddPlaceViewController
            {
                if let newPlace = addplaceVC.place{
                    self.places.append(newPlace)
                    //self.tableView.reloadData()
                }
            }
        }
        
    }
    
    
    
    
    
}

extension ViewController : NSFetchedResultsControllerDelegate{
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath{
                self.tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath{
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath{
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }
        case .move:
            if let indexPath = indexPath , let newIndexPath = newIndexPath{
                self.tableView.moveRow(at: indexPath, to: newIndexPath)
            }

        
        }
        self.places = controller.fetchedObjects as! [Place]
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
}



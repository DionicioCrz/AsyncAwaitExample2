//
//  ViewController.swift
//  AsyncAwaitExample2
//
//  Created by Dionicio Cruz Velázquez on 12/2/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    private var presenter: Presenter = Presenter(service: PokemonServiceImpl2())
    private var displayablePokemon: [DisplayablePokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupLoader()
        presenter.setView(view: self)
        presenter.fetchPokemon()
    }
    
    private func setupLoader() {
        loader.hidesWhenStopped = true
        loader.stopAnimating()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        displayablePokemon.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DetailTableViewCell
        cell.setup(with: displayablePokemon[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
}

extension ViewController: PokemonView {
    func display(pokemon: [DisplayablePokemon]) {
        displayablePokemon = pokemon
        tableView.reloadData()
    }
    
    func showLoader() {
        loader.startAnimating()
    }
    
    func hideLoader() {
        loader.stopAnimating()
    }
    
    
    func showErrorMessage() {
        print("Pretend Im showing an error message")
    }
}

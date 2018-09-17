//done
import UIKit

class ManagerStorageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var transactions = [Transaction]()
    
        var parameters = ["status": "2","warehouse": (User.current?.warehouse)!]

    @IBOutlet weak var tableview: UITableView!
  
    @IBAction func refreshPage(_ sender: UIBarButtonItem) {
        
        reloadData()
    }
    
    
    var json : Any = ""{
        didSet{
            
            guard let transaction = json as? [Json] else {return}
            for (idx ,tran) in transaction.enumerated() {
                guard let tran = tran as? Json else {return}
                
                DispatchQueue.main.async {
                    self.transactions.append(Transaction(json: tran))
                    let indexpath = IndexPath(row: idx, section: 0)
                    self.tableview.insertRows(at: [indexpath], with: .right)
                }
            }
        }}

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
        
        reloadData()

    }
    
    func reloadData(){

        transactions = []
        tableview.reloadData()

        getWaitingProducts()
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManagerStorageCell") as! ManagerStorageTableViewCell
        
        var transaction = transactions[indexPath.row]
        
        var product = Products().search(forBarcode: transaction.product)
        cell.imageProd.image = product?.prodImage
        cell.nameProd.text = product?.prodName
        cell.dateProd.text = SecToDate(timeStamp: transaction.locationAtime)

    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ManagerStockToTransaction", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? ManagerStorageProductViewController{
            dest.transaction = transactions[(tableview.indexPathForSelectedRow?.row)!]

        }
  
        
    }
   
}


extension ManagerStorageViewController{
    
    func getWaitingProducts(){
        guard let url = URL(string: "https://maternaApp.mybluemix.net/api/v1/transactions/managereye") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    self.json = try JSONSerialization.jsonObject(with: data, options: [])
                    
                } catch {
                    print(error)
                }
            }
            
            }.resume()
    }
}


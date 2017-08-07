import MongoKitten

struct Contacto {

	let bd = server["contactos"]

	var id : ObjectId
	var nombre : String
	var telefono : String
	var correos : String
	var refs : String
	var vinculos : String

	

	init(name : String,phone : String, mails : String, referencias : String, vinculos : String){
		self.id = ObjectId()
		self.nombre = name
		self.telefono = phone
		self.correos = mails
		self.refs = referencias
		self.vinculos = vinculos
		//self.correos = mails
		//self.refs = referencias
		//self.vinculos = vinculos
	}

	init(id : String){
		do{
		let oID = try ObjectId(id)
		let query : Query = "_id" == oID
			do{
				let contacto = try bd.findOne(matching : query)
				
				let nombre = contacto!.dictionaryValue["nombre"] as? String
				let telefono = contacto!.dictionaryValue["telefono"] as? String
				let correos = contacto!.dictionaryValue["correos"] as? String
				let refs = contacto!.dictionaryValue["refs"] as? String
				let vinculos = contacto!.dictionaryValue["vinculos"] as? String
				
				self.id = oID
				self.nombre = nombre!
				self.telefono = telefono!
				self.correos = correos!
				self.refs = refs!
				self.vinculos = vinculos!
			}catch{

				fatalError()
			}
		}catch{
			fatalError()
		}
		
		
	}

	func save(){
		let query : Query = "_id" == self.id
		var document = [
		"_id" : self.id, 
		"nombre" : self.nombre, 
		"telefono" : self.telefono, 
		"correos" : self.correos, 
		"refs" : self.refs, 
		"vinculos" : self.vinculos] as Document
		print(document)
		do{
			try bd.update(matching : query, to : document, upserting : true)
		}catch{
			print("Error al insertar contacto a la BD")
		}
	}

	func delete() throws {
		try bd.remove(matching : "_id" == self.id)
	}
}

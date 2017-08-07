
import Vapor

import MongoKitten

let server = try! Database(mongoURL: "mongodb://admin:admin@ds157740.mlab.com:57740/pruebakitten")
let contacts = server["contacts"]

extension Droplet {
    func setupRoutes() throws {
        get("hello") { req in
            var json = JSON()
            try json.set("hello", "world")
            return json
        }

        get("plaintext") { req in
	    let doc = ["name": "inti" ] as Document
            return "Hello, world!"
	    
        }

	get("contact") { req in 
		guard let id = req.headers["id"]?.string else {
			throw Abort.badRequest
		}

		let contacto = Contacto(id : id)
		print(contacto)
		return "adios"
	}

	get("contacts") { req in
		do{
		let contactos = try contacts.find()
		var Mirr = Mirror(reflecting : contactos)
		print(Mirr.subjectType)
		}catch{
			fatalError()
		}
		return "hola"
	}

	post("contact") { req in
		let nombre = req.data["nombre"]!.string
		let telefono = req.data["telefono"]!.string
		let correos = req.data["correos"]!.array
		var correos2 = ""
		print("CORREOS")
		correos?.forEach{
			if(correos2 != ""){
				correos2 += ","
			}
			correos2 += $0.wrapped.string!
		}
		print (correos2)
		print("REFS")
		let refs = req.data["refs"]!.array
		var refs2 = ""
		refs?.forEach{
			if(refs2 != ""){
				refs2 += ","
			}
			refs2 += $0.wrapped.string!
		}
		print("VINCULOS")
		let vinculos = req.data["vinculos"]!.array
		var vinculos2 = ""
		vinculos?.forEach{
			if(vinculos2 != ""){
				vinculos2 += ","
			}
			vinculos2 += $0.wrapped.string!
		}
		let contact = Contacto(name : nombre!,phone : telefono!,mails : correos2,referencias : refs2,vinculos : vinculos2)
		print("nombre es \(contact.nombre) , correos son \(contact.correos) , refs son \(contact.refs)")
		try contact.save()
		return "Usuario guardado!"		
	}

        // response to requests to /info domain
        // with a description of the request
        get("info") { req in
            return req.description
        }

        get("description") { req in return req.description }
        
	delete("contact") { req in 
		guard let id = req.headers["id"]?.string else {
			throw Abort.badRequest
		}

		let contacto = Contacto(id : id)
		try contacto.delete()
		return "Contacto borrado"
	}
        try resource("posts", PostController.self)
    }
}

//
//  PerfectHandlers.swift
//  Authenticator
//
//  Created by Kyle Jessup on 2015-11-09.
//	Copyright (C) 2015 PerfectlySoft, Inc.
//
//     This program is free software: you can redistribute it and/or modify
//     it under the terms of the GNU Affero General Public License as published by
//     the Free Software Foundation, either version 3 of the License, or
//     (at your option) any later version.
//
//     This program is distributed in the hope that it will be useful,
//     but WITHOUT ANY WARRANTY; without even the implied warranty of
//     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//     GNU Affero General Public License for more details.
//
//     You should have received a copy of the GNU Affero General Public License
//     along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

import PerfectLib

// Full path to the SQLite database in which we store our data.
let AUTH_DB_PATH = PerfectServer.staticPerfectServer.homeDir() + SQLITE_DBS + "AuthenticatorDb"

// HTTP authentication realm
let AUTH_REALM = "Authenticator Perfect Example"

// This is the function which all Perfect Server modules must expose.
// The system will load the module and call this function.
// In here, register any handlers or perform any one-time tasks.
public func PerfectServerModuleInit() {
	
	// Register our handler class with the PageHandlerRegistry.
	// The name "TTHandler", which we supply here, is used within a moustache template to associate the template with the handler.
	PageHandlerRegistry.addPageHandler("LoginHandler") {
		
		// This closure is called in order to create the handler object.
		// It is called once for each relevant request.
		// The supplied WebResponse object can be used to tailor the return value.
		// However, all request processing should take place in the `valuesForResponse` function.
		(r:WebResponse) -> PageHandler in
		
		return LoginHandler()
	}
	
	PageHandlerRegistry.addPageHandler("RegistrationHandler") {
		(r:WebResponse) -> PageHandler in
		return RegistrationHandler()
	}
	
	PageHandlerRegistry.addPageHandler("AccessHandler") {
		(r:WebResponse) -> PageHandler in
		return AccessHandler()
	}
	
	// For example, demo purposes - remove the existing database so that one has to register each time
	let oldFile = File(AUTH_DB_PATH)
	if oldFile.exists() {
		oldFile.delete()
	}
	
	// Create our SQLite tracking database.
	do {
		let sqlite = try SQLite(AUTH_DB_PATH)
		try sqlite.execute("CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, fname TEXT, lname TEXT, email TEXT)")
		try sqlite.execute("CREATE TABLE IF NOT EXISTS auth (id_user INTEGER, key TEXT)")
	} catch {
		print("Failure creating tracker database at " + AUTH_DB_PATH)
	}
}
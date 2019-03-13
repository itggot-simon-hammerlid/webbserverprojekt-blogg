require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'

enable :sessions

get('/') do
    slim(:index)
end


get('/register') do
    slim(:register)
end

post('/create') do
    db = SQLite3::Database.new('db/Databasen.db')
    db.results_as_hash = true

    result = db.execute("SELECT username FROM users WHERE username=?", params["Username"])

    if result.length != 0
        redirect('/register')
    end
    
    hashat_password = BCrypt::Password.create(params["Password"])

    db.execute("INSERT INTO users (username, password) VALUES (?, ?)", params["Username"], hashat_password)
    redirect('/')
end

get('/login') do
    slim(:login)
end

post('/login') do
    db = SQLite3::Database.new('db/Databasen.db')
    db.results_as_hash = true
    #hashat_password = BCrypt::Password.create(params["Password"])
    #result = db.execute("SELECT * FROM users WHERE Username = ? AND Password = ?",params["Username"], hashat_password)
    pass = db.execute("SELECT id, password FROM users WHERE username = ?",params["Username"])
    
    #p pass.first["password"]
    #p params["Password"]
    if pass.length == 0
        redirect('/error')
    end
    

    if BCrypt::Password.new(pass[0]["password"]) == params["Password"]
        session["user"] = pass[0]['id']
        # ^sessions
        redirect('/worm')
    else
        redirect('/error')
    end
    
    #if result == []
    #    redirect('/error')
    #result.first["Password"] 
    #else
    #    redirect('/worm')
    #end
end


get('/error') do
    slim(:error)
end

get('/eroexist') do
    slim(:erroexist)
end

post('/eroexist') do
    db = SQLite3::Database.new('db/Databasen.db')
    db.results_as_hash = true
    #byebug 
    result = db.execute("SELECT * FROM users WHERE username = ? AND password = ?",params["Username"], params["Password"])
    
    if result == []
        redirect('/error')
        #result.first["Password"] 
    else
        redirect('/worm')
    end
end

post('/error') do
    db = SQLite3::Database.new('db/Databasen.db')
    db.results_as_hash = true

    result = db.execute("SELECT * FROM users WHERE username = ? AND password = ?",params["Username"], params["Password"])
    
    if result == []
        redirect('/error')
        #result.first["Password"] 
    else
        redirect('/worm')
    end
end

get('/worm') do
    slim(:worm)
end

get('/profile') do
    slim(:profile)
end

post('/post') do
    db = SQLite3::Database.new('db/Databasen.db')
    db.results_as_hash = true

    #result = db.execute("SELECT username FROM users WHERE username=?", params["Username"])

   # if result.length != 0
    #    redirect('/register')
    #end
    
    #hashat_password = BCrypt::Password.create(params["Password"])

    #db.execute("INSERT INTO users (username, password) VALUES (?, ?)", params["Username"], hashat_password)
    redirect('/profile')
end

get('/logout') do
    session.clear
    redirect('/')
end


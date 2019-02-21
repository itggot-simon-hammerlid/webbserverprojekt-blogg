require 'sinatra'
require 'slim'
require 'sqlite3'
require 'byebug'
require 'bcrypt'

get('/') do
    slim(:index)
end

get('/register') do
    slim(:register)
end

post('/create') do
    db = SQLite3::Database.new('db/Databeis.db')
    db.results_as_hash = true

    hashat_password = BCrypt::Password.create(params["Password"])

    db.execute("INSERT INTO users (Username, Password) VALUES(?, ?)", params["Username"], hashat_password)

    redirect('/login')
end

get('/login') do
    slim(:login)
end

post('/login') do
    db = SQLite3::Database.new('db/Databeis.db')
    db.results_as_hash = true
    #hashat_password = BCrypt::Password.create(params["Password"])
    #result = db.execute("SELECT * FROM users WHERE Username = ? AND Password = ?",params["Username"], hashat_password)
    pass = db.execute("SELECT Password FROM users WHERE Username = ?",params["Username"])
    
    if (BCrypt::Password.new(pass.first["Password"]) == params["Password"]) == true
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

post('/error') do
    db = SQLite3::Database.new('db/Databeis.db')
    db.results_as_hash = true
    #byebug 
    result = db.execute("SELECT * FROM users WHERE Username = ? AND Password = ?",params["Username"], params["Password"])
    
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

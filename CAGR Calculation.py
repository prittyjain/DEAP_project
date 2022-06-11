import mysql.connector
datbas= mysql.connector.connect(
    host ="localhost",
    user="root",
    password= "Flipkart@123"
)
mycursor=  datbas.cursor()
mycursor.execute("CREATE DATABASE database")
mycursor.execute("CREATE TABLE CAGR (comp_name varchar(255), initial_value varchar(255), final_value varchar(255), time_period varchar(255))")
mycursor.execute("SHOW TABLES")
sql = "INSERT INTO CAGR (comp_name, initial_value, final_value, time_period) values (%s, %s)"
val= [
    ('Reliance', 100000, 200000, 5),
    ('Tata', 200000, 300000, 2),
    ('Birla', 100000, 10000, 5),
    ('lenovo', 300000, 400000, 6),
    ('LG', 6000000, 300000, 10),
    ('Adidas', 6000, 90000000, 6),
    ('HP', 200000, 3000, 7),
    ('Infosys', 20000, 1000000, 8),
    ('Wipro', 4000, 200000, 2),
    ('Accenture', 1000000, 200000000, 12),
    ('Reliance chem', 1000000000, 200000, 3),
    ('jio', 1000900, 400, 4)
]
mycursor.executemany(sql,val)
datbas.commit()
print(mycursor.rowcount, "was inserted. ")

alter= "ALTER TABLE CAGR ADD CAL_CAGR varchar(255) DEFAULT 'CS'"
mycursor.execute(alter) 
print("thankyou")

print("vitish")

print("pritty")

#!/usr/bin/env python
import MySQLdb
import urllib
import urllib2
from dist import *

#update database
url = 'http://primus-physiotherapy.com/tps/refresh.php'
values = {'uname':'user1','password':'user','tablename':'emergency'}
data = urllib.urlencode(values)
req = urllib2.Request(url,data)
response = urllib2.urlopen(req)
the_string = response.read()


db = MySQLdb.connect(host="localhost", 
                     user="project", 
                     passwd="pass1234", 
                     db="tps")
cur = db.cursor()
query = "DELETE FROM emergency"
cur.execute(query)

the_string = the_string.split('\n',1)  
the_string = the_string[0];
rows = the_string.split('$')
rows.pop()
for row in rows:
	query = "INSERT INTO emergency VALUES ("
	cols = row.split('|')
	cols.pop()
	values = []
	for col in cols:
		col = "'"+col+"'"
		values.append(col)
	values = ','.join(values)
	query = query + values +")"	
	cur.execute(query)

#update tsignal
url = 'http://primus-physiotherapy.com/tps/refresh.php'
values = {'uname':'user1','password':'user','tablename':'tsignal'}
data = urllib.urlencode(values)
req = urllib2.Request(url,data)
response = urllib2.urlopen(req)
the_string = response.read()
query = "DELETE FROM tsignal"
cur.execute(query)

the_string = the_string.split('\n',1)
the_string = the_string[0]



rows = the_string.split('$')
rows.pop()
for row in rows:
	query = "INSERT INTO tsignal VALUES ("
	cols = row.split('|')
	cols.pop()
	values = []
	for col in cols:
		col = "'"+col+"'"
		values.append(col)
	values = ','.join(values)
	query = query + values +")"	
	cur.execute(query)


#update position
url = 'http://primus-physiotherapy.com/tps/refresh.php'
values = {'uname':'user1','password':'user','tablename':'position'}
data = urllib.urlencode(values)
req = urllib2.Request(url,data)
response = urllib2.urlopen(req)
the_string = response.read()

query = "DELETE FROM position"
cur.execute(query)

the_string = the_string.split('\n',1)
the_string = the_string[0]

rows = the_string.split('$')
rows.pop()
for row in rows:
	query = "INSERT INTO position VALUES ("
	cols = row.split('|')
	cols.pop()
	values = []
	for col in cols:
		col = "'"+col+"'"
		values.append(col)
	values = ','.join(values)
	query = query + values +")"	
	cur.execute(query)

#update preempt
url = 'http://primus-physiotherapy.com/tps/refresh.php'
values = {'uname':'user1','password':'user','tablename':'preempt'}
data = urllib.urlencode(values)
req = urllib2.Request(url,data)
response = urllib2.urlopen(req)
the_string = response.read()

query = "DELETE FROM preempt"
cur.execute(query)

the_string = the_string.split('\n',1)
the_string = the_string[0]

rows = the_string.split('$')
rows.pop()
for row in rows:
	query = "INSERT INTO preempt VALUES ("
	cols = row.split('|')
	cols.pop()
	values = []
	for col in cols:
		col = "'"+col+"'"
		values.append(col)
	values = ','.join(values)
	query = query + values +")"	
	cur.execute(query)

#actual computation starts here
cur.execute("select * from emergency where t_sigid = 2")
results1 = cur.fetchall()


# Find all the signals that are within
# 0.5 KM of the ambulance
for row1 in results1:
	list_of_signals = []
	amb_pos = [row1[1], row1[2]]
	amb_id = row1[0]
	j_id = row1[6]
	cur.execute("select * from tsignal")
	result2 = cur.fetchall()
	for row2 in result2:
		sig_pos = [row2[2], row2[3]]
		if str(row2[5])==1:
			continue
		cur.execute("select count(*) from preempt where e_jid = "+str(j_id)+" and t_sigid = "+str(row2[0]))
		result8 = cur.fetchall()
		if result8[0][0] == 1:
			continue		
		dist = distance(amb_pos, sig_pos)
		
		if abs(dist) < 0.5:
			sig_id = row2[0]
			list_of_signals.append(sig_id)

	Min = 9999
	signo = -1
	roadno = -1
	for signal in list_of_signals:
		cur.execute("select * from position where t_sigid = " + str(signal))
		results3 = cur.fetchall()
		for row3 in results3:
			road_pos = [row3[3], row3[4]]
			dist = distance(amb_pos,road_pos)			
			if dist < Min:
				Min = dist
				signo = signal
				roadno = row3[2]

	if Min != 9999:
		#send http request.
		cur.execute("select * from tsignal where t_sigid = " + str(signo))
		results4 = cur.fetchall()
		f=open("test.txt","w");
		for row4 in results4:	
			url = "http://"+row4[6]+"/?E"+row4[1]+str(roadno)
			print url			
			response = urllib2.urlopen(url)
			resp = response.read()
		
		#update db
		url = 'http://primus-physiotherapy.com/tps/preempt.php'
		values = {'uname':'user1','password':'user','amb_id': amb_id,'sig_id':signo,'road_no':roadno}
		data = urllib.urlencode(values)
		req = urllib2.Request(url,data)
		response = urllib2.urlopen(req)
		resp2 = response.read()

#return after preemption
cur.execute("select * from emergency where t_sigid <> 2")
results1 = cur.fetchall()

for row1 in results1:
	signo = row1[5]
	roadno = row1[10]
	amb_pos = [row1[1], row1[2]]
	amb_id = row1[0]
		
	cur.execute("select * from tsignal where t_sigid = " + str(signo))
	results2 = cur.fetchall()
	sig_pos = [results2[0][2],results2[0][3]]
		
	cur.execute("select * from position where t_sigid = " + str(signo) + " and p_roadno = " + str(roadno))
	results3 = cur.fetchall()
	road_pos = [results3[0][3], results3[0][4]]
	if distance(road_pos, sig_pos) < distance(amb_pos, road_pos):
		#send http request
		cur.execute("select * from tsignal where t_sigid = " + str(signo))
		result5 = cur.fetchall()
		for row5 in result5:
			url = "http://"+row5[6]+"/?E"+row5[1]+"5"
		response = urllib2.urlopen(url)
		resp = response.read()

		#on success update db
		url = 'http://primus-physiotherapy.com/tps/returntonormal.php'
		values = {'uname':'user1','password':'user','amb_id': amb_id,'sig_id':signo, 'road_no':roadno}
		data = urllib.urlencode(values)
		req = urllib2.Request(url,data)
		response = urllib2.urlopen(req)
		resp2 = response.read()

#check for anomalies

#if app is closed during preemption
cur.execute("select * from tsignal where t_preempt = 1")
resultx = cur.fetchall()

for row in resultx:
	cur.execute("select count(*) from emergency where t_sigid = "+str(row[0]))
	resulty = cur.fetchall()
	if resulty[0][0] == 0:
		url = "http://"+row[6]+"/?E"+row[1]+"5"
		response = urllib2.urlopen(url)
		resp = response.read()
		#on success update db
		url = 'http://primus-physiotherapy.com/tps/returntonormal.php'
		values = {'uname':'user1','password':'user','amb_id': 0,'sig_id':row[0], 'road_no':5}
		data = urllib.urlencode(values)
		req = urllib2.Request(url,data)
		response = urllib2.urlopen(req)
		resp2 = response.read()

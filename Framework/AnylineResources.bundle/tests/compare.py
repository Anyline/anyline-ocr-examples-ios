from __future__ import unicode_literals
import json
import sys


class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

file1   = sys.argv[1] + "/report.json"
file2   = sys.argv[2] + "/report.json"
outhtmlfile = sys.argv[3]

json1 = {}
json2 = {}

with open(file1) as f:
  json1 = json.load(f)


with open(file2) as f:
  json2 = json.load(f)


data1 = json1["data"]
data2 = json2["data"]


m_same   = []
m_better = []
m_worse  = []

mhtml_same   = []
mhtml_better = []
mhtml_worse  = []

msgs_html = "<tr>"

for name1 in data1.keys():
	dp1 = data1[name1]
	dp2 = data2.get(name1)
	if dp2 == None:
		print ("" + name1 + "does not exist in" + file2 )

	acci = int(dp1["accuracy"] or 0) - int(dp2["accuracy"] or 0)
	acc = str(acci)
	recall = str(int(dp1["recall"] or 0)    - int(dp2["recall"] or 0))
	prec = str(int(dp1["precision"] or 0) - int(dp2["precision"] or 0))

	msgs = " " + name1.ljust(60)   +  str(int(dp2["accuracy"] or 0)).rjust(10) +  str(int(dp1["accuracy"] or 0)).rjust(10) + acc.rjust(10) + recall.rjust(10)+ prec.rjust(10)
	msgs_html =  "<th>" + name1 + "</th><th>" +  str(int(dp2["accuracy"] or 0)) + "</th><th>" +  str(int(dp1["accuracy"] or 0)) + "</th><th>" + acc + "</th><th>" + recall + "</th><th>" + prec + "</th>"
	
	if acci < 0:
		m_worse.append(msgs)
		mhtml_worse.append(msgs_html)
		continue
	if acci > 0:
		m_better.append(msgs)
		mhtml_better.append(msgs_html)
		continue
	m_same.append(msgs)
	mhtml_same.append(msgs_html)

# Console



for msg in m_same:
	print (bcolors.WARNING + msg + bcolors.ENDC)

for msg in m_better:
	print (bcolors.OKGREEN + msg + bcolors.ENDC)

for msg in m_worse:
	print (bcolors.FAIL + msg + bcolors.ENDC)


# HTMLtr:nth-child(even) {background-color: #f2f2f2;}
markdowns = '<style>body { padding:30px; width:960px; font-family: "Courier New", Courier, monospace; font-size: x; } table th{text-align:right} table tr:nth-child(even) {background-color: #f2f2f2;} table th:first-child{text-align:left} hr.fat {border: 10px solid #0099ff;border-radius: 5px;} </style><br><h1>Anyline LISA Tests</h1><hr class="fat">'
markdowns += "<table style='width:100%'>"

markdowns +=  "<th>Set Name</th><th> Old Accuracy </th><th> New Accuracy </th><th>Accuracy Diff</th><th>Recall Diff</th><th>Precision Diff</th>"

markdowns += str("Total:  " + str(len(data1.keys()))  + "<br>")
markdowns += str("Worse:  " + str(len(mhtml_worse))  + "<br>")
markdowns += str("Better: " + str(len(mhtml_better)) + "<br>")
markdowns += str("Same:   " + str(len(mhtml_same))   + "<br>")


for msg in mhtml_worse:
	markdowns += "<tr style='color: red;'>"
	markdowns += msg + "\n"
	markdowns += "</tr>"

for msg in mhtml_better:
	markdowns += "<tr style='color: green;'>"
	markdowns += msg + "\n"
	markdowns += "</tr>"

for msg in mhtml_same:
	markdowns += "<tr>" + msg + "</tr>\n"

markdowns += "</span>"

msgs_html = "</table>"



with open(outhtmlfile, 'w') as f:
	f.write(markdowns)
	f.close()



import markdown2
import yaml
import subprocess
import glob
import os
from datetime import datetime
import json
import argparse

dateTimeObj = datetime.now()
timestampStr = dateTimeObj.strftime("%Y-%m-%d-%H-%M-%S")

print (timestampStr)

parser = argparse.ArgumentParser()
parser.add_argument("anylinecli", help="Path to the CLI", type=str)
args = parser.parse_args()


print ("Using CLI: " + args.anylinecli)


def createReport(outfolder):
	outstring = ''
	conciseString = ''

	outjson = {}
	
	outjsondata = {}	
	
	versionlog = subprocess.check_output(['tests/scripts/log_info.sh'])

	#outjson["version"] = { "timestamp" : versionlog.decode('utf-8'), "versionlog" : versionlog }
	
	#print (outjson)
	outstring += '### Time: <br>  \n' + timestampStr + '  <br>  \n'
	outstring += '### Versions: <br>  \n' + versionlog.decode('utf-8') + '  <br>  \n'

	print(outstring)

	print ("Creating report in " , outfolder);
	for testFolder in glob.glob(outfolder + "/*"):
		if not os.path.isdir(testFolder):
			continue
		print ("Using report in " , testFolder);
		testpluginname = os.path.basename(testFolder)
		outstring += '# ' + testpluginname
		outstring += '  \n' + '  \n'

		for jsonfilename in glob.glob(testFolder + "/*.json"):
			print ("Using file " , jsonfilename);
			with open(jsonfilename, 'r') as file:
				data = file.read()
				report = json.loads(data)
				print (report)

				link = 'http://' + report['report'] 
				metrics = report['metrics']
				#outstring += '\n***\n'
				outstring += '### ' + report['name']
				outstring += '  \n\n'
				outstring += 'Name | Value\n'
				outstring += ' --- | ---\n'
				outstring += 'Accuracy    | ' +  str(int(metrics['accuracy'] or 0)) + '%'
				outstring += '  \n'
				outstring += 'Recall      | ' +  str(int(metrics['recall'] or 0)) + '%'
				outstring += '  \n'
				outstring += 'Precision   | ' +  str(int(metrics['precision'] or 0)) + '%'
				outstring += '  \n'
				outstring += 'Report Link: [Open Report](' + link + ')'
				outstring += '  \n'
				outstring += '<br>'
				outjsondata[report['name']] = { "accuracy" : str(int(metrics['accuracy'] or 0)),  "recall" : str(int(metrics['recall'] or 0)) ,  "precision" : str(int(metrics['precision'] or 0)) }
				conciseString += testpluginname + ' - ' + report['name'] + ': ' + str(round(metrics['accuracy'], 2)) + '%' + '\n'
				print (outstring)

			outstring += '  \n'
		outstring += '<br><br>\n'

	outjson["data"] = outjsondata
	

	report_file_html = outfolder + "/report.html"
	text_file = open(report_file_html, "w")
	html = markdown2.markdown(outstring, extras=["break-on-newline", "tables"])
	write_html = '<style>body { padding:30px; width:960px; font-family: "Lucida Console", Monaco, monospace; font-size: 12px; } table { font-size: 12px;  }  hr.fat {border: 10px solid #0099ff;border-radius: 5px;} </style><br><h1>Anyline LISA Tests</h1><hr class="fat">' + html
	n = text_file.write(write_html)
	text_file.close()

	outstring = outstring.replace('<br>', '')
	report_file_md = outfolder + "/report.md"
	text_file = open(report_file_md, "w")
	n = text_file.write(outstring)
	text_file.close()
	print (outstring)


	report_file_md = outfolder + "/report.txt"
	text_file = open(report_file_md, "w")
	n = text_file.write(conciseString)
	text_file.close()
	print (conciseString)

	report_file_json = outfolder + "/report.json"
	json_string = json.dumps(outjson, indent=4, ensure_ascii=True)
	json_file = open(report_file_json, "w")
	n = json_file.write(json_string)
	json_file.close()


	return report_file_html


def loadYaml(file):	
	try:
		with open(file, 'r') as stream:
			data = stream.read()
			yamlData = yaml.safe_load(data)
			print ("loaded yaml file", yamlData)
			return yamlData
		print ("done")
	except yaml.YAMLError as e:
		print ("Yaml error loading file. Trying replacing tabs")

	try:
		with open(file, 'r') as stream:
			data = stream.read().replace('\t', '    ')
			yamlData = yaml.safe_load(data)
			print ("loaded yaml file", yamlData)
			return yamlData
		print ("done")
	except yaml.YAMLError as e:
		print ("Yaml error loading file.")


	raise Exception('Error loading YAML file {}'.str(file)) 
	return "Error loading YAML file"

	raise Exception('Error opening file {}'.str(file))

def runTests():
	testoutfolder = './tests/out/' + timestampStr + '/'
	for filename in glob.glob("tests/tests/*.test"):
		config = loadYaml(filename)
		
		testName = os.path.basename(filename)
		testName = os.path.splitext(testName)[0]
		for item in config:
			for section in item.keys():
				marathon = item[section]['marathon']
				script   = item[section]['script']
				assets   = item[section]['assets']
				jsonname = marathon.replace('/', '_');
				jsonname = jsonname + '.json'

				outfolder = testoutfolder + testName + '/'
				outname = outfolder + jsonname

				subprocess.call(['tests/scripts/run_anylinestudio.sh', script, marathon, assets, outname, args.anylinecli])
			
	return testoutfolder

folder = runTests()
report_file = createReport(folder)

print ("Report written to ", report_file)

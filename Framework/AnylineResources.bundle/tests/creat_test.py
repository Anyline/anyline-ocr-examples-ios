
from subprocess import check_output
import json
import yaml
import argparse 





parser = argparse.ArgumentParser()
parser.add_argument("project", help="Name of the project you want to create", type=str)
parser.add_argument("script", help="Name of the script (e.g 'module_barcode/ean.alc')", type=str)
parser.add_argument("assets", help="Name of the asset path (e.g 'module_barcode/')", type=str)
parser.add_argument("out", help="Name of the file you want to create (e.g 'tests/tests/Barcode.test')", type=str, default='out.test')
args = parser.parse_args()

project=args.project
outScript=args.script
outAssets=args.assets
outFile=args.out


outYaml = []

def listFromCommand(list):
	output = check_output(list)

	output = output.encode('utf-8')
	output = output.split("\n",2)[2];
	output = output.replace('\'','\"')

	j = json.loads(output)
	return j

marathonlist = listFromCommand(['anylinestudio', 'list', project])

for marathon in marathonlist:
	currentPath = project + '/' + marathon
	setlist = listFromCommand(['anylinestudio', 'list', currentPath])	

	for setname in setlist:
		targetSet = project + '/' + marathon + '/' + setname
		setDict = { targetSet.encode('utf-8') : {  'script' : outScript.encode('utf-8'), 'assets' : outAssets.encode('utf-8'), 'marathon' : targetSet.encode('utf-8') }  }
		print ("Fetched "  + targetSet )
		outYaml.append(setDict)



with open(outFile, 'w') as file:
	documents = yaml.dump(outYaml, file, default_flow_style=False, allow_unicode=True)

		
# Script Tests

### General

The tests live in the `tests/tests` folder. The tester searches for                       files with the ending`.test`. The file has to contain tests in the                                                                                         folloing format:

    - Barcode/RSS/RSS-Expanded:    
        assets: module_barcode/
        marathon: Barcode/RSS/RSS-Expanded
        script: module_barcode/ean.alc

    - Barcode/MSI-Plessey/MSI-Plessey:
        assets: module_barcode/
        marathon: Barcode/MSI-Plessey/MSI-Plessey
        script: module_barcode/ean.alc

Please try to use 4 spaces to intend (YAML). The file name is used to identifiy the test.

The header is the name that is displayed. It can be arbitrary but I used the full marathon path.

### Running Tests

Run all tests by entering:

    sh tests/runtests.sh path/to/cli
    
Example:

	sh tests/runtests.sh ../AnylineCore/prebuild//macos/cli/build/out/anycli
    

### Creating new Tests

I added a convenience script to add new tests. 

    python tests/creat_test.py projectNameOnLisa script/Path assets/Path out.test
    
The paths have to be relative to the root folder.

Example:

    python tests/creat_test.py Barcode module_barcode/ean.alc module_barcode/ tests/tests/Barcode.test


### Test output

Every test output is timestamped. It lives in the `out` folder and the folder of its timestamp:

    ./tests/out/2020-10-03-09-19-37/

A test creates the following files inside the timestamp fodler:

    2020-10-03-09-19-37/report.html   The report in HTML (human readable)
    2020-10-03-09-19-37/report.json   The report as JSON
    2020-10-03-09-19-37/report.md     The report in markdown to post to confluence
    2020-10-03-09-19-37/report.txt    The report as short and simple text

It also creates a folder for every test and a json file for every sprint: 
    
	e.g. 2020-10-03-09-19-37/Barcode/Barcode_EAN_EAN-8.json
	

### Compare tests

Tere is a tool to compare tests: `tests/compare.py`
    
    python3 tests/compare.py oldTestFolder newtestFolder output.html

Example 

    python3 tests/compare.py tests/out/2020-10-03-09-19-37/ tests/out/2020-10-23-10-19-37/ comparison.html

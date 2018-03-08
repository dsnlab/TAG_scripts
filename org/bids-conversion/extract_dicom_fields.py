import argparse

parser = argparse.ArgumentParser()
parser.add_argument('input', help='directory of dicom files to search (recursive)')
parser.add_argument('output', help='name of output file')
parser.add_argument('fields', help='fields to search', nargs='+')
parser.add_argument('-a', '--all', help='Search all files every subdirectory (default: search one file per subdirectory)' , action = 'store_true')
parser.add_argument('-n', '--nodir', help="Don't print the directories that were searched", action = 'store_true')

dicomdir = parser.parse_args().input
outputfile = parser.parse_args().output
fields = parser.parse_args().fields
searchall = parser.parse_args().all
nodir = parser.parse_args().nodir

import glob, os, subprocess, re

dicom_pattern = re.compile('\[(.*)\]')

def dicom_field(filename, key):
	try:
		val = subprocess.check_output(['dcmdump', '+P', key, filename]).decode('utf-8')
	except subprocess.CalledProcessError:
		val = ''
	return val

def dicom_string(filename, key):
	match = re.search(dicom_pattern, dicom_field(filename,key))
	val = match.group(1) if (match) else None
	return val


#is_dicom = lambda x: 'yes:' in subprocess.check_output(['dcmftest', x]).decode('utf-8')

def is_dicom(filename):
	try:
		val = subprocess.check_output(['dcmftest', filename]).decode('utf-8')
	except:
		val = ''
	return 'yes:' in val

dirs_with_files = []
for m in glob.glob(dicomdir):
	dirs_with_files += [x for x in os.walk(dicomdir) if x[2]]

file_list = []
for x in dirs_with_files:
	if (searchall):
		matched_files = [os.path.join(x[0], f) for f in x[2] if is_dicom(os.path.join(x[0], f))]
		file_list.extend(matched_files)
	else:
		matched_file = next((os.path.join(x[0], f) for f in x[2] if is_dicom(os.path.join(x[0], f))), None)
		if (matched_file): file_list.append(matched_file)



values = set()
for file in file_list:
	if(nodir):
		values.add(tuple([dicom_string(file, x) for x in fields]))
	else:
		values.add(tuple([os.path.dirname(file)] + [dicom_string(file, x) for x in fields]))

import csv
with open(outputfile, 'w') as csvfile:
	csvwriter = csv.writer(csvfile)
	if (nodir):
		csvwriter.writerow(fields)
	else:
		csvwriter.writerow(['Directory'] + fields)
	for row in values:
		csvwriter.writerow(row)







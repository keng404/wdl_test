#!/usr/bin/python3
import argparse
import os
import json
import subprocess

def execute_command(cmd):
    process = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    return process.communicate()

def update_input_json(jsonfile ,bamfile):
	if os.path.exists(jsonfile):
		with open(jsonfile) as f:
  			input_data = json.load(f)
	else:
		raise ValueError('Please define a valid JSON template to read from.')
	if bamfile is not None:
		input_data['bam_to_fastqs.bam'] = bamfile
		with open(jsonfile, "w") as outfile:  
			json.dump(input_data, outfile)
	else:
		raise ValueError('Please define a BAM file.')

def update_output_json(jsonfile ,output_directory):
	if os.path.exists(jsonfile):
		with open(jsonfile) as f:
  			output_data = json.load(f)
	else:
		raise ValueError('Please define a valid JSON template to read from.')
	if output_directory is not None:
		output_data['final_workflow_outputs_dir'] = output_directory
		output_data['final_workflow_log_dir'] = output_directory
		output_data['final_call_logs_dir'] = output_directory
		with open(jsonfile, "w") as outfile:  
			json.dump(output_data, outfile)
	else:
		raise ValueError('Please define a BAM file.')
def run_wdl(wdl,input_json,output_json):
	full_cmd = ['/opt/java/openjdk/bin/java' ,'-jar' ,'/app/cromwell.jar','run',wdl,'--inputs',input_json,'--options',output_json]
	full_cmd_str = " ".join(full_cmd)
	print("Running:\t" + full_cmd_str)
	out,err = execute_command(full_cmd)
	error_log = open("error.log","w")
	error_log.writelines("%s " % full_cmd_str)
	error_log.write(err.decode("utf8"))
	error_log.write(out.decode("utf8"))
	error_log.close()

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--bam',type = str)
    parser.add_argument('--output_directory',type = str)
    parser.add_argument('--input_json_template',default='/modified_workflows/bam-to-fastqs-input.json',type =str)
    parser.add_argument('--output_json_template',default='/modified_workflows/output_directory.json',type =str)
    parser.add_argument('--wdl',default='/modified_workflows/bam-to-fastqs.wdl',type =str)
    args, extras = parser.parse_known_args()
    print("Updating JSON:\t" + args.input_json_template + "\t with input BAM: " + args.bam + "\n")
    update_input_json(args.input_json_template,args.bam)
    update_output_json(args.output_json_template,args.output_directory)
    run_wdl(args.wdl,args.input_json_template,args.output_json_template)


if __name__ == '__main__':
    main()
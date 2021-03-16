# wdl_test
A CWL-wrapped WDL workflow
- used WDL workflows from [stjudecloud](https://github.com/stjudecloud/workflows)
- Chose workflow bam-to-fastq.wdl that references a few other wdl recipes
- [Created Docker image](https://github.com/keng404/wdl_test/blob/master/Dockerfile) with all binaries (i.e. samtools, fq, picard) of interest
- Installed Cromwell inside docker container to run WDL workflow
- Created options JSON file [here](https://github.com/keng404/wdl_test/blob/master/output_directory.json)
```bash
# Key parameter in the JSON is:
"use_relative_output_paths": true
```
- Wrapper script that initializes this workflow can be found [here](https://github.com/keng404/wdl_test/blob/master/bam_to_fastq_wdl_wrapper.py)

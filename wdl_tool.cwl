#!/usr/bin/env cwl-runner

# (Re)generated by BlueBee Platform

$namespaces:
  bb: http://bluebee.com/cwl/
  ilmn-tes: http://platform.illumina.com/rdf/iap/
cwlVersion: cwl:v1.0
class: CommandLineTool
bb:toolVersion: '1'
requirements:
- class: InlineJavascriptRequirement
label: cromwell_test_tool
inputs:
  BAM:
    type: File
    inputBinding:
      prefix: --bam
outputs:
  fastqs:
    type:
      type: array
      items: File
    outputBinding:
      glob:
      - '*fastq.gz'
  output directory:
    type:
    - Directory
    - 'null'
    outputBinding:
      glob:
      - $(runtime.outdir)
  log files:
    type:
    - type: array
      items: File
    - 'null'
    outputBinding:
      glob:
      - '*log'
arguments:
- position: 2
  prefix: --output_directory
  valueFrom: $(runtime.outdir)
baseCommand:
- python3
- /opt/bam_to_fastq_wdl_wrapper.py
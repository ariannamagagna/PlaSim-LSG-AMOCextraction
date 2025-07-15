# PlaSim-LSG AMOC Extraction

This repository contains a shell script that can be used to  
- extract diagnostic files from `.tar` archives
- extract yearly amoc values from the latter  

# AMOC Extraction from PlaSim-LSG Diagnostic Output

This Bash script automates the extraction of Atlantic Meridional Overturning Circulation (AMOC) values from diagnostic `.tar` archives produced by the PLASIM-LSG climate model. It loops over multiple blocks and trajectories, computes ensemble averages, and saves yearly means for further analysis.

## Usage

```bash
./amocextraction.sh <base_path> <base_name> <block_start> <block_end> <traj_number>
```

The input the user should give are the following:  
`<base_path>`:	Absolute path to the experiment directory (e.g., /home/user/work/PLASIM-LD3/EXPERIMENT)  
`<base_name>`:	Base name of the diagnostic run (e.g., EXPERIMENT_NAME)  
`<block_start>`:	Starting block number (zero-padded, e.g., 0120)  
`<block_end>`:	Ending block number (zero-padded, e.g., 0250)  
`<traj_number>`:	Number of trajectories per block (e.g., 0100)  

## Directory structure 

The script expects the following structure for your PLASIM-LSG output:  
```text
<base_path>/
└── diag/
    ├── <base_name>_diag_block_0001.tar
    ├── <base_name>_diag_block_0002.tar
    └── ...
```

Each .tar archive should contain trajectory files named like:  
<base_name>_diag.0001.0120
<base_name>_diag.0002.0120
...

After processing, the script generates:  

Block-level mean AMOC values in amoc_yearmean_<BLOCK>.txt  

A final ensemble mean file: amoc_ensemble_yearmean.txt  

## What the Script Does  

- Extracts `.tar` files from specified blocks.

- Loops over N trajectories per block.

- Searches for "ATL max" values in each trajectory file.

- Averages the values per trajectory, then per block.

- Outputs the block-wise means and final ensemble average.

The final result is written to:

```bash
<base_path>/diag/amoc_ensemble_yearmean.txt
```

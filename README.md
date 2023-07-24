# Immuannot pipeline introduction

Immuannot is a pipeline building on [minimap2](https://github.com/lh3/minimap2) 
to detect and annotate immunological genes for human genome assembly. 
By taking advantage of gene sequences from 
[IPD-IMGT/HLA](https://www.ebi.ac.uk/ipd/imgt/hla/),
[IPD-KIR](https://www.ebi.ac.uk/ipd/kir/), and
[National library of medicine](https://www.ncbi.nlm.nih.gov/gene/720),
it is able to annotate HLA and KIR alleles at full precision (if exist in the
reference data set) and to report novel alleles by locating new mutations that do not
exist in the references.

Last update date : 07/24/2023

Content
--------

- [Detection Strategy](#detection-strategy)
- [Gene coverage](#gene-coverage)
- [Installation](#installation)
    - [Requirement](#requirement)
    - [Download](#download)
- [Inputs and Outputs](#inputs-and-outputs)
- [A Running example](#a-running-example)
- [Limitations](#limitations)
- [License](#license)


# Detection Strategy

An HLA gene is detected if any reference sequences of that gene are well mapped to the
target assembly (overlapping rate > 90%). In a region with multiple mapping
allele sequences, the one with the smallest edit-distance and longest matching length 
is chosen as the template, which is used for structure annotation later on.

If the edit-distance of the chosen template is zero, which means a perfect
matchness, the allele is reported and structure is annotated based on the alignment.
If the edit distance of the chosen template is not zero, which means mutation(s) exists, 
gene structure is annotated with the template and then CDS is extracted for 
further allele calling.

<img src=figs/hla-kir.pipeline.png width="550" height="500" />

C4 genes are detected through split alignment. Taking the exons from
one gene sequence as reference, The boundary of each exon, 
the length of the 9th intron, and key pipetides in the 26th exon can 
be determined through the alignment. Those information are used for gene
annotation and gene typing. 

<img src=figs/c4.pipeline.png width="600" height="400" />

Because reference gene sequences are allowed to map to different genome regions,
multiple copies of a particular gene are reported naturally with this pipeline.

See REF for more details.

[\[top\]](#content)

# Gene coverage

## __HLA__ genes: 

HLA-A,HLA-B,HLA-C,HLA-DMA,HLA-DMB,HLA-DOA,HLA-DOB,HLA-DPA1,HLA-DPA2,HLA-DPB1,HLA-DPB2,HLA-DQA1,HLA-DQA2,HLA-DQB1,HLA-DQB2,HLA-DRA,HLA-DRB1,HLA-DRB3,HLA-DRB4,HLA-DRB5,HLA-E,HLA-F,HLA-G,HLA-HFE,HLA-H,HLA-J,HLA-K,HLA-L,HLA-N,HLA-P,HLA-S,HLA-T,HLA-U,HLA-V,HLA-W,HLA-Y, MICA,MICB,TAP1,TAP2,C4A,C4B

## __KIR__ genes: 

KIR2DL1,KIR2DL2,KIR2DL3,KIR2DL4,KIR2DL5A,KIR2DL5B,KIR2DP1,KIR2DS1,KIR2DS2,KIR2DS3,KIR2DS4,KIR2DS5,KIR3DL1,KIR3DL2,KIR3DL3,KIR3DP1,KIR3DS1

[\[top\]](#content)

# Installation

## Requirement

This pipeline is developped and desgined under linux environment, following
programs are required to be pre-intalled:

* minimap2 (test version 2.17-r941)
* python3 (test version 3.9.13)
* bash (test version 4.4.20)

## Download

```bash
git clone https://github.com/YingZhou001/Immuannot.git
cd Immuannot
tar xvf refData-2023Jun05.tgz

```

Testing :

```bash
>> bash scripts/immuannot.sh
Error: target contig seq is required.

  Usage: bash immuannot.sh [ -c | --contig  target assembly (.fa, .fa.gz)       ]
                           [ -r | --refdir  references                          ]
                           [ -o | --outpref output prefix                       ]
                           [ -t | --thread  num of thread (optional, default 3) ]
                           [ --overlaprate  OVERLAP (optional, default 0.9)     ]
                           [ --diff         DIFF (optional, default 0.03)       ]
```


[\[top\]](#content)

# Inputs and Outputs

Immuannot takes genome assembly (-c/--contig, supporting format) and gene reference
sequences data directory (-r/--refdir along this software) as inputs. 
It is better to set your own output prefix, otherwise all the results will be
prefixed with "immuannot-out".

Optically, the number of threads ( -t/--thread), 
the proportion of the query sequence mapped to the target (--overlaprate),
and the difference ratio cutoff of the matched region (--diff) 
can all be customized as need.

The output annotation is in gzip-compressed [gtf](https://useast.ensembl.org/info/website/upload/gff.html) format.

In the attribute column, new allele would have a 'new' tag at the rightest field 
of the 'consensus' call, it is usually accompanied with one or more similar 'alleles' call 
from the reference data set 
CDS sequence is also examined during the template search, typically, 
'template\_warning' would give warnings as "no-start\_codon", "no-stop\_codon", 
"incomplete\_CDS", and "inframe\_stop" for the gene structure annotation.

Intermediate results are also saved in the output folder.

[\[top\]](#content)

# A Running example

An running example is included along this pipeline. 
The target file 'test.fa.gz' include two contigs, one for HLA region 
and the other for KIR region.

User can test the pipeline by running the script bellow :

```bash
## check the file path before running
ctg=example/test.fa.gz
script=scripts/immuannot.sh
refdir=refData-2023Jun05
outpref=test-run
bash ${script} -c ${ctg} -r ${refdir} -o ${outpref}
```

Immuannot would output file "test-run.gtf.gz" for annotation and a folder named
"test-run" for intermediate results.

[\[top\]](#content)

# Limitations

Because Immuannot is mainly based on gene sequence alignment, a novel gene may not be reported if it is largely different from the reference data sequences.
For example, in our analysis, we
found a DRB3 gene that had a ~6kb deletion in the first intron, which was not
found in the IPD-IMGT/HLA data set, which results in the DRB3 gene was detected.

[\[top\]](#content)

# License

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see https://www.gnu.org/licenses/.

[\[top\]](#content)

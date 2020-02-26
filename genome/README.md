# Drosophila Melanogaster genome

We downloaded the Drosophila Melanogaster BDGP6(Ensembl release 95) genome from [Ensembl](https://sep2019.archive.ensembl.org/Drosophila_melanogaster/Info/Index).

You can directly download the genome by clicking [here](https://ftp.ensembl.org/pub/release-98/fasta/drosophila_melanogaster/dna/Drosophila_melanogaster.BDGP6.22.dna.toplevel.fa.gz)

We rename the chromosome names to be consistent by adding `chr` at the start using the commands below
```
sed -i 's/mitochondrion_genome/M/' Drosophila_melanogaster.BDGP6.dna.toplevel.fa
sed -i 's/>/>chr/' Drosophila_melanogaster.BDGP6.dna.toplevel.fa
```

The genome we used for the subsequent analysis is the one renamed as `Drosophila_melanogaster.BDGP6.dna.toplevel.fa.gz`

The blacklist file was downloaded from [Boyle-Lab](https://github.com/Boyle-Lab/Blacklist/blob/master/lists/dm6-blacklist.v2.bed.gz).

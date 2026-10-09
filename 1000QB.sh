#!/bin/sh

head -c 1G /dev/zero | bzip2 -9 >a.bz2

for i in $(seq 1000); do cat a.bz2; done | xz -9e >L1.xz

n=8
f=L1.xz
for i in $(seq 2 $n); do
  for j in $(seq 1000); do cat $f; done | xz -9e >L$i.xz
  f=L$i.xz
done


## Create 1000 Quettabyte zip bomb
 
A quettabyte (QB) is the largest SI decimal unit currently defined (10^30 bytes). 
This script generates a file that represents 1000 QB using nested bzip2 and xz compression.

## How it works

First, the script creates `a.bz2`, a bzip2-compressed file representing 1 GB of zeros read from `/dev/zero`:

```
head -c 1G /dev/zero | bzip2 -9 > a.bz2
```

Because the input is all zeros, the compressed file shrinks to about 785 bytes.

Next, the script concatenates 1000 copies of `a.bz2` with `cat` and compresses the result with `xz` to produce `L1.xz`:

```
for i in $(seq 1000); do cat a.bz2; done | xz -9e > L1.xz
```

This process is repeated.  Each `Ln.xz` is built by concatenating 1000 copies of `L(n-1).xz` and recompressing with `xz` to produce `L2.xz` through `L8.xz`. 
Each level represents the previous one's uncompressed size multiplied by 1000.

The final file, `L8.xz`, is only about 2516 bytes on disk but logically represents 1000 QB (10^33 bytes) of data.

## Size table

| File    | Represents (decimal) | Actual size |
|---------|----------------------|-------------|
| a.bz2   | 1 GB  = 10^9 B        | 785 B       |
| L1.xz   | 1 TB  = 10^12 B       | 336 B       |
| L2.xz   | 1 PB  = 10^15 B       | 532 B       |
| L3.xz   | 1 EB  = 10^18 B       | 764 B       |
| L4.xz   | 1 ZB  = 10^21 B       | 1024 B      |
| L5.xz   | 1 YB  = 10^24 B       | 1328 B      |
| L6.xz   | 1 RB  = 10^27 B       | 1680 B      |
| L7.xz   | 1 QB  = 10^30 B       | 2080 B      |
| L8.xz   | 1000 QB = 10^33 B     | 2516 B      |


## How to extract

```
xz -dc L8.xz |xz -dc| xz -dc | xz -dc | xz -dc | xz -dc | xz -dc | xz -dc | bzip2 -dc > out.txt
```
or 

```
f=L8.xz; cp $f t; while file t | grep -q 'XZ'; do xz -dc t > u; mv u t; done; bzip2 -dc t > out.txt
```

# charm-high-pnp-tools
Charm High Desktop Pick and Place tools

## convert dpv file to svg to verify it

Idea is to verify that component orientation 
on CHMT48VB which has multiple feeder locations

Use as filter:

```shell
./dpv2svg.pl 20201201-165052-ulx3s-top.dpv    > top.svg
./dpv2svg.pl 20201201-165052-ulx3s-bottom.dpv > bottom.svg
````

It's recommeded to open svg files in browser since components
and feeders have title which is visible on hover.

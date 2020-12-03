# charm-high-pnp-tools
Charm High Desktop Pick and Place tools

## convert dpv file to svg to verify it

Use as filter:

```shell
./dpv2svg.pl 20201201-165052-ulx3s-top.dpv 2>err.top >top.svg
./dpv2svg.pl 20201201-165052-ulx3s-bottom.dpv 2>err.bottom >bottom.svg
````

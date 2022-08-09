## What

A small program to print today's menu from your chosen Unicafe restaurant.

I give absolutely no guarantees on how well the program runs.

## Why

I was bored and wanted to learn Racket.

## Installation

### Preferred method

Before running, install Racket from your operating system's preferred source.

Copy `unicafe.rkt` to your preferred location.

### Alternative method

You can download a release and run that directly, without Racket installed. This executable is quite a bit larger in size (~11M), as it probably bundles much of Racket with it. The executable has been created with `raco exe`.

## Usage

Run `unicafe.rkt exactum` to get the menu for Exactum's Unicafe.

For a list of valid cafe names, run `unicafe.rkt --help`.

Example output:

```
$ unicafe.rkt exactum chemicum

Exactum
-------
No food :(

Chemicum
--------
Vegaani
Kikherne-pähkinäpataa

Päivän lounas
Uunihalloumipasta

Päivän lounas
Rapea kalaleike, ruohosipulikermaviiliä

Makeasti
Vadelmamoussea ja rapeaa granolaa
```

# MiniOxygen

## Description

MiniOxygen is a automatic documentation generator (mostly) compatible with the DOxygen/Javadoc
notation.   
It outputs to Markdown format on stdout.

It is quite basic and can be used with almost any language.

## Usage

Basic command line is:

    # minioxygen [--lang|-l language] file(s)...

Language can be any language (basic mode) or 'c' (improved mode).

As an example, MiniOxygen will parse itself with the command:

    # minioxygen MiniOxygen/*.pm

Any file containing a @file tag will be parsed and its documentation will be generated.

## Supported DOxygen tags

  * brief
  * file
  * function
    * param
    * return
  * def
  * enum
  * struct (pending)

**Auto-generated documentation for MiniOxygen starts after this line**

---


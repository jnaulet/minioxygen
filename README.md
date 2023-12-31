# MiniOxygen

## Description

MiniOxygen is a automatic documentation generator (mostly) compatible with the DOxygen/Javadoc
notation written in Perl.   
It outputs to Markdown format on stdout.

It is quite basic and can be used with almost any language.

## Dependencies

This tool is modern Perl, which means it requires a few modules to be present on your system, like
libcarp-assert-perl for example.

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

## File/objects

  * [MiniOxygen::Markdown](#minioxygenmarkdown)
  * [MiniOxygen::Render](#minioxygenrender)
  * [MiniOxygen::Source](#minioxygensource)
  * [MiniOxygen::Token](#minioxygentoken)
  * [MiniOxygen::Input](#minioxygeninput)

---

## MiniOxygen::Markdown

**Markdown module for MiniOxygen**

### Definitions


Back to 
[File/objects](#fileobjects)

### Data types


Back to 
[File/objects](#fileobjects)

### Data structures


Back to 
[File/objects](#fileobjects)

### Functions

  * [MiniOxygen::Markdown::header](#minioxygenmarkdownheader)
  * [MiniOxygen::Markdown::line](#minioxygenmarkdownline)
  * [MiniOxygen::Markdown::normal](#minioxygenmarkdownnormal)
  * [MiniOxygen::Markdown::bold](#minioxygenmarkdownbold)
  * [MiniOxygen::Markdown::bullet](#minioxygenmarkdownbullet)
  * [MiniOxygen::Markdown::create_link](#minioxygenmarkdowncreate_link)
  * [MiniOxygen::Markdown::newline](#minioxygenmarkdownnewline)
  * [MiniOxygen::Markdown::inline_code](#minioxygenmarkdowninline_code)
  * [MiniOxygen::Markdown::blockquote](#minioxygenmarkdownblockquote)
  * [MiniOxygen::Markdown::code_block](#minioxygenmarkdowncode_block)

Back to 
[File/objects](#fileobjects)

---

## MiniOxygen::Markdown::header

**Outputs a level n header**

### Prototype

        MiniOxygen::Markdown::header ( level, str )

### Parameters

        level : the heading level (1-n)
        str : the heading content/text

Back to 
[MiniOxygen::Markdown](#minioxygenmarkdown)

## MiniOxygen::Markdown::line

**Outputs a line**

### Prototype

        MiniOxygen::Markdown::line (  )

Back to 
[MiniOxygen::Markdown](#minioxygenmarkdown)

## MiniOxygen::Markdown::normal

**Outputs normal text**

### Prototype

        MiniOxygen::Markdown::normal ( str )

### Parameters

        str : the text

Back to 
[MiniOxygen::Markdown](#minioxygenmarkdown)

## MiniOxygen::Markdown::bold

**Outputs bold text**

### Prototype

        MiniOxygen::Markdown::bold ( str )

### Parameters

        str : the text

Back to 
[MiniOxygen::Markdown](#minioxygenmarkdown)

## MiniOxygen::Markdown::bullet

**Outputs a bullet point**

### Prototype

        MiniOxygen::Markdown::bullet (  )

Back to 
[MiniOxygen::Markdown](#minioxygenmarkdown)

## MiniOxygen::Markdown::create_link

**Outputs a link**

### Prototype

        MiniOxygen::Markdown::create_link ( str )

### Parameters

        str : the text of the link

Back to 
[MiniOxygen::Markdown](#minioxygenmarkdown)

## MiniOxygen::Markdown::newline

**Outputs a new line**

### Prototype

        MiniOxygen::Markdown::newline (  )

Back to 
[MiniOxygen::Markdown](#minioxygenmarkdown)

## MiniOxygen::Markdown::inline_code

**Outputs inlined code**

### Prototype

        MiniOxygen::Markdown::inline_code ( str )

### Parameters

        str : the inlined code string

Back to 
[MiniOxygen::Markdown](#minioxygenmarkdown)

## MiniOxygen::Markdown::blockquote

**Outputs a blockquote (> )**

### Prototype

        MiniOxygen::Markdown::blockquote ( str )

### Parameters

        str : the code to quote

Back to 
[MiniOxygen::Markdown](#minioxygenmarkdown)

## MiniOxygen::Markdown::code_block

**Outputs a block of code**

### Prototype

        MiniOxygen::Markdown::code_block ( str )

### Parameters

        str : the block of code

Back to 
[MiniOxygen::Markdown](#minioxygenmarkdown)

## MiniOxygen::Render

**Markdown rendering module for MiniOxygen**

### Definitions


Back to 
[File/objects](#fileobjects)

### Data types


Back to 
[File/objects](#fileobjects)

### Data structures


Back to 
[File/objects](#fileobjects)

### Functions

  * [MiniOxygen::Render::list_files](#minioxygenrenderlist_files)
  * [MiniOxygen::Render::list_defs](#minioxygenrenderlist_defs)
  * [MiniOxygen::Render::def](#minioxygenrenderdef)
  * [MiniOxygen::Render::list_enums](#minioxygenrenderlist_enums)
  * [MiniOxygen::Render::enum](#minioxygenrenderenum)
  * [MiniOxygen::Render::list_functions](#minioxygenrenderlist_functions)
  * [MiniOxygen::Render::function](#minioxygenrenderfunction)
  * [MiniOxygen::Render::list_structs](#minioxygenrenderlist_structs)
  * [MiniOxygen::Render::struct](#minioxygenrenderstruct)

Back to 
[File/objects](#fileobjects)

---

## MiniOxygen::Render::list_files

**Renders a bullet list of files contained in hash**

### Prototype

        MiniOxygen::Render::list_files ( hash )

### Parameters

        hash : the db/hash containing all the javadoc information

Back to 
[MiniOxygen::Render](#minioxygenrender)

## MiniOxygen::Render::list_defs

**Renders a bullet list of defs/macros**

### Prototype

        MiniOxygen::Render::list_defs ( array )

### Parameters

        array : an array of MiniOxygen::Token objects

Back to 
[MiniOxygen::Render](#minioxygenrender)

## MiniOxygen::Render::def

**Renders a def with details**

### Prototype

        MiniOxygen::Render::def ( token, parent )

### Parameters

        token : a def token
        parent : the parent object name/link

Back to 
[MiniOxygen::Render](#minioxygenrender)

## MiniOxygen::Render::list_enums

**Renders a bullet list of enums**

### Prototype

        MiniOxygen::Render::list_enums ( array )

### Parameters

        array : an array of MiniOxygen::Token objects

Back to 
[MiniOxygen::Render](#minioxygenrender)

## MiniOxygen::Render::enum

**Renders an enum with details**

### Prototype

        MiniOxygen::Render::enum ( token, parent )

### Parameters

        token : an enum token
        parent : the parent object name/link

Back to 
[MiniOxygen::Render](#minioxygenrender)

## MiniOxygen::Render::list_functions

**Renders a bullet list of functions**

### Prototype

        MiniOxygen::Render::list_functions ( array )

### Parameters

        array : an array of MiniOxygen::Token objects

Back to 
[MiniOxygen::Render](#minioxygenrender)

## MiniOxygen::Render::function

**Renders a function with details**

### Prototype

        MiniOxygen::Render::function ( token, parent )

### Parameters

        token : a function token
        parent : the parent object name/link

Back to 
[MiniOxygen::Render](#minioxygenrender)

## MiniOxygen::Render::list_structs

**Renders a bullet list of data structures**

### Prototype

        MiniOxygen::Render::list_structs ( array )

### Parameters

        array : an array of MiniOxygen::Token objects

Back to 
[MiniOxygen::Render](#minioxygenrender)

## MiniOxygen::Render::struct

**Renders a struct with details**

### Prototype

        MiniOxygen::Render::struct ( token, parent )

### Parameters

        token : a struct token
        parent : the parent object name/link

Back to 
[MiniOxygen::Render](#minioxygenrender)

## MiniOxygen::Source

**Main source code parsing module for MiniOxygen**

### Definitions


Back to 
[File/objects](#fileobjects)

### Data types


Back to 
[File/objects](#fileobjects)

### Data structures


Back to 
[File/objects](#fileobjects)

### Functions

  * [MiniOxygen::Source::new](#minioxygensourcenew)
  * [MiniOxygen::Source::next_token](#minioxygensourcenext_token)

Back to 
[File/objects](#fileobjects)

---

## MiniOxygen::Source::new

**Creates a new MiniOxygen::Source object**

### Prototype

        MiniOxygen::Source::new ( path, lang )

### Parameters

        path : the path to the source file to open/parse
        lang : the language of the source file (c, perl, ...)

### Returns

        a MiniOxygen::Source object

Back to 
[MiniOxygen::Source](#minioxygensource)

## MiniOxygen::Source::next_token

**Gets the next MiniOxygen token from file**

### Prototype

        MiniOxygen::Source::next_token (  )

### Returns

        a MiniOxygen::Token object

Back to 
[MiniOxygen::Source](#minioxygensource)

## MiniOxygen::Token

**This is the main token management module**

### Definitions


Back to 
[File/objects](#fileobjects)

### Data types


Back to 
[File/objects](#fileobjects)

### Data structures


Back to 
[File/objects](#fileobjects)

### Functions

  * [MiniOxygen::Token::new](#minioxygentokennew)
  * [MiniOxygen::Token::append_text](#minioxygentokenappend_text)
  * [MiniOxygen::Token::add_keyword](#minioxygentokenadd_keyword)
  * [MiniOxygen::Token::c_enum](#minioxygentokenc_enum)
  * [MiniOxygen::Token::c_function](#minioxygentokenc_function)
  * [MiniOxygen::Token::c_struct](#minioxygentokenc_struct)

Back to 
[File/objects](#fileobjects)

---

## MiniOxygen::Token::new

**Creates a new MiniOxygen::Token object**

### Prototype

        MiniOxygen::Token::new (  )

### Returns

        MiniOxygen::Token A Token object

Back to 
[MiniOxygen::Token](#minioxygentoken)

## MiniOxygen::Token::append_text

**Appends some text to the token description**

### Prototype

        MiniOxygen::Token::append_text ( text )

### Parameters

        text : text to append to the token description

Back to 
[MiniOxygen::Token](#minioxygentoken)

## MiniOxygen::Token::add_keyword

**Adds a pair keyword/value to the token**

### Prototype

        MiniOxygen::Token::add_keyword ( keyword, value )

### Parameters

        keyword : the keyword to add to this token
        value : the keyword associated value / string

Back to 
[MiniOxygen::Token](#minioxygentoken)

## MiniOxygen::Token::c_enum

**Interprets a c enumeration**

### Prototype

        MiniOxygen::Token::c_enum ( array )

### Parameters

        array : containing the enum intenrals (and more)

Back to 
[MiniOxygen::Token](#minioxygentoken)

## MiniOxygen::Token::c_function

**Interprets a c function prototype**

### Prototype

        MiniOxygen::Token::c_function ( lines )

### Parameters

        lines : an array containing the prototype's lines of code

Back to 
[MiniOxygen::Token](#minioxygentoken)

## MiniOxygen::Token::c_struct

**Inteprets a c structure**

### Prototype

        MiniOxygen::Token::c_struct ( array )

### Parameters

        array : array containtning the structure internals

Back to 
[MiniOxygen::Token](#minioxygentoken)

## MiniOxygen::Input

**Input module for MiniOxygen**

### Definitions


Back to 
[File/objects](#fileobjects)

### Data types


Back to 
[File/objects](#fileobjects)

### Data structures


Back to 
[File/objects](#fileobjects)

### Functions

  * [MiniOxygen::Input::file_to_array](#minioxygeninputfile_to_array)
  * [MiniOxygen::Input::file_to_str](#minioxygeninputfile_to_str)

Back to 
[File/objects](#fileobjects)

---

## MiniOxygen::Input::file_to_array

**Reads a text file and stores each line in an array**

### Prototype

        MiniOxygen::Input::file_to_array ( path )

### Parameters

        path : the path to the file

### Returns

        array an array containing one line per entry

Back to 
[MiniOxygen::Input](#minioxygeninput)

## MiniOxygen::Input::file_to_str

**Reads a text file and stores each line in an single line**

### Prototype

        MiniOxygen::Input::file_to_str ( path )

### Parameters

        path : the path to the file

### Returns

        string a string containing the whole text file

Back to 
[MiniOxygen::Input](#minioxygeninput)


#!/usr/bin/env perl

# /*!
# @file MiniOxygen::Markdown
# @brief Markdown module for MiniOxygen
# */
use strict;
use warnings;

use FindBin 1.51 qw( $RealBin );
use lib $RealBin;

package MiniOxygen::Markdown;

use feature qw(say);

# Version (required by perlcritic --brutal)
our $VERSION = '0.1a';

sub _section_name {
    my ($str) = @_;

    $str =~ s/[\/:]//sxmg;
    $str =~ s/[\W]+/-/sxmg;

    return q{#} . lc $str;
}

# /*!
# @function MiniOxygen::Markdown::header
# @brief Outputs a level n header
# @param level the heading level (1-n)
# @param str the heading content/text
# */
sub header {
    my ( $level, $str ) = @_;

    for ( 0 .. $level - 1 ) {
        if ( !defined print q{#} ) { return; }
    }

    return say q{ } . $str . qq{\n};
}

# /*!
# @function MiniOxygen::Markdown::line
# @brief Outputs a line
# */
sub line {
    return say '---' . qq{\n};
}

# /*!
# @function MiniOxygen::Markdown::normal
# @brief Outputs normal text
# @param str the text
# */
sub normal {
    my ($str) = @_;
    return say $str;
}

# /*!
# @function MiniOxygen::Markdown::bold
# @brief Outputs bold text
# @param str the text
# */
sub bold {
    my ($str) = @_;
    return say qw{**} . $str . qw{**};
}

# /*!
# @function MiniOxygen::Markdown::bullet
# @brief Outputs a bullet point
# */
sub bullet {
    return print '  * ';
}

# /*!
# @function MiniOxygen::Markdown::create_link
# @brief Outputs a link
# @param str the text of the link
# */
sub create_link {
    my ($str) = @_;
    return say q{[} . $str . q{](} . _section_name($str) . q{)};
}

# /*!
# @function MiniOxygen::Markdown::newline
# @brief Outputs a new line
# */
sub newline {
    return print qq{\n};
}

# /*!
# @function MiniOxygen::Markdown::inline_code
# @brief Outputs inlined code
# @param str the inlined code string
# */
sub inline_code {
    my ($str) = @_;
    return say q{`} . $str . q{`};
}

# /*!
# @function MiniOxygen::Markdown::blockquote
# @brief Outputs a blockquote (> )
# @param str the code to quote
# */
sub blockquote {
    my ($str) = @_;
    return say '> ' . $str;
}

# /*!
# @function MiniOxygen::Markdown::code_block
# @brief Outputs a block of code
# @param str the block of code
# */
sub code_block {
    my ($str) = @_;
    return say q{    } . $str;
}

1;

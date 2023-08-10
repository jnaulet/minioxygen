#!/usr/bin/env perl

# /*!
# @file MiniOxygen::Token
# @brief This is the main token management module
# */
use strict;
use warnings;

use FindBin 1.51 qw( $RealBin );
use lib $RealBin;

package MiniOxygen::Token;

use Readonly;

# Version (required by perlcritic --brutal)
our $VERSION = '0.1a';

# /*!
# @function MiniOxygen::Token::new
# @brief Creates a new MiniOxygen::Token object
# @return MiniOxygen::Token A Token object
# */
sub new {
    my $class = shift;
    my $self  = {};

    bless $self, $class;
    return $self;
}

# /*!
# @function MiniOxygen::Token::append_text
# @brief Appends some text to the token description
# @param text text to append to the token description
# */
sub append_text {
    my ( $self, $text ) = @_;

    # filter out undef text
    if ( !defined $text ) { return; }

    if ( defined $self->{text} ) {
        $self->{text} .= qw{ } . $text;
    }
    else {
        $self->{text} = $text;
    }

    return;
}

# /*!
# @function MiniOxygen::Token::add_keyword
# @brief Adds a pair keyword/value to the token
# @param keyword the keyword to add to this token
# @param value the keyword associated value / string
# */
sub add_keyword {
    my ( $self, $keyword, $value ) = @_;

    if ( $keyword eq 'param' ) {
        my ( $param, $desc ) = $value =~ m/(\w+)\s+([^\n]*)$/sxm;
        push @{ $self->{param} },      $param;
        push @{ $self->{param_desc} }, $desc;
        return;
    }

    # types
    if (   $keyword eq 'enum'
        || $keyword eq 'file'
        || $keyword eq 'function'
        || $keyword eq 'struct' )
    {
        # define type
        $self->{type} = $keyword;
    }

    # specifics
    if ( $keyword eq 'function' ) {
        $self->{param}       = [];
        $self->{return_type} = undef;
    }

    # default
    $self->{$keyword} = $value;
    return;
}

# /!*
# @function MiniOxygen::Token::c_function
# @brief Interprets a c function prototype
# @param str A string containing the prototype
# */
sub c_function {
    my ( $self, $str ) = @_;
    my ( $type, $name, $param ) = $str =~ m/(\w+)\s+(\w+)[\s(]*([^)]*)/sxm;

    $self->{function}    = $name;
    $self->{return_type} = $type;

    # params
    my @params = split /,/sxm, $param;

    for my $p (@params) {
        $name = $p =~ m/(\w+)$/sxm;
        $type = substr $p, 0, -length $name;
        $type =~ s/^[\s]+//sxm;    # remove leading spaces
        $type =~ s/[\s]+$//sxm;    # remove trailing spaces

        push @{ $self->{param_type} }, $type;
    }
    return;
}

1;

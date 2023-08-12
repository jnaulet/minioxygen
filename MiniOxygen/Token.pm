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
use Data::Dumper;

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
        $self->{text} .= q{ } . $text;
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

# /*!
# @function MiniOxygen::Token::c_def
# @brief Interprets a c macro/constant
# @param array array containing the definitions' lines of code
# */
sub c_def {
}

# /*!
# @function MiniOxygen::Token::c_enum
# @brief Interprets a c enumeration
# @param array containing the enum intenrals (and more)
# */
sub c_enum {
}

sub _c_func {
    my ( $self, $line ) = @_;

    # extract prototype & destroy
    my ( $proto, $args ) = $line =~ m/(\w+)[(]([^)]*)/sxm;
    $line =~ s/\w+[(].*$//sxm;

    # normalize spaces
    $line =~ s/\^s+//sxm;
    $line =~ s/\s+$//sxm;
    $line =~ s/\s+/ /sxm;

    return ( $line, $proto, $args );
}

sub _c_var {
    my ( $self, $line ) = @_;

    my ($name) = $line =~ m/(\w+)[;\n]*$/sxm;
    $line =~ s/\w+[;\n]*$//sxm;

    # normalize spaces
    $line =~ s/^\s+//sxm;
    $line =~ s/\s+$//sxm;
    $line =~ s/\s+/ /sxm;

    return ( $line, $name );
}

# /*!
# @function MiniOxygen::Token::c_function
# @brief Interprets a c function prototype
# @param lines an array containing the prototype's lines of code
# */
sub c_function {
    my ( $self, $lines ) = @_;

    my $line = join q{}, @{$lines};
    my ( $return_type, $function, $args ) = $self->_c_func($line);

    $self->{function}    = $function;
    $self->{return_type} = $return_type;

    # params
    my @params = split /,/sxm, $args;

    for my $p (@params) {
        my ( $type, $name ) = $self->_c_var($p);
        push @{ $self->{param_type} }, $type;
    }
    return;
}

# /*!
# @function MiniOxygen::Token::c_struct
# @brief Inteprets a c structure
# @param array array containtning the structure internals
#
sub c_struct {
}

1;

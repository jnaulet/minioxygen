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

Readonly our $COMMENT_START => '[/][*]';
Readonly our $COMMENT_NEXT  => '[/][*][*!]';
Readonly our $COMMENT_PREV  => '[/][*][*!][<]';
Readonly our $COMMENT_END   => '[*][/]';

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
        my ( $param, $desc ) = $value =~ m/(\S+)\s+([^\n]*)$/sxm;
        push @{ $self->{param} },       $param;
        push @{ $self->{param_brief} }, $desc;
        return;
    }

    # types
    if (   $keyword eq 'def'
        || $keyword eq 'enum'
        || $keyword eq 'file'
        || $keyword eq 'function'
        || $keyword eq 'struct' )
    {
        # define type
        $self->{type} = $keyword;
    }

    # specifics
    if (   $keyword eq 'def'
        || $keyword eq 'function' )
    {
        $self->{param}       = [];
        $self->{return_type} = undef;
    }

    # default
    $self->{$keyword} = $value;
    return;
}

# /*!
# @function MiniOxygen::Token::c_enum
# @brief Interprets a c enumeration
# @param array containing the enum intenrals (and more)
# */
sub c_enum {
    my ( $self, $lines ) = @_;

    my $inline = join q{}, @{$lines};

    # take only the contents
    ($inline) = $inline =~ m/{([^}]+)/sxm;

    $self->{entry}   = [];
    $self->{comment} = [];

    my $count = 0;

    while ( $inline =~ /\S/sxm ) {

        # First word
        my ($word) = $inline =~ m/(\S+)/sxm;
        $inline =~ s/\S+//sxm;

        # Entry, starts with A-Z
        if ( $word =~ /^[[:alpha:]]+\w+/sxm ) {
            push @{ $self->{entry} },   $word;
            push @{ $self->{comment} }, q{};
            $count = $count + 1;
        }

        # Comments, start with /*
        if ( $word =~ /^$COMMENT_START/sxm ) {
            my ($comment) = $inline =~ m/\s*(.+?)$COMMENT_END/sxm;

            # if the comment specifies next or previous entry
            if ( $word =~ /$COMMENT_PREV/sxm ) {
                $self->{comment}[ $count - 1 ] = $comment;
            }
            elsif ( $word =~ /$COMMENT_NEXT/sxm ) {
                $self->{comment}[$count] = $comment;

            }
            else { }    # ignore normal comments

            # consume chars up to */ & loop
            $inline =~ s/.+?$COMMENT_END//sxm;
            next;
        }

        # Consume word
        $inline =~ s/$word//sxm;
    }

    return;
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
# */
sub c_struct {
    my ( $self, $lines ) = @_;

    # this is harder to parse than expected, so let's cheat
    $self->{contents} = $lines;
    return;
}

1;

#!/usr/bin/env perl

# /*!
# @file MiniOxygen::Source
# @brief Main source code parsing module for MiniOxygen
# */
use strict;
use warnings;

use FindBin 1.51 qw( $RealBin );
use lib $RealBin;

package MiniOxygen::Source;

use Readonly;
use MiniOxygen::Input;
use MiniOxygen::Token;

Readonly our $MARK_START => '[/][*][*!]';
Readonly our $MARK_END   => '[*][/]';

Readonly our $STATE_IDLE => 0;
Readonly our $STATE_MARK => 1;
Readonly our $STATE_C    => 2;
Readonly our $STATE_DONE => 3;

# Version (required by perlcritic --brutal)
our $VERSION = '0.1a';

use Data::Dumper;

# /*!
# @function MiniOxygen::Source::new
# @brief Creates a new MiniOxygen::Source object
# @param path the path to the source file to open/parse
# @param lang the language of the source file (c, perl, ...)
# @return a MiniOxygen::Source object
# */
sub new {
    my $class = shift;
    my $self  = {
        path  => shift,
        lang  => shift,
        state => $STATE_IDLE,
        token => undef,         # current token
        lines => [],
        buf   => [],
        level => 0,
    };

    bless $self, $class;

    push @{ $self->{lines} }, MiniOxygen::Input::file_to_array( $self->{path} );
    return $self;
}

sub _next_idle {
    my ( $self, $line ) = @_;

    if ( $line =~ /$MARK_START/sxm ) {
        $self->{token} = MiniOxygen::Token->new();
        $self->{state} = $STATE_MARK;
    }

    return;
}

sub _next_mark {
    my ( $self, $line ) = @_;

    if ( $line =~ /$MARK_END/sxm ) {
        if   ( $self->{lang} eq 'c' ) { $self->{state} = $STATE_C; }
        else                          { $self->{state} = $STATE_DONE; }

        return;
    }

    # keywords
    my ( $keyword, $value ) = $line =~ m/[@\\]([[:alpha:]]+)\s+([^\n]*)$/sxm;

    if ( defined $keyword ) {
        $self->{token}->add_keyword( $keyword, $value );
    }
    else {
        $self->{token}->append_text( $line =~ m/(\w+[^\n]*)$/sxm );
    }

    return;
}

sub _next_c {
    my ( $self, $line ) = @_;

    my $token = $self->{token};

    # enum interpreter
    if ( defined $token->{enum} ) {

        # append line (without \n) until we find ';'
        push @{ $self->{buf} }, $line =~ m/([^\n]*)/sxm;
        if ( $line =~ /;$/sxm ) {
            $token->c_enum( $self->{buf} );
            $self->{buf} = [];
        }
        else {
            # no state change
            return;
        }
    }

    # function interpreter
    if ( defined $token->{function} ) {

        # append line (without \n) until we find '{' or ';'
        push @{ $self->{buf} }, $line =~ m/([^\n]*)/sxm;
        if ( $line =~ /[{;]$/sxm ) {
            $token->c_function( $self->{buf} );
            $self->{buf} = [];
        }
        else {
            # no state change
            return;
        }
    }

    # struct interpreter
    if ( defined $token->{struct} ) {

        # append line (without \n) until we find '}'
        push @{ $self->{buf} }, $line =~ m/([^\n]*)/sxm;
        $self->{level} += $line =~ tr/{//;    # level up
        $self->{level} -= $line =~ tr/}//;    # level down
        if ( $self->{level} == 0 ) {
            $token->c_struct( $self->{buf} );
            $self->{buf} = [];
        }
        else {
            # no state change
            return;
        }
    }

    $self->{state} = $STATE_DONE;
    return;
}

# /*!
# @function MiniOxygen::Source::next_token
# @brief Gets the next MiniOxygen token from file
# @return a MiniOxygen::Token object
# */
sub next_token {
    my ($self) = @_;

    while ( my $line = shift @{ $self->{lines} } ) {

        # IDLE
        if ( $self->{state} == $STATE_IDLE ) {
            $self->_next_idle($line);
        }

        # MARK
        elsif ( $self->{state} == $STATE_MARK ) {
            $self->_next_mark($line);
        }

        # C
        elsif ( $self->{state} == $STATE_C ) {
            $self->_next_c($line);
        }

        # DONE (don't consume line)
        if ( $self->{state} == $STATE_DONE ) {
            $self->{state} = $STATE_IDLE;
            return $self->{token};
        }
        else { }
    }

    return;
}

1;

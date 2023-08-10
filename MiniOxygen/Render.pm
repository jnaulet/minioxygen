#!/usr/bin/env perl

#/*!
# @file MiniOxygen::Render
# @brief Markdown rendering module for MiniOxygen
# */
use strict;
use warnings;

use FindBin 1.51 qw( $RealBin );
use lib $RealBin;

package MiniOxygen::Render;

use Readonly;
use MiniOxygen::Markdown;

Readonly our $H1 => 1;
Readonly our $H2 => 2;
Readonly our $H3 => 3;
Readonly our $H4 => 4;

# Version (required by perlcritic --brutal)
our $VERSION = '0.1a';

Readonly our $FILES_HEADER => 'File/objects';

# /*!
# @function MiniOxygen::Render::list_files
# @brief Renders a bullet list of files contained in hash
# @param hash the db/hash containing all the javadoc information
# */
sub list_files {
    my ($hash) = @_;

    MiniOxygen::Markdown::header( $H2, $FILES_HEADER );

    foreach my $key ( keys %{$hash} ) {
        MiniOxygen::Markdown::bullet();
        MiniOxygen::Markdown::create_link($key);
    }

    MiniOxygen::Markdown::line();
    return;
}

sub file {
    my ($token) = @_;

    MiniOxygen::Markdown::header( $H2, $token->{file} );

    # brief
    if ( defined $token->{brief} ) {
        MiniOxygen::Markdown::bold( $token->{brief} );
        MiniOxygen::Markdown::newline();
    }

    # long
    if ( defined $token->{text} ) {
        MiniOxygen::Markdown::normal( $token->{text} );
        MiniOxygen::Markdown::newline();
    }

    return;
}

# /*!
# @function MiniOxygen::Render::list_functions
# @brief Renders a bullet list of functions
# @param array an array of MiniOxygen::Token objects
# */
sub list_functions {
    my ($array) = @_;

    for my $f ( @{$array} ) {
        MiniOxygen::Markdown::bullet();
        MiniOxygen::Markdown::create_link( $f->{function} );
    }

    MiniOxygen::Markdown::newline();
    MiniOxygen::Markdown::normal('Back to ');
    MiniOxygen::Markdown::create_link($FILES_HEADER);
    MiniOxygen::Markdown::newline();
    MiniOxygen::Markdown::line();
    return;
}

sub _function_proto {
    my ($token) = @_;

    MiniOxygen::Markdown::header( $H3, 'Prototype' );

    my $params = q{};
    my $proto  = q{};

    if ( defined $token->{return_type} ) {
        $proto .= $token->{return_type} . q{ };
    }

    $proto .= $token->{function} . ' ( ';
    for ( 0 .. scalar @{ $token->{param} } - 1 ) {

        my $param = q{};
        my $name  = $token->{param}[$_];
        my $type  = $token->{param_type}[$_];

        if ( defined $type ) { $param .= $type . q{ }; }
        $param .= $name;

        if ( $params eq q{} ) { $params = $param; }
        else                  { $params .= ', ' . $param; }
    }

    # fix params
    if ( !defined $params ) { $params = 'void'; }
    $proto .= $params . ' )';

    MiniOxygen::Markdown::code_block( q{    } . $proto );
    MiniOxygen::Markdown::newline();
    return;
}

sub _function_param {
    my ($token) = @_;

    # no section present
    if ( scalar @{ $token->{param} } == 0 ) { return; }

    MiniOxygen::Markdown::header( $H3, 'Parameters' );

    for ( 0 .. scalar @{ $token->{param} } - 1 ) {
        MiniOxygen::Markdown::bullet();
        MiniOxygen::Markdown::normal( $token->{param}[$_] . ' : ' );
        MiniOxygen::Markdown::normal( $token->{param_desc}[$_] );
    }

    MiniOxygen::Markdown::newline();
    return;
}

sub _function_return {
    my ($token) = @_;

    # no section present
    if ( !defined $token->{return} ) { return; }

    MiniOxygen::Markdown::header( $H3, 'Returns' );

    MiniOxygen::Markdown::bullet();
    MiniOxygen::Markdown::normal( $token->{return} );
    MiniOxygen::Markdown::newline();
    return;
}

# /*!
# @function  MiniOxygen::Render::function
# @brief Renders a function with details
# @param token a function token
# @param parent the parent object name/link
# */
sub function {
    my ( $token, $parent ) = @_;

    # header
    MiniOxygen::Markdown::header( $H2, $token->{function} );

    # brief
    if ( defined $token->{brief} ) {
        MiniOxygen::Markdown::bold( $token->{brief} );
        MiniOxygen::Markdown::newline();
    }

    # long
    if ( defined $token->{text} ) {
        MiniOxygen::Markdown::normal( $token->{text} );
        MiniOxygen::Markdown::newline();
    }

    # details
    _function_proto($token);
    _function_param($token);
    _function_return($token);

    MiniOxygen::Markdown::normal('Back to ');
    MiniOxygen::Markdown::create_link($parent);
    MiniOxygen::Markdown::newline();
    MiniOxygen::Markdown::line();
    return;
}

1;

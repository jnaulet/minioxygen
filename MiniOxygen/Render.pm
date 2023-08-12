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

use Carp;
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

    MiniOxygen::Markdown::newline();
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
# @function MiniOxygen::Render::list_defs
# @brief Renders a bullet list of defs/macros
# @param array an array of MiniOxygen::Token objects
# */
sub list_defs {
    my ($array) = @_;

    MiniOxygen::Markdown::header( $H3, 'Definitions' );

    for my $d ( @{$array} ) {
        MiniOxygen::Markdown::bullet();
        MiniOxygen::Markdown::create_link( $d->{def} );
    }

    MiniOxygen::Markdown::newline();
    MiniOxygen::Markdown::normal('Back to ');
    MiniOxygen::Markdown::create_link($FILES_HEADER);
    MiniOxygen::Markdown::newline();
    return;
}

sub _definition {
    my ($token) = @_;

    MiniOxygen::Markdown::header( $H3, 'Definition' );

    MiniOxygen::Markdown::code_block( q{    } . $token->{def} );
    MiniOxygen::Markdown::newline();
    return;
}

sub _parameters {
    my ($token) = @_;

    # no section present
    if ( scalar @{ $token->{param} } == 0 ) { return; }

    MiniOxygen::Markdown::header( $H3, 'Parameters' );

    for ( 0 .. scalar @{ $token->{param} } - 1 ) {
        MiniOxygen::Markdown::code_block(
            q{    } . $token->{param}[$_] . ' : ' . $token->{param_brief}[$_] );
    }

    MiniOxygen::Markdown::newline();
    return;
}

sub _returns {
    my ($token) = @_;

    # no section present
    if ( !defined $token->{return} ) { return; }

    MiniOxygen::Markdown::header( $H3, 'Returns' );

    MiniOxygen::Markdown::code_block( q{    } . $token->{return} );
    MiniOxygen::Markdown::newline();
    return;
}

# /*!
# @function MiniOxygen::Render::def
# @brief Renders a def with details
# @param token a def token
# @param parent the parent object name/link
# */
sub def {
    my ( $token, $parent ) = @_;

    # header
    MiniOxygen::Markdown::header( $H2, $token->{def} );

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

    _definition($token);
    _parameters($token);
    _returns($token);

    MiniOxygen::Markdown::normal('Back to ');
    MiniOxygen::Markdown::create_link($parent);
    MiniOxygen::Markdown::newline();
    return;
}

# /*!
# @function MiniOxygen::Render::list_enums
# @brief Renders a bullet list of enums
# @param array an array of MiniOxygen::Token objects
# */
sub list_enums {
    my ($array) = @_;

    MiniOxygen::Markdown::header( $H3, 'Data types' );

    for my $e ( @{$array} ) {
        MiniOxygen::Markdown::bullet();
        MiniOxygen::Markdown::create_link( $e->{enum} );
    }

    MiniOxygen::Markdown::newline();
    MiniOxygen::Markdown::normal('Back to ');
    MiniOxygen::Markdown::create_link($FILES_HEADER);
    MiniOxygen::Markdown::newline();
    return;
}

# /*!
# @function MiniOxygen::Render::enum
# @brief Renders an enum with details
# @param token an enum token
# @param parent the parent object name/link
# */
sub enum {
    my ( $token, $parent ) = @_;

    MiniOxygen::Markdown::header( $H3, $token->{enum} );

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

    # print Dumper $token;
    print 'Entry | Description' . qq{\n} or croak 'table output gone wrong';
    print '--- | ---' . qq{\n}           or croak 'table output gone wrong';

    for ( 0 .. scalar @{ $token->{entry} } - 1 ) {
        print $token->{entry}[$_] . ' | ' . $token->{comment}[$_] . qq{\n}
          or croak 'table output gone wrong';
    }

    MiniOxygen::Markdown::newline();
    MiniOxygen::Markdown::normal('Back to ');
    MiniOxygen::Markdown::create_link($parent);
    MiniOxygen::Markdown::newline();
    return;
}

# /*!
# @function MiniOxygen::Render::list_functions
# @brief Renders a bullet list of functions
# @param array an array of MiniOxygen::Token objects
# */
sub list_functions {
    my ($array) = @_;

    MiniOxygen::Markdown::header( $H3, 'Functions' );

    for my $f ( @{$array} ) {
        MiniOxygen::Markdown::bullet();
        MiniOxygen::Markdown::create_link( $f->{function} );
    }

    MiniOxygen::Markdown::newline();
    MiniOxygen::Markdown::normal('Back to ');
    MiniOxygen::Markdown::create_link($FILES_HEADER);
    MiniOxygen::Markdown::newline();
    return;
}

sub _prototype {
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

# /*!
# @function MiniOxygen::Render::function
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
    _prototype($token);
    _parameters($token);
    _returns($token);

    MiniOxygen::Markdown::normal('Back to ');
    MiniOxygen::Markdown::create_link($parent);
    MiniOxygen::Markdown::newline();
    return;
}

# /*!
# @function MiniOxygen::Render::list_structs
# @brief Renders a bullet list of data structures
# @param array an array of MiniOxygen::Token objects
# */
sub list_structs {
    my ($array) = @_;

    MiniOxygen::Markdown::header( $H3, 'Data structures' );

    for my $f ( @{$array} ) {
        MiniOxygen::Markdown::bullet();
        MiniOxygen::Markdown::create_link( $f->{struct} );
    }

    MiniOxygen::Markdown::newline();
    MiniOxygen::Markdown::normal('Back to ');
    MiniOxygen::Markdown::create_link($FILES_HEADER);
    MiniOxygen::Markdown::newline();
    return;
}

# /*!
# @function MiniOxygen::Render::struct
# @brief Renders a struct with details
# @param token a struct token
# @param parent the parent object name/link
# */
sub struct {
    my ( $token, $parent ) = @_;

    MiniOxygen::Markdown::header( $H3, $token->{struct} );

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

    # This has proven to be quite challenging for this quick-and-dirty project,
    # so let's wrap this up
    for my $entry ( @{ $token->{contents} } ) {
        MiniOxygen::Markdown::code_block( q{    } . $entry );
    }

    MiniOxygen::Markdown::newline();
    MiniOxygen::Markdown::normal('Back to ');
    MiniOxygen::Markdown::create_link($parent);
    MiniOxygen::Markdown::newline();
    return;
}

1;

#!/usr/bin/env perl

# /*!
# @file MiniOxygen::Input
# @brief Input module for MiniOxygen
# */
use strict;
use warnings;

use FindBin 1.51 qw( $RealBin );
use lib $RealBin;

package MiniOxygen::Input;

use Carp;
use Carp::Assert;

# Version (required by perlcritic --brutal)
our $VERSION = '0.1a';

# /*!
# @function MiniOxygen::Input::file_to_array
# @brief Reads a text file and stores each line in an array
# @param path the path to the file
# @return array an array containing one line per entry
# */
sub file_to_array {
    my $path = shift;

    assert( -e $path );

    open my $fd, '<', $path || croak 'Can\'t open file ' . $path;  # $OS_ERROR ?
    my @lines = <$fd>;
    close $fd || croak 'Can\'t close file ' . $path;

    return @lines;
}

# /*!
# @function MiniOxygen::Input::file_to_str
# @brief Reads a text file and stores each line in an single line
# @param path the path to the file
# @return string a string containing the whole text file
# */
sub file_to_str {
    my $path = shift;

    assert( -e $path );

    my @lines = MiniOxygen::Input::file_to_array($path);
    return join q{}, @lines;
}

1;

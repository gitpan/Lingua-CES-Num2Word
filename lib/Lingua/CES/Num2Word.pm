# For Emacs: -*- mode:cperl; mode:folding; coding:utf-8; -*-

package Lingua::CES::Num2Word;
# ABSTRACT: Lingua::CES::Num2Word is module for conversion numbers into their representation in Czech. It converts whole numbers from 0 up to 999 999 999.

# {{{ use block

use strict;
use warnings;
use utf8;

use Perl6::Export::Attrs;

# }}}
# {{{ BEGIN

my($ver)       = ('$Rev: 440 $' =~ m{(\d+)}xms);
our $VERSION  = $ver / 10_000;
our $REVISION = '$Rev: 440 $';

# }}}
# {{{ variables

my %token1 = qw( 0 nula         1 jedna         2 dva
                 3 tři          4 čtyři         5 pět
                 6 šest         7 sedm          8 osm
                 9 devět        10 deset        11 jedenáct
                 12 dvanáct     13 třináct      14 čtrnáct
                 15 patnáct     16 šestnáct     17 sedmnáct
                 18 osmnáct     19 devatenáct
               );
my %token2 = qw( 20 dvacet      30 třicet       40 čtyřicet
                 50 padesát     60 šedesát      70 sedmdesát
                 80 osmdesát    90 devadesát
               );
my %token3 = (  100, 'sto', 200, 'dvě stě',   300, 'tři sta',
                400, 'čtyři sta', 500, 'pět set',   600, 'šest set',
                700, 'sedm set',  800, 'osm set',   900, 'devět set'
             );

# }}}

# {{{ num2ces_cardinal           number to string conversion

sub num2ces_cardinal :Export {
    my $result = '';
    my $number = defined $_[0] ? shift : return $result;

    # numbers less than 0 are not supported yet
    return $result if $number < 0;

    my $reminder = 0;

    if ($number < 20) {
        $result = $token1{$number};
    }
    elsif ($number < 100) {
        $reminder = $number % 10;
        if ($reminder == 0) {
            $result = $token2{$number};
        }
        else {
            $result = $token2{$number - $reminder}.' '.num2ces_cardinal($reminder);
        }
    }
    elsif ($number < 1_000) {
        $reminder = $number % 100;
        if ($reminder != 0) {
            $result = $token3{$number - $reminder}.' '.num2ces_cardinal($reminder);
        }
        else {
            $result = $token3{$number};
        }
    }
    elsif ($number < 1_000_000) {
        $reminder = $number % 1_000;
        my $tmp1 = ($reminder != 0) ? ' '.num2ces_cardinal($reminder) : '';
        my $tmp2 = substr($number, 0, length($number)-3);
        my $tmp3 = $tmp2 % 100;
        my $tmp4 = $tmp2 % 10;

        if ($tmp3 < 9 || $tmp3 > 20) {
            if ($tmp4 == 1 && $tmp2 == 1) {
                $tmp2 = 'tisíc';
            }
            elsif ($tmp4 == 1) {
                $tmp2 = num2ces_cardinal($tmp2 - $tmp4).' jeden tisíc';
            }
            elsif($tmp4 > 1 && $tmp4 < 5) {
                $tmp2 = num2ces_cardinal($tmp2).' tisíce';
            }
            else {
                $tmp2 = num2ces_cardinal($tmp2).' tisíc';
            }
        }
        else {
            $tmp2 = num2ces_cardinal($tmp2).' tisíc';
        }
        $result = $tmp2.$tmp1;
    }
    elsif ($number < 1_000_000_000) {
        $reminder = $number % 1_000_000;
        my $tmp1 = ($reminder != 0) ? ' '.num2ces_cardinal($reminder) : '';
        my $tmp2 = substr($number, 0, length($number)-6);
        my $tmp3 = $tmp2 % 100;
        my $tmp4 = $tmp2 % 10;

        if ($tmp3 < 9 || $tmp3 > 20) {
            if ($tmp4 == 1 && $tmp2 == 1) {
                $tmp2 = 'milion';
            }
            elsif ($tmp4 == 1) {
                $tmp2 = num2ces_cardinal($tmp2 - $tmp4).' jeden milion';
            }
            elsif($tmp4 > 1 && $tmp4 < 5) {
                $tmp2 = num2ces_cardinal($tmp2).' miliony';
            }
            else {
                $tmp2 = num2ces_cardinal($tmp2).' milionů';
            }
        }
        else {
            $tmp2 = num2ces_cardinal($tmp2).' milionů';
        }

        $result = $tmp2.$tmp1;
    }
    else {
        # >= 1 000 000 000 unsupported yet (miliard)
    }

    return $result;
}

# }}}

1;

__END__

# {{{ POD HEAD

=head1 NAME


=head1 VERSION

version 0.044
Lingua::CES::Num2Word -  number to text convertor for Czech.
Output text is encoded in utf-8.

=head2 $Rev: 440 $

ISO 639-3 namespace.

=head1 SYNOPSIS

 use Lingua::CES::Num2Word;

 my $text = Lingua::CES::Num2Word::num2ces_cardinal( 123 );

 print $text || "sorry, can't convert this number into czech language.";

=head1 DESCRIPTION

Lingua::CES::Num2Word is module for conversion numbers into their representation
in Czech. It converts whole numbers from 0 up to 999 999 999.

=cut

# }}}
# {{{ Functions reference

=pod

=head1 Functions Reference

=over 2

=item num2ces_cardinal (positional)

  1   number  number to convert
  =>  string  lexical representation of the input
      undef   if input number is not known

Convert number to text representation.

=back

=cut

# }}}
# {{{ POD FOOTER

=pod

=head1 EXPORT_OK

num2ces_cardinal

=head1 KNOWN BUGS

None.

=head1 AUTHOR

 coding, maintenance, refactoring, extensions, specifications:
   Richard C. Jelinek <info@petamem.com>
 initial coding after specification by R. Jelinek:
   Roman Vasicek <info@petamem.com>

=head1 COPYRIGHT

Copyright (C) PetaMem, s.r.o. 2004-present

=head2 LICENSE

Artistic license or BSD license.

=cut

# }}}

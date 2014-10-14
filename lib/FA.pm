
use Term::ANSIColor 2.01 qw(BOLD :constants);
use Bio::SeqIO;
use Bio::Tools::GFF;
use Data::Dumper;

use warnings;
use strict;

sub facat {    
     my ($fh, $file, $prefix, $sep, $normspace) = @_;
     my $seqObj  = Bio::SeqIO->new(-file => $file, -format => "fasta");
     while ( my $seq = $seqObj->next_seq ) {
          my $id = $seq->id;
          my $desc = $seq->desc;
          if ($prefix) {
                $id = $prefix . " " . $id;
          }
          unless ($normspace) {
                $id = join $sep, ((split /\s+/, $id), (split /\s+/, $desc));
          }
          else {
              if ($desc) {
                  $id = join " ", ($id, $desc);
              }
          }
          print $fh ">$id\n";
          print $fh $seq->seq . "\n";
     }
     return 1;
}

sub fagrep{
    my ($fh, $file, $query, $exact) = @_;
    my $seqObj  = Bio::SeqIO->new(-file => $file, -format => "fasta");
    while ( my $seq = $seqObj->next_seq ) {
        my $id = $seq->id;
        my $desc = $seq->desc;
        if ($exact) {
            # exact match doesn't match within description
            if (/^$id$/ ~~ @$query) {
                print $fh ">$id $desc\n";
                print $fh $seq->seq . "\n";
            }
        }
        else {
            my $found = 0;
            foreach my $query (@$query) {
                if ($id =~ $query or $desc =~ $query) {
                    $found++;
                }
            }
            if ($found) {
                print $fh ">$id $desc\n";
                print $fh $seq->seq . "\n";
            }
        }
    }
    return 1;
}


sub fagrepif {
    my ($fh, $fastafile, $query, $colour) = @_;
    my $seq = Bio::SeqIO->new(-file => $fastafile, -format => "fasta");
    while ( my $seq = $seq->next_seq ) {
        my $id = $seq->primary_id;
        my $desc = $seq->desc;
        my $seq = $seq->seq;
        my @codons = ($seq =~ m/.{3}/g);
        my $found = 0;
        foreach my $cdn (@codons) {
            $found = 1 if $cdn eq $query;
        }
        if ($found) {
            print $fh ">$id $desc\n";
            foreach my $cdn (@codons) {
                if ($cdn eq $query) {
                    if ($colour eq 'none') {
                        print $fh "$cdn";
                    }
                    # why can't the colour be a variable?
                    elsif (lc($colour eq "black")) {
                        print $fh BOLD BLACK $cdn;
                    }
                    elsif (lc($colour eq "red")) {
                        print $fh BOLD RED $cdn;
                    }
                    elsif (lc($colour eq "green")) {
                        print $fh BOLD GREEN $cdn;
                    }
                    elsif (lc($colour eq "yellow")) {
                        print $fh BOLD YELLOW $cdn;
                    }
                    elsif (lc($colour eq "blue")) {
                        print $fh BOLD BLUE $cdn;
                    }
                    elsif (lc($colour eq "magenta")) {
                        print $fh BOLD MAGENTA $cdn;
                    }
                    elsif (lc($colour eq "cyan")) {
                        print $fh BOLD CYAN $cdn;
                    }
                    elsif (lc($colour eq "white")) {
                        print $fh BOLD WHITE $cdn;
                    }
                    else {
                        print $fh BOLD $cdn;
                    }
                }
                else {
                    print $fh "$cdn";
                }
            }
            print $fh "\n";
        }
    }
    return 1;
}


################################################################################
## returns an array of the 64 anticodons in the order of the GCN tables (alphabetical)
sub get_64_anticodons {
    my $acpos1 = "A" x 16 . "C" x 16 . "G" x 16 . "T" x 16;
    my $acpos2 = ("A" x 4 . "C" x 4 . "G" x 4 . "T" x 4) x 4;
    my $acpos3 = "ACGT" x 16;
    
    my @anticodons;
    for (my $i=0; $i<length($acpos1); $i++) {
        my $ac = substr($acpos1, $i, 1) . substr($acpos2, $i, 1) . substr($acpos3, $i, 1);
        push @anticodons, $ac;
    }
    my $str = join ".", @anticodons;
    return \@anticodons;
}

################################################################################
## returns an array of 64 codons, in the order of the GCN tables -- alphabetically by anticodon
sub get_64_codons {
    my @codons;
    my $anticodons = get_64_anticodons();
    foreach my $ac (@$anticodons) {
        my $acd = Bio::PrimarySeq->new($ac);
        my $cd = $acd->revcom();
        push @codons, $cd->seq;
    }
    return \@codons;
}


sub fatrans {
    my ($fh, $file, $genetic_code, $frame) = @_;
    my $seq = Bio::SeqIO->new(-file => $file, -format => "fasta");
	
	my $current_gene = '';
	my $current_seq = '';
	
	my $myCodonTable = Bio::Tools::CodonTable->new( -id => $genetic_code);
	    
	my %translationtable;
	foreach my $cdn (@{get_64_codons()}) {
	    $translationtable{$cdn} = $myCodonTable->translate($cdn);
	}
	
	while ( my $seq = $seq->next_seq ) {
	    my $id = $seq->primary_id;
	
	    my $protein = '';
        my $sequence = $seq->subseq($frame + 1, length($seq->seq) );
	    my @codons = ($sequence =~ m/.{3}/g);
	    foreach my $cdn (@codons) {
	        $protein .= $translationtable{$cdn};
	    }
	
	   	print $fh ">$id\n";
	   	print $fh "$protein\n";
	}
    return 1;
}

sub alignsubseq {
    # disregards dashes and returns the position that the requested subseq of the non-aligned sequence has
    my ($seq, $start, $end) = @_;
    my @nt = ($seq =~ m/./g);
    my $gap_before_start = 0;
    my $gap_before_end = 0;
    while (my ($index, $nt) = each @nt) {
        #print "$index $nt $gap_before_start $gap_before_end\n";

        if ($nt eq "-") {  # TODO allow for more gap characters
            if ($index <= $start + $gap_before_start) {
                $gap_before_start++;
            }
            if ($index <= $end + $gap_before_end) {
                $gap_before_end++;
            }
        }
    }
    return ($start + $gap_before_start, $end + $gap_before_end);
}

sub fagff {
    my ($fh, $fastafile, $gff, $nogaps) = @_;

    # use the gff file to extract appropriate columns for each gff feature from the fasta file
    # fasta file can be an alignment, and - characters will be ignored in the first entry of the fasta file to select the columns to keep
    # thus, you can have a normal gff file for a sequence, align the fasta file it refers to to some other sequences, and extract the proteins using your original gff file, independent of the alignment, and retrieve the corresponding proteins from all entries in the alignment

    my $first = 1;
    my @positions;
    my $seq = Bio::SeqIO->new(-file => $fastafile, -format => "fasta");
    while ( my $seq = $seq->next_seq ) {
        my $id = $seq->id;
        my $desc = $seq->desc;
        if ($first) {
            my $gffio = Bio::Tools::GFF->new(-file => $gff, -gff_version => 3);
            while(my $feature = $gffio->next_feature()) {
                # maybe each feature should be written into different files; but they can be grepped with fagrep after anyway
                my ($start, $end) = alignsubseq($seq->seq, $feature->start, $feature->end);
                push @positions, {start => $start, end => $end, orig_start => $feature->start, orig_end => $feature->end};
            }
            $first = 0;
        }
        foreach my $pos (@positions) {
            my $identifier = "";
            $identifier = "$id" . "_" . $pos->{orig_start} . "-" . $pos->{orig_end} . " " . $desc if $desc;
            $identifier = "$id" . "_" . $pos->{orig_start} . "-" . $pos->{orig_end} unless $desc;

            print $fh ">$identifier\n";
            my $printseq = $seq->subseq($pos->{start}, $pos->{end});
            if ($nogaps) {
                $printseq =~ s/-//g;
            }
            print $fh $printseq . "\n";
        }
    }
    return 1;
}


1;

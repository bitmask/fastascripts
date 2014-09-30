
use Term::ANSIColor 2.01 qw(BOLD :constants);
use Bio::SeqIO;

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


1;

use strict;
use warnings;
use FindBin qw( $RealBin );
use lib "$RealBin/lib";
use Data::Dumper;
use TrueWallet qw(getToken getProfile getBalance getActivity topupTW txDetail logout);

Main();
sub Main {
	# login to TrueWallet
	my $email = '';
	my $password = '';
	my $token = getToken($email, $password);
	if (defined $token) {
		# check Balance 
		my $balance = getBalance($token);
		print "You have balance is $balance\n";
		# check Activity [Start - end] // check all Report id 
		my $activity = getActivity($token,'2018-12-28','2019-01-02'); #start , end [YYYY-MM-DD] 
		foreach my $i ( @$activity ) {
   			my $txdetail = txDetail($token, $i->{report_id});
			print "======================================\n";
			printf "Report ID: %s\n", $i->{report_id};
		    printf "Date: %s\n", $i->{date_time};
		    printf "Topup Mode: %s\n",$txdetail->{service_type};
		    printf "To: %s\n", $txdetail->{ref1};
   		    printf "Amount: %s\n", $i->{amount};
		    print "======================================\n";
		}
		#logout from TrueWallet
		my $logout = logout($token);
	} else {
		print "Cannot get token from truewallet\n";
	}
}


use strict;
use FindBin qw( $RealBin );
use lib "$RealBin/lib";
use Data::Dumper;
use TrueWallet;

Main();
sub Main {
	# login to TrueWallet
	my $token = TrueWallet::getToken('username', 'password');
	if (defined $token) {
		# check Balance 
		my $balance = TrueWallet::getBalance($token);
		print "You have balance is $balance\n";
		# check Activity [Start - end] // check all Report id 
		my $activity = TrueWallet::getActivity($token,'2018-12-28','2019-01-01'); #start , end
		foreach my $i ( @$activity ) {
   			my $txdetail = TrueWallet::txDetail($token, $i->{report_id});
			print "======================================\n";
			printf "Report ID: %s\n", $i->{report_id};
		    printf "Date: %s\n", $i->{date_time};
		    printf "Topup Mode: %s\n",$txdetail->{service_type};
		    printf "To: %s\n", $txdetail->{ref1};
   		    printf "Amount: %s\n", $i->{amount};
		    print "======================================\n";
		}
		#logout from TrueWallet
		my $logout = TrueWallet::logout($token);
	} else {
		print "Cannot get token from truewallet\n";
	}
}


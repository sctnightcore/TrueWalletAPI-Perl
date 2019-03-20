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
		# check Activity [Start - end]
		my $activity = TrueWallet::getActivity($token,'2018-12-28','2019-01-01'); #start , end
		foreach my $i ( @$activity ) {
			print "======================================\n";
			printf "Report ID: %s\n", $i->{report_id};
		    printf "Date: %s\n", $i->{date_time};
		    printf "Original Type: %s\n", $i->{original_type};
		    printf "Amount: %s\n", $i->{amount};
		    print "======================================\n";
		}
		#check Activity with Report_id
		my $txdetail = TrueWallet::txDetail($token,'549939742'); #549939742 = $activity->{report_id}
		print "====================\n";
		printf "Report ID: %s\n",'549939742';
		printf "Topup Mode: %s\n",$txdetail->{service_type};
		printf "To: %s\n",$txdetail->{ref1};
		print "====================\n";
		#logout from TrueWallet
		my $logout = TrueWallet::logout($token);
	} else {
		print "Cannot get token from truewallet\n";
	}
}


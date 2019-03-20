use strict;
use warnings;
use Data::Dumper;
use TrueWallet::Api qw/:all/;

Main();
sub Main {
	# login to TrueWallet
	my $email = '';
	my $password = '';
	my $token = Login($email, $password);
	if (defined $token) {
		# check Balance 
		my $balance = get_Balance($token);
		print "You have balance is $balance\n";
		# check Activity [Start - end] // check all Report id 
		my $activity = get_Activity($token,'2018-12-28','2019-01-02'); #start , end [YYYY-MM-DD] 
		foreach my $i ( @$activity ) {
   			my $txdetail = get_TxDetail($token, $i->{report_id});
			print "======================================\n";
			printf "Report ID: %s\n", $i->{report_id};
		    printf "Date: %s\n", $i->{date_time};
		    printf "Topup Mode: %s\n",$txdetail->{service_type};
		    printf "To: %s\n", $txdetail->{ref1};
   		    printf "Amount: %s\n", $i->{amount};
		    print "======================================\n";
		}
		#logout from TrueWallet
		my $logout = Logout($token);
	} else {
		print "Cannot get token from truewallet\n";
	}
}

use strict;
use FindBin qw( $RealBin );
use lib "$RealBin/Lib";
use TrueWallet;

sub Main {
	my $token = TrueWallet::getToken('username', 'password');
	my $activity = TrueWallet::getActivity($token,'2018-12-28|start','2019-01-01|end');
	my $logout = TrueWallet::logout($token);
}


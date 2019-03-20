package TrueWallet;
use strict;
use warnings;
use JSON::XS qw( decode_json encode_json);
use Digest::SHA1 qw(sha1 sha1_hex sha1_base64);
use HTTP::Tiny;
use Data::Dumper;
my $http = HTTP::Tiny->new;

sub getToken {
	my ($user, $pass) = @_;
	my %body = (username => "$user", password => sha1_hex($user.$pass), type => 'email');
	my $response = $http->request( 'POST', 'https://mobile-api-gateway.truemoney.com/mobile-api-gateway/api/v1/signin', {
			Host => 'mobile-api-gateway.truemoney.com',
			headers => {
				'content-type' => 'application/json'
			},
			content => encode_json \%body
		}
	);
	if ($response->{success}) {
		my $tokenjson = decode_json($response->{content});
		return $tokenjson->{'data'}->{'accessToken'};		
	} else {
		print "Cannot get Token from Truewallet !\n";
	}
}

sub getProfile {
	my ($token) = @_;
	my $response = $http->request( 'GET', "https://mobile-api-gateway.truemoney.com/mobile-api-gateway/api/v1/profile/$token", {
			Host => 'mobile-api-gateway.truemoney.com'
	});

	if ($response->{success}) {
		my $profilejson = decode_json($response->{content});
		return $profilejson->{'data'};		
	} else {
		print "Cannot get Profile from Truewallet !\n";
	}
}

sub getBalance {
	my ($token) = @_;
	my $response = $http->request( 'GET', "https://mobile-api-gateway.truemoney.com/mobile-api-gateway/api/v1/profile/balance/$token", {
			Host => 'mobile-api-gateway.truemoney.com'
	});

	if ($response->{success}) {
		my $balancejson = decode_json($response->{content});
		return $balancejson->{'data'}->{'currentBalance'};
	} else {
		print "Cannot get Balance from Truewallet !\n";
	}
}
sub getActivity {
	my ($token,$start,$end) = @_;
	my $limit = 25;
	my $response = $http->request( 'GET', "https://mobile-api-gateway.truemoney.com/mobile-api-gateway/user-profile-composite/v1/users/transactions/history?start_date=$start&end_date=$end&limit=$limit", {
			Host => 'mobile-api-gateway.truemoney.com',
			headers => {
				'Authorization' => $token
			}	
	});

	if ($response->{success}) {
		my $activityjson = decode_json($response->{content});
		my $activity = $activityjson->{'data'}->{'activities'};
		return $activity;
	} else {
		print "Cannot get Activity from Truewallet !\n";
	}

}

#NEED TO BE TEST 
sub topupTW {
	my ($token, $cashcard) = @_;
	my $time = time;
	my $response = $http->request( 'POST', "https://mobile-api-gateway.truemoney.com/mobile-api-gateway/api/v1/topup/mobile/$time/$token/cashcard/$cashcard", {
			Host => 'mobile-api-gateway.truemoney.com',
			headers => {
				'Authorization' => $token
			}
	});
	if ($response->{success}) {
		my $topuptwjson = decode_json($response->{content});
		return $topuptwjson->{'data'};
	} else {
		print "Cannot use topup in Truewallet !\n";
	}
}

sub txDetail {
	my ($token, $id) = @_;
	my $time = time;
	my $response = $http->request( 'GET', "https://mobile-api-gateway.truemoney.com/mobile-api-gateway/user-profile-composite/v1/users/transactions/history/detail/$id", {
			Host => 'mobile-api-gateway.truemoney.com',
			headers => {
				'Authorization' => $token
			}
	});
	if ($response->{success}) {
		my $txdetailjson = decode_json($response->{content});
		return $txdetailjson->{'data'};
	} else {
		print "Cannot Get txdetail from Truewallet !\n";
	}	

}
sub logout {
	my ($token) = @_;
	my $response = $http->request( 'POST', "https://mobile-api-gateway.truemoney.com/mobile-api-gateway/api/v1/signout/$token", {
			Host => 'mobile-api-gateway.truemoney.com'
	});
	if ($response->{success}) {
		my $logoutjson = decode_json($response->{content});
		return $logoutjson->{'data'};		
	} else {
		print "Cannot Logout Truewallet !\n";
	}	
}

1;
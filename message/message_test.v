module message

fn test_ipv4_addr() {
	addr := AddrPort{
		ip:   [u8(127), 0, 0, 1]!
		port: 19132
	}
	mut out := []u8{len: sizeof_addr4}
	n := put_addr(mut out, addr)
	assert n == sizeof_addr4
	assert out == [u8(4), 128, 255, 255, 254, 0x4a, 0xbc]

	got, read := read_addr(out)!
	assert read == sizeof_addr4
	assert got == addr
}

fn test_ipv6_addr() {
	addr := AddrPort{
		ip6:  [u8(0x20), 0x01, 0x0d, 0xb8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]!
		port: 19133
		is6:  true
	}
	mut out := []u8{len: sizeof_addr6}
	n := put_addr(mut out, addr)
	assert n == sizeof_addr6
	assert out[0] == 6
	assert out[1] == 23
	assert out[2] == 0
	assert out[3] == 0x4a
	assert out[4] == 0xbd
	assert out[9..25] == addr.ip6[..]

	got, read := read_addr(out)!
	assert read == sizeof_addr6
	assert got == addr
}

fn test_unconnected_ping() {
	pk := UnconnectedPing{
		ping_time:   42
		client_guid: -7
	}
	data := pk.encode()
	assert data.len == 33
	assert data[0] == id_unconnected_ping
	assert data[9..25] == unconnected_message_sequence[..]

	got := decode_unconnected_ping(data[1..])!
	assert got.ping_time == 42
	assert got.client_guid == -7
}

fn test_unconnected_pong() {
	pk := UnconnectedPong{
		ping_time:   42
		server_guid: 99
		data:        'MCPE;V RakNet'.bytes()
	}
	data := pk.encode()
	assert data[0] == id_unconnected_pong
	assert data[17..33] == unconnected_message_sequence[..]

	got := decode_unconnected_pong(data[1..])!
	assert got.ping_time == 42
	assert got.server_guid == 99
	assert got.data.bytestr() == 'MCPE;V RakNet'
}

fn test_open_request_1() {
	pk := OpenConnectionRequest1{
		client_protocol: protocol_version
		mtu:             576
	}
	data := pk.encode()
	assert data.len == 548
	assert data[0] == id_open_connection_request_1
	assert data[1..17] == unconnected_message_sequence[..]
	assert data[17] == protocol_version

	got := decode_open_connection_request_1(data[1..])!
	assert got.client_protocol == protocol_version
	assert got.mtu == 576
}

fn test_open_reply_1_cookie() {
	pk := OpenConnectionReply1{
		server_guid:         99
		server_has_security: true
		cookie:              0x01020304
		mtu:                 1400
	}
	data := pk.encode()
	assert data.len == 32
	assert data[0] == id_open_connection_reply_1
	assert data[25] == 1
	assert data[26..30] == [u8(1), 2, 3, 4]

	got := decode_open_connection_reply_1(data[1..])!
	assert got.server_guid == 99
	assert got.server_has_security
	assert got.cookie == 0x01020304
	assert got.mtu == 1400
}

fn test_open_request_2_cookie() {
	pk := OpenConnectionRequest2{
		server_address:      AddrPort{
			ip:   [u8(127), 0, 0, 1]!
			port: 19132
		}
		mtu:                 1200
		client_guid:         -7
		server_has_security: true
		cookie:              0xaabbccdd
	}
	data := pk.encode()
	assert data[0] == id_open_connection_request_2
	got := decode_open_connection_request_2(data[1..], true)!
	assert got.server_address == pk.server_address
	assert got.mtu == 1200
	assert got.client_guid == -7
	assert got.cookie == 0xaabbccdd
}

fn test_connected_ping_pong() {
	ping_data := ConnectedPing{
		ping_time: 123
	}.encode()
	assert ping_data[0] == id_connected_ping
	ping := decode_connected_ping(ping_data[1..])!
	assert ping.ping_time == 123

	pong_data := ConnectedPong{
		ping_time: 123
		pong_time: 456
	}.encode()
	assert pong_data[0] == id_connected_pong
	pong := decode_connected_pong(pong_data[1..])!
	assert pong.ping_time == 123
	assert pong.pong_time == 456
}

fn test_protocol_mismatch() {
	pk := IncompatibleProtocolVersion{
		server_protocol: 10
		server_guid:     99
	}
	data := pk.encode()
	assert data.len == 26
	assert data[0] == id_incompatible_protocol_version
	assert data[1] == 10
	assert data[2..18] == unconnected_message_sequence[..]

	got := decode_incompatible_protocol_version(data[1..])!
	assert got.server_protocol == 10
	assert got.server_guid == 99
}

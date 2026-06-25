module message

pub struct UnconnectedPing {
pub:
	ping_time   i64
	client_guid i64
}

pub fn (pk UnconnectedPing) encode() []u8 {
	mut b := []u8{len: 33}
	b[0] = id_unconnected_ping
	put_u64(mut b, 1, u64(pk.ping_time))
	copy(mut b[9..], unconnected_message_sequence)
	put_u64(mut b, 25, u64(pk.client_guid))
	return b
}

pub fn decode_unconnected_ping(data []u8) !UnconnectedPing {
	if data.len < 32 {
		return error('unexpected eof reading unconnected ping')
	}
	return UnconnectedPing{
		ping_time:   i64(read_u64(data, 0))
		client_guid: i64(read_u64(data, 24))
	}
}

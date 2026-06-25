module message

pub struct ConnectedPing {
pub:
	ping_time i64
}

pub fn (pk ConnectedPing) encode() []u8 {
	mut b := []u8{len: 9}
	b[0] = id_connected_ping
	put_u64(mut b, 1, u64(pk.ping_time))
	return b
}

pub fn decode_connected_ping(data []u8) !ConnectedPing {
	if data.len < 8 {
		return error('unexpected eof reading connected ping')
	}
	return ConnectedPing{
		ping_time: i64(read_u64(data, 0))
	}
}

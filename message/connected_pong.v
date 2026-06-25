module message

pub struct ConnectedPong {
pub:
	ping_time i64
	pong_time i64
}

pub fn (pk ConnectedPong) encode() []u8 {
	mut b := []u8{len: 17}
	b[0] = id_connected_pong
	put_u64(mut b, 1, u64(pk.ping_time))
	put_u64(mut b, 9, u64(pk.pong_time))
	return b
}

pub fn decode_connected_pong(data []u8) !ConnectedPong {
	if data.len < 16 {
		return error('unexpected eof reading connected pong')
	}
	return ConnectedPong{
		ping_time: i64(read_u64(data, 0))
		pong_time: i64(read_u64(data, 8))
	}
}

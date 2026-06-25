module message

pub struct UnconnectedPong {
pub:
	ping_time   i64
	server_guid i64
	data        []u8
}

pub fn (pk UnconnectedPong) encode() []u8 {
	mut b := []u8{len: 35 + pk.data.len}
	b[0] = id_unconnected_pong
	put_u64(mut b, 1, u64(pk.ping_time))
	put_u64(mut b, 9, u64(pk.server_guid))
	copy(mut b[17..], unconnected_message_sequence)
	put_u16(mut b, 33, u16(pk.data.len))
	copy(mut b[35..], pk.data)
	return b
}

pub fn decode_unconnected_pong(data []u8) !UnconnectedPong {
	if data.len < 32 {
		return error('unexpected eof reading unconnected pong')
	}
	mut out := UnconnectedPong{
		ping_time:   i64(read_u64(data, 0))
		server_guid: i64(read_u64(data, 8))
	}
	if data.len < 34 {
		return out
	}
	n := int(read_u16(data, 32))
	if data.len < 34 + n {
		return error('unexpected eof reading unconnected pong data')
	}
	if n > 0 {
		out = UnconnectedPong{
			ping_time:   out.ping_time
			server_guid: out.server_guid
			data:        data[34..34 + n].clone()
		}
	}
	return out
}

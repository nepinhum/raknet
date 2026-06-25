module message

pub struct OpenConnectionReply1 {
pub:
	server_guid         i64
	server_has_security bool
	cookie              u32
	mtu                 u16
}

pub fn (pk OpenConnectionReply1) encode() []u8 {
	offset := if pk.server_has_security { 4 } else { 0 }
	mut b := []u8{len: 28 + offset}
	b[0] = id_open_connection_reply_1
	copy(mut b[1..], unconnected_message_sequence)
	put_u64(mut b, 17, u64(pk.server_guid))
	if pk.server_has_security {
		b[25] = 1
		put_u32(mut b, 26, pk.cookie)
	}
	put_u16(mut b, 26 + offset, pk.mtu)
	return b
}

pub fn decode_open_connection_reply_1(data []u8) !OpenConnectionReply1 {
	if data.len < 27 {
		return error('unexpected eof reading open connection reply 1')
	}
	mut offset := 0
	has_security := data[24] != 0
	mut cookie := u32(0)
	if has_security {
		offset = 4
	}
	if data.len < 27 + offset {
		return error('unexpected eof reading open connection reply 1 security')
	}
	if has_security {
		cookie = read_u32(data, 25)
	}
	return OpenConnectionReply1{
		server_guid:         i64(read_u64(data, 16))
		server_has_security: has_security
		cookie:              cookie
		mtu:                 read_u16(data, 25 + offset)
	}
}

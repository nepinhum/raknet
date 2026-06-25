module message

pub struct OpenConnectionReply2 {
pub:
	server_guid    i64
	client_address AddrPort
	mtu            u16
	do_security    bool
}

pub fn (pk OpenConnectionReply2) encode() []u8 {
	addr_size := sizeof_addr(pk.client_address)
	mut b := []u8{len: 28 + addr_size}
	b[0] = id_open_connection_reply_2
	copy(mut b[1..], unconnected_message_sequence)
	put_u64(mut b, 17, u64(pk.server_guid))
	put_addr(mut b[25..], pk.client_address)
	put_u16(mut b, 25 + addr_size, pk.mtu)
	if pk.do_security {
		b[27 + addr_size] = 1
	}
	return b
}

pub fn decode_open_connection_reply_2(data []u8) !OpenConnectionReply2 {
	if data.len < 24 {
		return error('unexpected eof reading open connection reply 2')
	}
	addr, n := read_addr(data[24..])!
	if data.len < 27 + n {
		return error('unexpected eof reading open connection reply 2 tail')
	}
	return OpenConnectionReply2{
		server_guid:    i64(read_u64(data, 16))
		client_address: addr
		mtu:            read_u16(data, 24 + n)
		do_security:    data[26 + n] != 0
	}
}

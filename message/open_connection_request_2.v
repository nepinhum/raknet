module message

import encoding.binary

pub struct OpenConnectionRequest2 {
pub:
	server_address      AddrPort
	mtu                 u16
	client_guid         i64
	server_has_security bool
	cookie              u32
}

pub fn (pk OpenConnectionRequest2) encode() []u8 {
	cookie_offset := if pk.server_has_security { 5 } else { 0 }
	addr_size := sizeof_addr(pk.server_address)
	mut b := []u8{len: 27 + addr_size + cookie_offset}
	b[0] = id_open_connection_request_2
	copy(mut b[1..], unconnected_message_sequence)
	if pk.server_has_security {
		put_u32(mut b, 17, pk.cookie)
	}
	put_addr(mut b[17 + cookie_offset..], pk.server_address)
	put_u16(mut b, 17 + addr_size + cookie_offset, pk.mtu)
	put_u64(mut b, 19 + addr_size + cookie_offset, u64(pk.client_guid))
	return b
}

pub fn decode_open_connection_request_2(data []u8, server_has_security bool) !OpenConnectionRequest2 {
	cookie_offset := if server_has_security { 5 } else { 0 }
	if data.len < 16 + cookie_offset {
		return error('unexpected eof reading open connection request 2')
	}
	addr, n := read_addr(data[16 + cookie_offset..])!
	offset := 16 + cookie_offset + n
	if data.len < offset + 10 {
		return error('unexpected eof reading open connection request 2 tail')
	}
	cookie := if server_has_security { binary.big_endian_u32_at(data, 16) } else { u32(0) }
	return OpenConnectionRequest2{
		server_address:      addr
		mtu:                 read_u16(data, offset)
		client_guid:         i64(read_u64(data, offset + 2))
		server_has_security: server_has_security
		cookie:              cookie
	}
}

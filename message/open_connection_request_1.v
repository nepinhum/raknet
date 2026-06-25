module message

pub struct OpenConnectionRequest1 {
pub:
	client_protocol u8
	mtu             u16
}

pub fn (pk OpenConnectionRequest1) encode() []u8 {
	mut b := []u8{len: int(pk.mtu) - 20 - 8}
	b[0] = id_open_connection_request_1
	copy(mut b[1..], unconnected_message_sequence)
	b[17] = pk.client_protocol
	return b
}

pub fn decode_open_connection_request_1(data []u8) !OpenConnectionRequest1 {
	if data.len < 17 {
		return error('unexpected eof reading open connection request 1')
	}
	return OpenConnectionRequest1{
		client_protocol: data[16]
		mtu:             u16(data.len + 20 + 8 + 1)
	}
}

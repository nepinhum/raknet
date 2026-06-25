module message

pub struct ConnectionRequest {
pub:
	client_guid  i64
	request_time i64
	secure       bool
}

pub fn (pk ConnectionRequest) encode() []u8 {
	mut b := []u8{len: 18}
	b[0] = id_connection_request
	put_u64(mut b, 1, u64(pk.client_guid))
	put_u64(mut b, 9, u64(pk.request_time))
	if pk.secure {
		b[17] = 1
	}
	return b
}

pub fn decode_connection_request(data []u8) !ConnectionRequest {
	if data.len < 17 {
		return error('unexpected eof reading connection request')
	}
	return ConnectionRequest{
		client_guid:  i64(read_u64(data, 0))
		request_time: i64(read_u64(data, 8))
		secure:       data[16] != 0
	}
}

module message

pub const sizeof_addr4 = 1 + 4 + 2
pub const sizeof_addr6 = 1 + 2 + 2 + 4 + 16 + 4

pub struct AddrPort {
pub:
	ip   [4]u8
	ip6  [16]u8
	port u16
	is6  bool
}

pub fn sizeof_addr(addr AddrPort) int {
	if addr.is6 {
		return sizeof_addr6
	}
	return sizeof_addr4
}

pub fn put_addr(mut b []u8, addr AddrPort) int {
	if addr.is6 {
		b[0] = 6
		put_little_u16(mut b, 1, 23)
		put_u16(mut b, 3, addr.port)
		copy(mut b[9..], addr.ip6[..])
		return sizeof_addr6
	}
	b[0] = 4
	b[1] = ~addr.ip[0]
	b[2] = ~addr.ip[1]
	b[3] = ~addr.ip[2]
	b[4] = ~addr.ip[3]
	put_u16(mut b, 5, addr.port)
	return sizeof_addr4
}

pub fn read_addr(b []u8) !(AddrPort, int) {
	if b.len < sizeof_addr4 {
		return error('unexpected eof reading address')
	}
	match b[0] {
		4, 0 {
			return AddrPort{
				ip:   [~b[1], ~b[2], ~b[3], ~b[4]]!
				port: read_u16(b, 5)
			}, sizeof_addr4
		}
		6 {
			if b.len < sizeof_addr6 {
				return error('unexpected eof reading ipv6 address')
			}
			return AddrPort{
				ip6:  [b[9], b[10], b[11], b[12], b[13], b[14], b[15], b[16], b[17], b[18], b[19],
					b[20], b[21], b[22], b[23], b[24]]!
				port: read_u16(b, 3)
				is6:  true
			}, sizeof_addr6
		}
		else {
			return error('unknown address family ${b[0]}')
		}
	}
}

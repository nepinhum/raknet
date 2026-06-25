# v_raknet

`v_raknet` is a RakNet implementation for V, focused on the classic RakNet protocol used by Minecraft: Bedrock Edition.

The API is plain-structed and inspired by Sandertv's `go-raknet`.

## Basic Server

```v
import v_raknet

mut listener := v_raknet.listen('0.0.0.0:19132')!
defer {
	listener.close() or {}
}

listener.set_pong_data('v_raknet server'.bytes())

mut conn := listener.accept()!
mut buf := []u8{len: 4096}
n := conn.read(mut buf)!
conn.write(buf[..n])!
```

## Basic Client

```v
import v_raknet

mut conn := v_raknet.dial('127.0.0.1:19132')!
defer {
	conn.close() or {}
}

conn.write('ping'.bytes())!
packet := conn.read_packet()!
println(packet.bytestr())
```

## Basic Ping

```v
import v_raknet

data := v_raknet.ping('127.0.0.1:19132')!
println(data.bytestr())
```

## Configuration

```v
import time
import v_raknet

mut listener := v_raknet.ListenConfig{
	max_mtu: 1200
	disable_cookies: false
	handshake_timeout: 10 * time.second
}.listen('0.0.0.0:19132')!

dialer := v_raknet.Dialer{
	max_mtu: 1200
	timeout: 2 * time.second
}
mut conn := dialer.dial(listener.addr())!
```

## **Notes**

- `listen`, `dial`, `ping`, `read`, `read_packet`, `write` and `close` are the main public API surface.
- `write([]u8{})` returns an error; empty RakNet payloads are not sent.
- Client-side connections own their UDP socket. Server-side connections share the listener socket.

## Tests

```sh
v test .
```

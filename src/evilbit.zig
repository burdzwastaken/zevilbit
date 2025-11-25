// Kernel module that sets the Evil Bit (RFC 3514)

const std = @import("std");
const kernel = @import("kernel.zig");

// kernel types
const sk_buff = opaque {};
const iphdr = opaque {};

// FFI functions for netfilter
extern fn zig_register_netfilter_hook() c_int;
extern fn zig_unregister_netfilter_hook() void;
extern fn zig_get_ip_header(skb: *sk_buff) ?*iphdr;
extern fn zig_set_evil_bit(iph: *iphdr) void;

// netfilter return codes
const NF_ACCEPT: c_uint = 1;

var packets_processed: u64 = 0;
var evil_packets: u64 = 0;

/// packet_hook is called for each packet in the POST_ROUTING chain
export fn zig_packet_hook(skb: *sk_buff) c_uint {
    packets_processed += 1;

    if (zig_get_ip_header(skb)) |ip_header| {
        zig_set_evil_bit(ip_header);
        evil_packets += 1;

        if (evil_packets % 1000 == 0) {
            kernel.print("marked {d} packets as evil so far!", .{evil_packets});
        }
    }

    return NF_ACCEPT;
}

export fn init_module() c_int {
    kernel.print("module loaded - RFC 3514 enforcement engaged!", .{});

    const result = zig_register_netfilter_hook();
    if (result != 0) {
        kernel.printErr("failed to register netfilter hook!", .{});
        return result;
    }

    kernel.print("netfilter hook registered on NF_INET_POST_ROUTING", .{});

    return 0;
}

export fn cleanup_module() void {
    zig_unregister_netfilter_hook();

    kernel.print("module unloaded - RFC 3514 enforcement disengaged!", .{});
    kernel.print("processed {d} packets", .{packets_processed});
    kernel.print("marked {d} packets as evil!", .{evil_packets});
    kernel.print("pwned", .{});
}

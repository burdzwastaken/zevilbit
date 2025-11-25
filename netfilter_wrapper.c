// Netfilter wrapper for Zig integration

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/netfilter.h>
#include <linux/netfilter_ipv4.h>
#include <linux/ip.h>
#include <linux/skbuff.h>

// declare the hook function
extern unsigned int zig_packet_hook(struct sk_buff *skb);

// netfilter hook wrapper
static unsigned int netfilter_hook_wrapper(void *priv,
                                          struct sk_buff *skb,
                                          const struct nf_hook_state *state)
{
    (void)priv;
    (void)state;

    if (skb) {
        return zig_packet_hook(skb);
    }
    return NF_ACCEPT;
}

// netfilter hook operations structure
static struct nf_hook_ops nfho = {
    .hook = netfilter_hook_wrapper,
    .pf = NFPROTO_IPV4,
    .hooknum = NF_INET_POST_ROUTING,
    .priority = NF_IP_PRI_FIRST,
};

// netfilter hook registration
int zig_register_netfilter_hook(void)
{
    int ret = nf_register_net_hook(&init_net, &nfho);
    if (ret < 0) {
        printk(KERN_ERR "evilbit: failed to register netfilter hook: %d\n", ret);
        return ret;
    }

    printk(KERN_INFO "evilbit: netfilter hook registered successfully\n");
    return 0;
}

// netfilter hook unregistration
void zig_unregister_netfilter_hook(void)
{
    nf_unregister_net_hook(&init_net, &nfho);
    printk(KERN_INFO "evilbit: netfilter hook unregistered\n");
}

// retrieve header from skbuff
struct iphdr* zig_get_ip_header(struct sk_buff *skb)
{
    if (!skb)
        return NULL;
    return ip_hdr(skb);
}

// set the Evil Bit in the IP header
void zig_set_evil_bit(struct iphdr *iph)
{
    if (!iph)
        return;

    // ze Evil Bit
    iph->frag_off |= htons(0x8000);

    // checksum
    iph->check = 0;
    iph->check = ip_fast_csum((unsigned char *)iph, iph->ihl);
}

// printk wrappers
void zig_printk_info(const char *msg)
{
    printk(KERN_INFO "evilbit: %s\n", msg);
}

void zig_printk_err(const char *msg)
{
    printk(KERN_ERR "evilbit: %s\n", msg);
}

void zig_printk_warn(const char *msg)
{
    printk(KERN_WARNING "evilbit: %s\n", msg);
}

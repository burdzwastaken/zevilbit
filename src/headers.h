// Kernel module headers for Zig translation

#define __KERNEL__
#define MODULE
#define __SANITIZE_ADDRESS__ 1
#define CONFIG_CC_HAS_SANE_FUNCTION_ALIGNMENT 1

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/netfilter.h>
#include <linux/netfilter_ipv4.h>
#include <linux/ip.h>
#include <linux/skbuff.h>
#include <linux/printk.h>

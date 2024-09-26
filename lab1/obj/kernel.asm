
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <kern_entry>:
    80200000:	00004117          	auipc	sp,0x4
    80200004:	00010113          	mv	sp,sp
    80200008:	a009                	j	8020000a <kern_init>

000000008020000a <kern_init>:
    8020000a:	00004517          	auipc	a0,0x4
    8020000e:	00650513          	addi	a0,a0,6 # 80204010 <ticks>
    80200012:	00004617          	auipc	a2,0x4
    80200016:	00e60613          	addi	a2,a2,14 # 80204020 <end>
    8020001a:	1141                	addi	sp,sp,-16
    8020001c:	8e09                	sub	a2,a2,a0
    8020001e:	4581                	li	a1,0
    80200020:	e406                	sd	ra,8(sp)
    80200022:	161000ef          	jal	ra,80200982 <memset>
    80200026:	14a000ef          	jal	ra,80200170 <cons_init>
    8020002a:	00001597          	auipc	a1,0x1
    8020002e:	96e58593          	addi	a1,a1,-1682 # 80200998 <etext+0x4>
    80200032:	00001517          	auipc	a0,0x1
    80200036:	98650513          	addi	a0,a0,-1658 # 802009b8 <etext+0x24>
    8020003a:	030000ef          	jal	ra,8020006a <cprintf>
    8020003e:	062000ef          	jal	ra,802000a0 <print_kerninfo>
    80200042:	13e000ef          	jal	ra,80200180 <idt_init>
    80200046:	0e8000ef          	jal	ra,8020012e <clock_init>
    8020004a:	130000ef          	jal	ra,8020017a <intr_enable>
    8020004e:	a001                	j	8020004e <kern_init+0x44>

0000000080200050 <cputch>:
    80200050:	1141                	addi	sp,sp,-16
    80200052:	e022                	sd	s0,0(sp)
    80200054:	e406                	sd	ra,8(sp)
    80200056:	842e                	mv	s0,a1
    80200058:	11a000ef          	jal	ra,80200172 <cons_putc>
    8020005c:	401c                	lw	a5,0(s0)
    8020005e:	60a2                	ld	ra,8(sp)
    80200060:	2785                	addiw	a5,a5,1
    80200062:	c01c                	sw	a5,0(s0)
    80200064:	6402                	ld	s0,0(sp)
    80200066:	0141                	addi	sp,sp,16
    80200068:	8082                	ret

000000008020006a <cprintf>:
    8020006a:	711d                	addi	sp,sp,-96
    8020006c:	02810313          	addi	t1,sp,40 # 80204028 <end+0x8>
    80200070:	8e2a                	mv	t3,a0
    80200072:	f42e                	sd	a1,40(sp)
    80200074:	f832                	sd	a2,48(sp)
    80200076:	fc36                	sd	a3,56(sp)
    80200078:	00000517          	auipc	a0,0x0
    8020007c:	fd850513          	addi	a0,a0,-40 # 80200050 <cputch>
    80200080:	004c                	addi	a1,sp,4
    80200082:	869a                	mv	a3,t1
    80200084:	8672                	mv	a2,t3
    80200086:	ec06                	sd	ra,24(sp)
    80200088:	e0ba                	sd	a4,64(sp)
    8020008a:	e4be                	sd	a5,72(sp)
    8020008c:	e8c2                	sd	a6,80(sp)
    8020008e:	ecc6                	sd	a7,88(sp)
    80200090:	e41a                	sd	t1,8(sp)
    80200092:	c202                	sw	zero,4(sp)
    80200094:	502000ef          	jal	ra,80200596 <vprintfmt>
    80200098:	60e2                	ld	ra,24(sp)
    8020009a:	4512                	lw	a0,4(sp)
    8020009c:	6125                	addi	sp,sp,96
    8020009e:	8082                	ret

00000000802000a0 <print_kerninfo>:
    802000a0:	1141                	addi	sp,sp,-16
    802000a2:	00001517          	auipc	a0,0x1
    802000a6:	91e50513          	addi	a0,a0,-1762 # 802009c0 <etext+0x2c>
    802000aa:	e406                	sd	ra,8(sp)
    802000ac:	fbfff0ef          	jal	ra,8020006a <cprintf>
    802000b0:	00000597          	auipc	a1,0x0
    802000b4:	f5a58593          	addi	a1,a1,-166 # 8020000a <kern_init>
    802000b8:	00001517          	auipc	a0,0x1
    802000bc:	92850513          	addi	a0,a0,-1752 # 802009e0 <etext+0x4c>
    802000c0:	fabff0ef          	jal	ra,8020006a <cprintf>
    802000c4:	00001597          	auipc	a1,0x1
    802000c8:	8d058593          	addi	a1,a1,-1840 # 80200994 <etext>
    802000cc:	00001517          	auipc	a0,0x1
    802000d0:	93450513          	addi	a0,a0,-1740 # 80200a00 <etext+0x6c>
    802000d4:	f97ff0ef          	jal	ra,8020006a <cprintf>
    802000d8:	00004597          	auipc	a1,0x4
    802000dc:	f3858593          	addi	a1,a1,-200 # 80204010 <ticks>
    802000e0:	00001517          	auipc	a0,0x1
    802000e4:	94050513          	addi	a0,a0,-1728 # 80200a20 <etext+0x8c>
    802000e8:	f83ff0ef          	jal	ra,8020006a <cprintf>
    802000ec:	00004597          	auipc	a1,0x4
    802000f0:	f3458593          	addi	a1,a1,-204 # 80204020 <end>
    802000f4:	00001517          	auipc	a0,0x1
    802000f8:	94c50513          	addi	a0,a0,-1716 # 80200a40 <etext+0xac>
    802000fc:	f6fff0ef          	jal	ra,8020006a <cprintf>
    80200100:	00004597          	auipc	a1,0x4
    80200104:	31f58593          	addi	a1,a1,799 # 8020441f <end+0x3ff>
    80200108:	00000797          	auipc	a5,0x0
    8020010c:	f0278793          	addi	a5,a5,-254 # 8020000a <kern_init>
    80200110:	40f587b3          	sub	a5,a1,a5
    80200114:	43f7d593          	srai	a1,a5,0x3f
    80200118:	60a2                	ld	ra,8(sp)
    8020011a:	3ff5f593          	andi	a1,a1,1023
    8020011e:	95be                	add	a1,a1,a5
    80200120:	85a9                	srai	a1,a1,0xa
    80200122:	00001517          	auipc	a0,0x1
    80200126:	93e50513          	addi	a0,a0,-1730 # 80200a60 <etext+0xcc>
    8020012a:	0141                	addi	sp,sp,16
    8020012c:	bf3d                	j	8020006a <cprintf>

000000008020012e <clock_init>:
    8020012e:	1141                	addi	sp,sp,-16
    80200130:	e406                	sd	ra,8(sp)
    80200132:	02000793          	li	a5,32
    80200136:	1047a7f3          	csrrs	a5,sie,a5
    8020013a:	c0102573          	rdtime	a0
    8020013e:	67e1                	lui	a5,0x18
    80200140:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0x801e7960>
    80200144:	953e                	add	a0,a0,a5
    80200146:	7ec000ef          	jal	ra,80200932 <sbi_set_timer>
    8020014a:	60a2                	ld	ra,8(sp)
    8020014c:	00004797          	auipc	a5,0x4
    80200150:	ec07b223          	sd	zero,-316(a5) # 80204010 <ticks>
    80200154:	00001517          	auipc	a0,0x1
    80200158:	93c50513          	addi	a0,a0,-1732 # 80200a90 <etext+0xfc>
    8020015c:	0141                	addi	sp,sp,16
    8020015e:	b731                	j	8020006a <cprintf>

0000000080200160 <clock_set_next_event>:
    80200160:	c0102573          	rdtime	a0
    80200164:	67e1                	lui	a5,0x18
    80200166:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0x801e7960>
    8020016a:	953e                	add	a0,a0,a5
    8020016c:	7c60006f          	j	80200932 <sbi_set_timer>

0000000080200170 <cons_init>:
    80200170:	8082                	ret

0000000080200172 <cons_putc>:
    80200172:	0ff57513          	zext.b	a0,a0
    80200176:	7a20006f          	j	80200918 <sbi_console_putchar>

000000008020017a <intr_enable>:
    8020017a:	100167f3          	csrrsi	a5,sstatus,2
    8020017e:	8082                	ret

0000000080200180 <idt_init>:
 */
void idt_init(void) {
    extern void __alltraps(void);
    /* Set sscratch register to 0, indicating to exception vector that we are
     * presently executing in the kernel */
    write_csr(sscratch, 0);
    80200180:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
    80200184:	00000797          	auipc	a5,0x0
    80200188:	2f078793          	addi	a5,a5,752 # 80200474 <__alltraps>
    8020018c:	10579073          	csrw	stvec,a5
}
    80200190:	8082                	ret

0000000080200192 <print_regs>:
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr) {
    cprintf("  zero     0x%08x\n", gpr->zero);
    80200192:	610c                	ld	a1,0(a0)
void print_regs(struct pushregs *gpr) {
    80200194:	1141                	addi	sp,sp,-16
    80200196:	e022                	sd	s0,0(sp)
    80200198:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
    8020019a:	00001517          	auipc	a0,0x1
    8020019e:	91650513          	addi	a0,a0,-1770 # 80200ab0 <etext+0x11c>
void print_regs(struct pushregs *gpr) {
    802001a2:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
    802001a4:	ec7ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
    802001a8:	640c                	ld	a1,8(s0)
    802001aa:	00001517          	auipc	a0,0x1
    802001ae:	91e50513          	addi	a0,a0,-1762 # 80200ac8 <etext+0x134>
    802001b2:	eb9ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
    802001b6:	680c                	ld	a1,16(s0)
    802001b8:	00001517          	auipc	a0,0x1
    802001bc:	92850513          	addi	a0,a0,-1752 # 80200ae0 <etext+0x14c>
    802001c0:	eabff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
    802001c4:	6c0c                	ld	a1,24(s0)
    802001c6:	00001517          	auipc	a0,0x1
    802001ca:	93250513          	addi	a0,a0,-1742 # 80200af8 <etext+0x164>
    802001ce:	e9dff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
    802001d2:	700c                	ld	a1,32(s0)
    802001d4:	00001517          	auipc	a0,0x1
    802001d8:	93c50513          	addi	a0,a0,-1732 # 80200b10 <etext+0x17c>
    802001dc:	e8fff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
    802001e0:	740c                	ld	a1,40(s0)
    802001e2:	00001517          	auipc	a0,0x1
    802001e6:	94650513          	addi	a0,a0,-1722 # 80200b28 <etext+0x194>
    802001ea:	e81ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
    802001ee:	780c                	ld	a1,48(s0)
    802001f0:	00001517          	auipc	a0,0x1
    802001f4:	95050513          	addi	a0,a0,-1712 # 80200b40 <etext+0x1ac>
    802001f8:	e73ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
    802001fc:	7c0c                	ld	a1,56(s0)
    802001fe:	00001517          	auipc	a0,0x1
    80200202:	95a50513          	addi	a0,a0,-1702 # 80200b58 <etext+0x1c4>
    80200206:	e65ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
    8020020a:	602c                	ld	a1,64(s0)
    8020020c:	00001517          	auipc	a0,0x1
    80200210:	96450513          	addi	a0,a0,-1692 # 80200b70 <etext+0x1dc>
    80200214:	e57ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
    80200218:	642c                	ld	a1,72(s0)
    8020021a:	00001517          	auipc	a0,0x1
    8020021e:	96e50513          	addi	a0,a0,-1682 # 80200b88 <etext+0x1f4>
    80200222:	e49ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
    80200226:	682c                	ld	a1,80(s0)
    80200228:	00001517          	auipc	a0,0x1
    8020022c:	97850513          	addi	a0,a0,-1672 # 80200ba0 <etext+0x20c>
    80200230:	e3bff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
    80200234:	6c2c                	ld	a1,88(s0)
    80200236:	00001517          	auipc	a0,0x1
    8020023a:	98250513          	addi	a0,a0,-1662 # 80200bb8 <etext+0x224>
    8020023e:	e2dff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
    80200242:	702c                	ld	a1,96(s0)
    80200244:	00001517          	auipc	a0,0x1
    80200248:	98c50513          	addi	a0,a0,-1652 # 80200bd0 <etext+0x23c>
    8020024c:	e1fff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
    80200250:	742c                	ld	a1,104(s0)
    80200252:	00001517          	auipc	a0,0x1
    80200256:	99650513          	addi	a0,a0,-1642 # 80200be8 <etext+0x254>
    8020025a:	e11ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
    8020025e:	782c                	ld	a1,112(s0)
    80200260:	00001517          	auipc	a0,0x1
    80200264:	9a050513          	addi	a0,a0,-1632 # 80200c00 <etext+0x26c>
    80200268:	e03ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
    8020026c:	7c2c                	ld	a1,120(s0)
    8020026e:	00001517          	auipc	a0,0x1
    80200272:	9aa50513          	addi	a0,a0,-1622 # 80200c18 <etext+0x284>
    80200276:	df5ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
    8020027a:	604c                	ld	a1,128(s0)
    8020027c:	00001517          	auipc	a0,0x1
    80200280:	9b450513          	addi	a0,a0,-1612 # 80200c30 <etext+0x29c>
    80200284:	de7ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
    80200288:	644c                	ld	a1,136(s0)
    8020028a:	00001517          	auipc	a0,0x1
    8020028e:	9be50513          	addi	a0,a0,-1602 # 80200c48 <etext+0x2b4>
    80200292:	dd9ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
    80200296:	684c                	ld	a1,144(s0)
    80200298:	00001517          	auipc	a0,0x1
    8020029c:	9c850513          	addi	a0,a0,-1592 # 80200c60 <etext+0x2cc>
    802002a0:	dcbff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
    802002a4:	6c4c                	ld	a1,152(s0)
    802002a6:	00001517          	auipc	a0,0x1
    802002aa:	9d250513          	addi	a0,a0,-1582 # 80200c78 <etext+0x2e4>
    802002ae:	dbdff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
    802002b2:	704c                	ld	a1,160(s0)
    802002b4:	00001517          	auipc	a0,0x1
    802002b8:	9dc50513          	addi	a0,a0,-1572 # 80200c90 <etext+0x2fc>
    802002bc:	dafff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
    802002c0:	744c                	ld	a1,168(s0)
    802002c2:	00001517          	auipc	a0,0x1
    802002c6:	9e650513          	addi	a0,a0,-1562 # 80200ca8 <etext+0x314>
    802002ca:	da1ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
    802002ce:	784c                	ld	a1,176(s0)
    802002d0:	00001517          	auipc	a0,0x1
    802002d4:	9f050513          	addi	a0,a0,-1552 # 80200cc0 <etext+0x32c>
    802002d8:	d93ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
    802002dc:	7c4c                	ld	a1,184(s0)
    802002de:	00001517          	auipc	a0,0x1
    802002e2:	9fa50513          	addi	a0,a0,-1542 # 80200cd8 <etext+0x344>
    802002e6:	d85ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
    802002ea:	606c                	ld	a1,192(s0)
    802002ec:	00001517          	auipc	a0,0x1
    802002f0:	a0450513          	addi	a0,a0,-1532 # 80200cf0 <etext+0x35c>
    802002f4:	d77ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
    802002f8:	646c                	ld	a1,200(s0)
    802002fa:	00001517          	auipc	a0,0x1
    802002fe:	a0e50513          	addi	a0,a0,-1522 # 80200d08 <etext+0x374>
    80200302:	d69ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
    80200306:	686c                	ld	a1,208(s0)
    80200308:	00001517          	auipc	a0,0x1
    8020030c:	a1850513          	addi	a0,a0,-1512 # 80200d20 <etext+0x38c>
    80200310:	d5bff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
    80200314:	6c6c                	ld	a1,216(s0)
    80200316:	00001517          	auipc	a0,0x1
    8020031a:	a2250513          	addi	a0,a0,-1502 # 80200d38 <etext+0x3a4>
    8020031e:	d4dff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
    80200322:	706c                	ld	a1,224(s0)
    80200324:	00001517          	auipc	a0,0x1
    80200328:	a2c50513          	addi	a0,a0,-1492 # 80200d50 <etext+0x3bc>
    8020032c:	d3fff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
    80200330:	746c                	ld	a1,232(s0)
    80200332:	00001517          	auipc	a0,0x1
    80200336:	a3650513          	addi	a0,a0,-1482 # 80200d68 <etext+0x3d4>
    8020033a:	d31ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
    8020033e:	786c                	ld	a1,240(s0)
    80200340:	00001517          	auipc	a0,0x1
    80200344:	a4050513          	addi	a0,a0,-1472 # 80200d80 <etext+0x3ec>
    80200348:	d23ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
    8020034c:	7c6c                	ld	a1,248(s0)
}
    8020034e:	6402                	ld	s0,0(sp)
    80200350:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
    80200352:	00001517          	auipc	a0,0x1
    80200356:	a4650513          	addi	a0,a0,-1466 # 80200d98 <etext+0x404>
}
    8020035a:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
    8020035c:	b339                	j	8020006a <cprintf>

000000008020035e <print_trapframe>:
void print_trapframe(struct trapframe *tf) {
    8020035e:	1141                	addi	sp,sp,-16
    80200360:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
    80200362:	85aa                	mv	a1,a0
void print_trapframe(struct trapframe *tf) {
    80200364:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
    80200366:	00001517          	auipc	a0,0x1
    8020036a:	a4a50513          	addi	a0,a0,-1462 # 80200db0 <etext+0x41c>
void print_trapframe(struct trapframe *tf) {
    8020036e:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
    80200370:	cfbff0ef          	jal	ra,8020006a <cprintf>
    print_regs(&tf->gpr);
    80200374:	8522                	mv	a0,s0
    80200376:	e1dff0ef          	jal	ra,80200192 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
    8020037a:	10043583          	ld	a1,256(s0)
    8020037e:	00001517          	auipc	a0,0x1
    80200382:	a4a50513          	addi	a0,a0,-1462 # 80200dc8 <etext+0x434>
    80200386:	ce5ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
    8020038a:	10843583          	ld	a1,264(s0)
    8020038e:	00001517          	auipc	a0,0x1
    80200392:	a5250513          	addi	a0,a0,-1454 # 80200de0 <etext+0x44c>
    80200396:	cd5ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
    8020039a:	11043583          	ld	a1,272(s0)
    8020039e:	00001517          	auipc	a0,0x1
    802003a2:	a5a50513          	addi	a0,a0,-1446 # 80200df8 <etext+0x464>
    802003a6:	cc5ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
    802003aa:	11843583          	ld	a1,280(s0)
}
    802003ae:	6402                	ld	s0,0(sp)
    802003b0:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
    802003b2:	00001517          	auipc	a0,0x1
    802003b6:	a5e50513          	addi	a0,a0,-1442 # 80200e10 <etext+0x47c>
}
    802003ba:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
    802003bc:	b17d                	j	8020006a <cprintf>

00000000802003be <interrupt_handler>:

void interrupt_handler(struct trapframe *tf) {
    intptr_t cause = (tf->cause << 1) >> 1;
    802003be:	11853783          	ld	a5,280(a0)
    802003c2:	472d                	li	a4,11
    802003c4:	0786                	slli	a5,a5,0x1
    802003c6:	8385                	srli	a5,a5,0x1
    802003c8:	06f76e63          	bltu	a4,a5,80200444 <interrupt_handler+0x86>
    802003cc:	00001717          	auipc	a4,0x1
    802003d0:	b0c70713          	addi	a4,a4,-1268 # 80200ed8 <etext+0x544>
    802003d4:	078a                	slli	a5,a5,0x2
    802003d6:	97ba                	add	a5,a5,a4
    802003d8:	439c                	lw	a5,0(a5)
    802003da:	97ba                	add	a5,a5,a4
    802003dc:	8782                	jr	a5
            break;
        case IRQ_H_SOFT:
            cprintf("Hypervisor software interrupt\n");
            break;
        case IRQ_M_SOFT:
            cprintf("Machine software interrupt\n");
    802003de:	00001517          	auipc	a0,0x1
    802003e2:	aaa50513          	addi	a0,a0,-1366 # 80200e88 <etext+0x4f4>
    802003e6:	b151                	j	8020006a <cprintf>
            cprintf("Hypervisor software interrupt\n");
    802003e8:	00001517          	auipc	a0,0x1
    802003ec:	a8050513          	addi	a0,a0,-1408 # 80200e68 <etext+0x4d4>
    802003f0:	b9ad                	j	8020006a <cprintf>
            cprintf("User software interrupt\n");
    802003f2:	00001517          	auipc	a0,0x1
    802003f6:	a3650513          	addi	a0,a0,-1482 # 80200e28 <etext+0x494>
    802003fa:	b985                	j	8020006a <cprintf>
            cprintf("Supervisor software interrupt\n");
    802003fc:	00001517          	auipc	a0,0x1
    80200400:	a4c50513          	addi	a0,a0,-1460 # 80200e48 <etext+0x4b4>
    80200404:	b19d                	j	8020006a <cprintf>
void interrupt_handler(struct trapframe *tf) {
    80200406:	1141                	addi	sp,sp,-16
    80200408:	e022                	sd	s0,0(sp)
    8020040a:	e406                	sd	ra,8(sp)
             *(2)计数器（ticks）加一
             *(3)当计数器加到100的时候，我们会输出一个`100ticks`表示我们触发了100次时钟中断，同时打印次数（num）加一
            * (4)判断打印次数，当打印次数为10时，调用<sbi.h>中的关机函数关机
            */
             clock_set_next_event();
            if (++ticks % TICK_NUM == 0) {
    8020040c:	00004417          	auipc	s0,0x4
    80200410:	c0440413          	addi	s0,s0,-1020 # 80204010 <ticks>
             clock_set_next_event();
    80200414:	d4dff0ef          	jal	ra,80200160 <clock_set_next_event>
            if (++ticks % TICK_NUM == 0) {
    80200418:	601c                	ld	a5,0(s0)
    8020041a:	06400713          	li	a4,100
    8020041e:	0785                	addi	a5,a5,1
    80200420:	02e7f733          	remu	a4,a5,a4
    80200424:	e01c                	sd	a5,0(s0)
    80200426:	c305                	beqz	a4,80200446 <interrupt_handler+0x88>
                print_ticks();
            }
            if(ticks==1000){sbi_shutdown();}
    80200428:	6018                	ld	a4,0(s0)
    8020042a:	3e800793          	li	a5,1000
    8020042e:	02f70563          	beq	a4,a5,80200458 <interrupt_handler+0x9a>
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
    80200432:	60a2                	ld	ra,8(sp)
    80200434:	6402                	ld	s0,0(sp)
    80200436:	0141                	addi	sp,sp,16
    80200438:	8082                	ret
            cprintf("Supervisor external interrupt\n");
    8020043a:	00001517          	auipc	a0,0x1
    8020043e:	a7e50513          	addi	a0,a0,-1410 # 80200eb8 <etext+0x524>
    80200442:	b125                	j	8020006a <cprintf>
            print_trapframe(tf);
    80200444:	bf29                	j	8020035e <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
    80200446:	06400593          	li	a1,100
    8020044a:	00001517          	auipc	a0,0x1
    8020044e:	a5e50513          	addi	a0,a0,-1442 # 80200ea8 <etext+0x514>
    80200452:	c19ff0ef          	jal	ra,8020006a <cprintf>
}
    80200456:	bfc9                	j	80200428 <interrupt_handler+0x6a>
}
    80200458:	6402                	ld	s0,0(sp)
    8020045a:	60a2                	ld	ra,8(sp)
    8020045c:	0141                	addi	sp,sp,16
            if(ticks==1000){sbi_shutdown();}
    8020045e:	a1fd                	j	8020094c <sbi_shutdown>

0000000080200460 <trap>:
    }
}

/* trap_dispatch - dispatch based on what type of trap occurred */
static inline void trap_dispatch(struct trapframe *tf) {
    if ((intptr_t)tf->cause < 0) {
    80200460:	11853783          	ld	a5,280(a0)
    80200464:	0007c763          	bltz	a5,80200472 <trap+0x12>
    switch (tf->cause) {
    80200468:	472d                	li	a4,11
    8020046a:	00f76363          	bltu	a4,a5,80200470 <trap+0x10>
 * trap - handles or dispatches an exception/interrupt. if and when trap()
 * returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf) { trap_dispatch(tf); }
    8020046e:	8082                	ret
            print_trapframe(tf);
    80200470:	b5fd                	j	8020035e <print_trapframe>
        interrupt_handler(tf);
    80200472:	b7b1                	j	802003be <interrupt_handler>

0000000080200474 <__alltraps>:
    80200474:	14011073          	csrw	sscratch,sp
    80200478:	712d                	addi	sp,sp,-288
    8020047a:	e002                	sd	zero,0(sp)
    8020047c:	e406                	sd	ra,8(sp)
    8020047e:	ec0e                	sd	gp,24(sp)
    80200480:	f012                	sd	tp,32(sp)
    80200482:	f416                	sd	t0,40(sp)
    80200484:	f81a                	sd	t1,48(sp)
    80200486:	fc1e                	sd	t2,56(sp)
    80200488:	e0a2                	sd	s0,64(sp)
    8020048a:	e4a6                	sd	s1,72(sp)
    8020048c:	e8aa                	sd	a0,80(sp)
    8020048e:	ecae                	sd	a1,88(sp)
    80200490:	f0b2                	sd	a2,96(sp)
    80200492:	f4b6                	sd	a3,104(sp)
    80200494:	f8ba                	sd	a4,112(sp)
    80200496:	fcbe                	sd	a5,120(sp)
    80200498:	e142                	sd	a6,128(sp)
    8020049a:	e546                	sd	a7,136(sp)
    8020049c:	e94a                	sd	s2,144(sp)
    8020049e:	ed4e                	sd	s3,152(sp)
    802004a0:	f152                	sd	s4,160(sp)
    802004a2:	f556                	sd	s5,168(sp)
    802004a4:	f95a                	sd	s6,176(sp)
    802004a6:	fd5e                	sd	s7,184(sp)
    802004a8:	e1e2                	sd	s8,192(sp)
    802004aa:	e5e6                	sd	s9,200(sp)
    802004ac:	e9ea                	sd	s10,208(sp)
    802004ae:	edee                	sd	s11,216(sp)
    802004b0:	f1f2                	sd	t3,224(sp)
    802004b2:	f5f6                	sd	t4,232(sp)
    802004b4:	f9fa                	sd	t5,240(sp)
    802004b6:	fdfe                	sd	t6,248(sp)
    802004b8:	14001473          	csrrw	s0,sscratch,zero
    802004bc:	100024f3          	csrr	s1,sstatus
    802004c0:	14102973          	csrr	s2,sepc
    802004c4:	143029f3          	csrr	s3,stval
    802004c8:	14202a73          	csrr	s4,scause
    802004cc:	e822                	sd	s0,16(sp)
    802004ce:	e226                	sd	s1,256(sp)
    802004d0:	e64a                	sd	s2,264(sp)
    802004d2:	ea4e                	sd	s3,272(sp)
    802004d4:	ee52                	sd	s4,280(sp)
    802004d6:	850a                	mv	a0,sp
    802004d8:	f89ff0ef          	jal	ra,80200460 <trap>

00000000802004dc <__trapret>:
    802004dc:	6492                	ld	s1,256(sp)
    802004de:	6932                	ld	s2,264(sp)
    802004e0:	10049073          	csrw	sstatus,s1
    802004e4:	14191073          	csrw	sepc,s2
    802004e8:	60a2                	ld	ra,8(sp)
    802004ea:	61e2                	ld	gp,24(sp)
    802004ec:	7202                	ld	tp,32(sp)
    802004ee:	72a2                	ld	t0,40(sp)
    802004f0:	7342                	ld	t1,48(sp)
    802004f2:	73e2                	ld	t2,56(sp)
    802004f4:	6406                	ld	s0,64(sp)
    802004f6:	64a6                	ld	s1,72(sp)
    802004f8:	6546                	ld	a0,80(sp)
    802004fa:	65e6                	ld	a1,88(sp)
    802004fc:	7606                	ld	a2,96(sp)
    802004fe:	76a6                	ld	a3,104(sp)
    80200500:	7746                	ld	a4,112(sp)
    80200502:	77e6                	ld	a5,120(sp)
    80200504:	680a                	ld	a6,128(sp)
    80200506:	68aa                	ld	a7,136(sp)
    80200508:	694a                	ld	s2,144(sp)
    8020050a:	69ea                	ld	s3,152(sp)
    8020050c:	7a0a                	ld	s4,160(sp)
    8020050e:	7aaa                	ld	s5,168(sp)
    80200510:	7b4a                	ld	s6,176(sp)
    80200512:	7bea                	ld	s7,184(sp)
    80200514:	6c0e                	ld	s8,192(sp)
    80200516:	6cae                	ld	s9,200(sp)
    80200518:	6d4e                	ld	s10,208(sp)
    8020051a:	6dee                	ld	s11,216(sp)
    8020051c:	7e0e                	ld	t3,224(sp)
    8020051e:	7eae                	ld	t4,232(sp)
    80200520:	7f4e                	ld	t5,240(sp)
    80200522:	7fee                	ld	t6,248(sp)
    80200524:	6142                	ld	sp,16(sp)
    80200526:	10200073          	sret

000000008020052a <printnum>:
    8020052a:	02069813          	slli	a6,a3,0x20
    8020052e:	7179                	addi	sp,sp,-48
    80200530:	02085813          	srli	a6,a6,0x20
    80200534:	e052                	sd	s4,0(sp)
    80200536:	03067a33          	remu	s4,a2,a6
    8020053a:	f022                	sd	s0,32(sp)
    8020053c:	ec26                	sd	s1,24(sp)
    8020053e:	e84a                	sd	s2,16(sp)
    80200540:	f406                	sd	ra,40(sp)
    80200542:	e44e                	sd	s3,8(sp)
    80200544:	84aa                	mv	s1,a0
    80200546:	892e                	mv	s2,a1
    80200548:	fff7041b          	addiw	s0,a4,-1
    8020054c:	2a01                	sext.w	s4,s4
    8020054e:	03067e63          	bgeu	a2,a6,8020058a <printnum+0x60>
    80200552:	89be                	mv	s3,a5
    80200554:	00805763          	blez	s0,80200562 <printnum+0x38>
    80200558:	347d                	addiw	s0,s0,-1
    8020055a:	85ca                	mv	a1,s2
    8020055c:	854e                	mv	a0,s3
    8020055e:	9482                	jalr	s1
    80200560:	fc65                	bnez	s0,80200558 <printnum+0x2e>
    80200562:	1a02                	slli	s4,s4,0x20
    80200564:	00001797          	auipc	a5,0x1
    80200568:	9a478793          	addi	a5,a5,-1628 # 80200f08 <etext+0x574>
    8020056c:	020a5a13          	srli	s4,s4,0x20
    80200570:	9a3e                	add	s4,s4,a5
    80200572:	7402                	ld	s0,32(sp)
    80200574:	000a4503          	lbu	a0,0(s4)
    80200578:	70a2                	ld	ra,40(sp)
    8020057a:	69a2                	ld	s3,8(sp)
    8020057c:	6a02                	ld	s4,0(sp)
    8020057e:	85ca                	mv	a1,s2
    80200580:	87a6                	mv	a5,s1
    80200582:	6942                	ld	s2,16(sp)
    80200584:	64e2                	ld	s1,24(sp)
    80200586:	6145                	addi	sp,sp,48
    80200588:	8782                	jr	a5
    8020058a:	03065633          	divu	a2,a2,a6
    8020058e:	8722                	mv	a4,s0
    80200590:	f9bff0ef          	jal	ra,8020052a <printnum>
    80200594:	b7f9                	j	80200562 <printnum+0x38>

0000000080200596 <vprintfmt>:
    80200596:	7119                	addi	sp,sp,-128
    80200598:	f4a6                	sd	s1,104(sp)
    8020059a:	f0ca                	sd	s2,96(sp)
    8020059c:	ecce                	sd	s3,88(sp)
    8020059e:	e8d2                	sd	s4,80(sp)
    802005a0:	e4d6                	sd	s5,72(sp)
    802005a2:	e0da                	sd	s6,64(sp)
    802005a4:	fc5e                	sd	s7,56(sp)
    802005a6:	f06a                	sd	s10,32(sp)
    802005a8:	fc86                	sd	ra,120(sp)
    802005aa:	f8a2                	sd	s0,112(sp)
    802005ac:	f862                	sd	s8,48(sp)
    802005ae:	f466                	sd	s9,40(sp)
    802005b0:	ec6e                	sd	s11,24(sp)
    802005b2:	892a                	mv	s2,a0
    802005b4:	84ae                	mv	s1,a1
    802005b6:	8d32                	mv	s10,a2
    802005b8:	8a36                	mv	s4,a3
    802005ba:	02500993          	li	s3,37
    802005be:	5b7d                	li	s6,-1
    802005c0:	00001a97          	auipc	s5,0x1
    802005c4:	97ca8a93          	addi	s5,s5,-1668 # 80200f3c <etext+0x5a8>
    802005c8:	00001b97          	auipc	s7,0x1
    802005cc:	b50b8b93          	addi	s7,s7,-1200 # 80201118 <error_string>
    802005d0:	000d4503          	lbu	a0,0(s10)
    802005d4:	001d0413          	addi	s0,s10,1
    802005d8:	01350a63          	beq	a0,s3,802005ec <vprintfmt+0x56>
    802005dc:	c121                	beqz	a0,8020061c <vprintfmt+0x86>
    802005de:	85a6                	mv	a1,s1
    802005e0:	0405                	addi	s0,s0,1
    802005e2:	9902                	jalr	s2
    802005e4:	fff44503          	lbu	a0,-1(s0)
    802005e8:	ff351ae3          	bne	a0,s3,802005dc <vprintfmt+0x46>
    802005ec:	00044603          	lbu	a2,0(s0)
    802005f0:	02000793          	li	a5,32
    802005f4:	4c81                	li	s9,0
    802005f6:	4881                	li	a7,0
    802005f8:	5c7d                	li	s8,-1
    802005fa:	5dfd                	li	s11,-1
    802005fc:	05500513          	li	a0,85
    80200600:	4825                	li	a6,9
    80200602:	fdd6059b          	addiw	a1,a2,-35
    80200606:	0ff5f593          	zext.b	a1,a1
    8020060a:	00140d13          	addi	s10,s0,1
    8020060e:	04b56263          	bltu	a0,a1,80200652 <vprintfmt+0xbc>
    80200612:	058a                	slli	a1,a1,0x2
    80200614:	95d6                	add	a1,a1,s5
    80200616:	4194                	lw	a3,0(a1)
    80200618:	96d6                	add	a3,a3,s5
    8020061a:	8682                	jr	a3
    8020061c:	70e6                	ld	ra,120(sp)
    8020061e:	7446                	ld	s0,112(sp)
    80200620:	74a6                	ld	s1,104(sp)
    80200622:	7906                	ld	s2,96(sp)
    80200624:	69e6                	ld	s3,88(sp)
    80200626:	6a46                	ld	s4,80(sp)
    80200628:	6aa6                	ld	s5,72(sp)
    8020062a:	6b06                	ld	s6,64(sp)
    8020062c:	7be2                	ld	s7,56(sp)
    8020062e:	7c42                	ld	s8,48(sp)
    80200630:	7ca2                	ld	s9,40(sp)
    80200632:	7d02                	ld	s10,32(sp)
    80200634:	6de2                	ld	s11,24(sp)
    80200636:	6109                	addi	sp,sp,128
    80200638:	8082                	ret
    8020063a:	87b2                	mv	a5,a2
    8020063c:	00144603          	lbu	a2,1(s0)
    80200640:	846a                	mv	s0,s10
    80200642:	00140d13          	addi	s10,s0,1
    80200646:	fdd6059b          	addiw	a1,a2,-35
    8020064a:	0ff5f593          	zext.b	a1,a1
    8020064e:	fcb572e3          	bgeu	a0,a1,80200612 <vprintfmt+0x7c>
    80200652:	85a6                	mv	a1,s1
    80200654:	02500513          	li	a0,37
    80200658:	9902                	jalr	s2
    8020065a:	fff44783          	lbu	a5,-1(s0)
    8020065e:	8d22                	mv	s10,s0
    80200660:	f73788e3          	beq	a5,s3,802005d0 <vprintfmt+0x3a>
    80200664:	ffed4783          	lbu	a5,-2(s10)
    80200668:	1d7d                	addi	s10,s10,-1
    8020066a:	ff379de3          	bne	a5,s3,80200664 <vprintfmt+0xce>
    8020066e:	b78d                	j	802005d0 <vprintfmt+0x3a>
    80200670:	fd060c1b          	addiw	s8,a2,-48
    80200674:	00144603          	lbu	a2,1(s0)
    80200678:	846a                	mv	s0,s10
    8020067a:	fd06069b          	addiw	a3,a2,-48
    8020067e:	0006059b          	sext.w	a1,a2
    80200682:	02d86463          	bltu	a6,a3,802006aa <vprintfmt+0x114>
    80200686:	00144603          	lbu	a2,1(s0)
    8020068a:	002c169b          	slliw	a3,s8,0x2
    8020068e:	0186873b          	addw	a4,a3,s8
    80200692:	0017171b          	slliw	a4,a4,0x1
    80200696:	9f2d                	addw	a4,a4,a1
    80200698:	fd06069b          	addiw	a3,a2,-48
    8020069c:	0405                	addi	s0,s0,1
    8020069e:	fd070c1b          	addiw	s8,a4,-48
    802006a2:	0006059b          	sext.w	a1,a2
    802006a6:	fed870e3          	bgeu	a6,a3,80200686 <vprintfmt+0xf0>
    802006aa:	f40ddce3          	bgez	s11,80200602 <vprintfmt+0x6c>
    802006ae:	8de2                	mv	s11,s8
    802006b0:	5c7d                	li	s8,-1
    802006b2:	bf81                	j	80200602 <vprintfmt+0x6c>
    802006b4:	fffdc693          	not	a3,s11
    802006b8:	96fd                	srai	a3,a3,0x3f
    802006ba:	00ddfdb3          	and	s11,s11,a3
    802006be:	00144603          	lbu	a2,1(s0)
    802006c2:	2d81                	sext.w	s11,s11
    802006c4:	846a                	mv	s0,s10
    802006c6:	bf35                	j	80200602 <vprintfmt+0x6c>
    802006c8:	000a2c03          	lw	s8,0(s4)
    802006cc:	00144603          	lbu	a2,1(s0)
    802006d0:	0a21                	addi	s4,s4,8
    802006d2:	846a                	mv	s0,s10
    802006d4:	bfd9                	j	802006aa <vprintfmt+0x114>
    802006d6:	4705                	li	a4,1
    802006d8:	008a0593          	addi	a1,s4,8
    802006dc:	01174463          	blt	a4,a7,802006e4 <vprintfmt+0x14e>
    802006e0:	1a088e63          	beqz	a7,8020089c <vprintfmt+0x306>
    802006e4:	000a3603          	ld	a2,0(s4)
    802006e8:	46c1                	li	a3,16
    802006ea:	8a2e                	mv	s4,a1
    802006ec:	2781                	sext.w	a5,a5
    802006ee:	876e                	mv	a4,s11
    802006f0:	85a6                	mv	a1,s1
    802006f2:	854a                	mv	a0,s2
    802006f4:	e37ff0ef          	jal	ra,8020052a <printnum>
    802006f8:	bde1                	j	802005d0 <vprintfmt+0x3a>
    802006fa:	000a2503          	lw	a0,0(s4)
    802006fe:	85a6                	mv	a1,s1
    80200700:	0a21                	addi	s4,s4,8
    80200702:	9902                	jalr	s2
    80200704:	b5f1                	j	802005d0 <vprintfmt+0x3a>
    80200706:	4705                	li	a4,1
    80200708:	008a0593          	addi	a1,s4,8
    8020070c:	01174463          	blt	a4,a7,80200714 <vprintfmt+0x17e>
    80200710:	18088163          	beqz	a7,80200892 <vprintfmt+0x2fc>
    80200714:	000a3603          	ld	a2,0(s4)
    80200718:	46a9                	li	a3,10
    8020071a:	8a2e                	mv	s4,a1
    8020071c:	bfc1                	j	802006ec <vprintfmt+0x156>
    8020071e:	00144603          	lbu	a2,1(s0)
    80200722:	4c85                	li	s9,1
    80200724:	846a                	mv	s0,s10
    80200726:	bdf1                	j	80200602 <vprintfmt+0x6c>
    80200728:	85a6                	mv	a1,s1
    8020072a:	02500513          	li	a0,37
    8020072e:	9902                	jalr	s2
    80200730:	b545                	j	802005d0 <vprintfmt+0x3a>
    80200732:	00144603          	lbu	a2,1(s0)
    80200736:	2885                	addiw	a7,a7,1
    80200738:	846a                	mv	s0,s10
    8020073a:	b5e1                	j	80200602 <vprintfmt+0x6c>
    8020073c:	4705                	li	a4,1
    8020073e:	008a0593          	addi	a1,s4,8
    80200742:	01174463          	blt	a4,a7,8020074a <vprintfmt+0x1b4>
    80200746:	14088163          	beqz	a7,80200888 <vprintfmt+0x2f2>
    8020074a:	000a3603          	ld	a2,0(s4)
    8020074e:	46a1                	li	a3,8
    80200750:	8a2e                	mv	s4,a1
    80200752:	bf69                	j	802006ec <vprintfmt+0x156>
    80200754:	03000513          	li	a0,48
    80200758:	85a6                	mv	a1,s1
    8020075a:	e03e                	sd	a5,0(sp)
    8020075c:	9902                	jalr	s2
    8020075e:	85a6                	mv	a1,s1
    80200760:	07800513          	li	a0,120
    80200764:	9902                	jalr	s2
    80200766:	0a21                	addi	s4,s4,8
    80200768:	6782                	ld	a5,0(sp)
    8020076a:	46c1                	li	a3,16
    8020076c:	ff8a3603          	ld	a2,-8(s4)
    80200770:	bfb5                	j	802006ec <vprintfmt+0x156>
    80200772:	000a3403          	ld	s0,0(s4)
    80200776:	008a0713          	addi	a4,s4,8
    8020077a:	e03a                	sd	a4,0(sp)
    8020077c:	14040263          	beqz	s0,802008c0 <vprintfmt+0x32a>
    80200780:	0fb05763          	blez	s11,8020086e <vprintfmt+0x2d8>
    80200784:	02d00693          	li	a3,45
    80200788:	0cd79163          	bne	a5,a3,8020084a <vprintfmt+0x2b4>
    8020078c:	00044783          	lbu	a5,0(s0)
    80200790:	0007851b          	sext.w	a0,a5
    80200794:	cf85                	beqz	a5,802007cc <vprintfmt+0x236>
    80200796:	00140a13          	addi	s4,s0,1
    8020079a:	05e00413          	li	s0,94
    8020079e:	000c4563          	bltz	s8,802007a8 <vprintfmt+0x212>
    802007a2:	3c7d                	addiw	s8,s8,-1
    802007a4:	036c0263          	beq	s8,s6,802007c8 <vprintfmt+0x232>
    802007a8:	85a6                	mv	a1,s1
    802007aa:	0e0c8e63          	beqz	s9,802008a6 <vprintfmt+0x310>
    802007ae:	3781                	addiw	a5,a5,-32
    802007b0:	0ef47b63          	bgeu	s0,a5,802008a6 <vprintfmt+0x310>
    802007b4:	03f00513          	li	a0,63
    802007b8:	9902                	jalr	s2
    802007ba:	000a4783          	lbu	a5,0(s4)
    802007be:	3dfd                	addiw	s11,s11,-1
    802007c0:	0a05                	addi	s4,s4,1
    802007c2:	0007851b          	sext.w	a0,a5
    802007c6:	ffe1                	bnez	a5,8020079e <vprintfmt+0x208>
    802007c8:	01b05963          	blez	s11,802007da <vprintfmt+0x244>
    802007cc:	3dfd                	addiw	s11,s11,-1
    802007ce:	85a6                	mv	a1,s1
    802007d0:	02000513          	li	a0,32
    802007d4:	9902                	jalr	s2
    802007d6:	fe0d9be3          	bnez	s11,802007cc <vprintfmt+0x236>
    802007da:	6a02                	ld	s4,0(sp)
    802007dc:	bbd5                	j	802005d0 <vprintfmt+0x3a>
    802007de:	4705                	li	a4,1
    802007e0:	008a0c93          	addi	s9,s4,8
    802007e4:	01174463          	blt	a4,a7,802007ec <vprintfmt+0x256>
    802007e8:	08088d63          	beqz	a7,80200882 <vprintfmt+0x2ec>
    802007ec:	000a3403          	ld	s0,0(s4)
    802007f0:	0a044d63          	bltz	s0,802008aa <vprintfmt+0x314>
    802007f4:	8622                	mv	a2,s0
    802007f6:	8a66                	mv	s4,s9
    802007f8:	46a9                	li	a3,10
    802007fa:	bdcd                	j	802006ec <vprintfmt+0x156>
    802007fc:	000a2783          	lw	a5,0(s4)
    80200800:	4719                	li	a4,6
    80200802:	0a21                	addi	s4,s4,8
    80200804:	41f7d69b          	sraiw	a3,a5,0x1f
    80200808:	8fb5                	xor	a5,a5,a3
    8020080a:	40d786bb          	subw	a3,a5,a3
    8020080e:	02d74163          	blt	a4,a3,80200830 <vprintfmt+0x29a>
    80200812:	00369793          	slli	a5,a3,0x3
    80200816:	97de                	add	a5,a5,s7
    80200818:	639c                	ld	a5,0(a5)
    8020081a:	cb99                	beqz	a5,80200830 <vprintfmt+0x29a>
    8020081c:	86be                	mv	a3,a5
    8020081e:	00000617          	auipc	a2,0x0
    80200822:	71a60613          	addi	a2,a2,1818 # 80200f38 <etext+0x5a4>
    80200826:	85a6                	mv	a1,s1
    80200828:	854a                	mv	a0,s2
    8020082a:	0ce000ef          	jal	ra,802008f8 <printfmt>
    8020082e:	b34d                	j	802005d0 <vprintfmt+0x3a>
    80200830:	00000617          	auipc	a2,0x0
    80200834:	6f860613          	addi	a2,a2,1784 # 80200f28 <etext+0x594>
    80200838:	85a6                	mv	a1,s1
    8020083a:	854a                	mv	a0,s2
    8020083c:	0bc000ef          	jal	ra,802008f8 <printfmt>
    80200840:	bb41                	j	802005d0 <vprintfmt+0x3a>
    80200842:	00000417          	auipc	s0,0x0
    80200846:	6de40413          	addi	s0,s0,1758 # 80200f20 <etext+0x58c>
    8020084a:	85e2                	mv	a1,s8
    8020084c:	8522                	mv	a0,s0
    8020084e:	e43e                	sd	a5,8(sp)
    80200850:	116000ef          	jal	ra,80200966 <strnlen>
    80200854:	40ad8dbb          	subw	s11,s11,a0
    80200858:	01b05b63          	blez	s11,8020086e <vprintfmt+0x2d8>
    8020085c:	67a2                	ld	a5,8(sp)
    8020085e:	00078a1b          	sext.w	s4,a5
    80200862:	3dfd                	addiw	s11,s11,-1
    80200864:	85a6                	mv	a1,s1
    80200866:	8552                	mv	a0,s4
    80200868:	9902                	jalr	s2
    8020086a:	fe0d9ce3          	bnez	s11,80200862 <vprintfmt+0x2cc>
    8020086e:	00044783          	lbu	a5,0(s0)
    80200872:	00140a13          	addi	s4,s0,1
    80200876:	0007851b          	sext.w	a0,a5
    8020087a:	d3a5                	beqz	a5,802007da <vprintfmt+0x244>
    8020087c:	05e00413          	li	s0,94
    80200880:	bf39                	j	8020079e <vprintfmt+0x208>
    80200882:	000a2403          	lw	s0,0(s4)
    80200886:	b7ad                	j	802007f0 <vprintfmt+0x25a>
    80200888:	000a6603          	lwu	a2,0(s4)
    8020088c:	46a1                	li	a3,8
    8020088e:	8a2e                	mv	s4,a1
    80200890:	bdb1                	j	802006ec <vprintfmt+0x156>
    80200892:	000a6603          	lwu	a2,0(s4)
    80200896:	46a9                	li	a3,10
    80200898:	8a2e                	mv	s4,a1
    8020089a:	bd89                	j	802006ec <vprintfmt+0x156>
    8020089c:	000a6603          	lwu	a2,0(s4)
    802008a0:	46c1                	li	a3,16
    802008a2:	8a2e                	mv	s4,a1
    802008a4:	b5a1                	j	802006ec <vprintfmt+0x156>
    802008a6:	9902                	jalr	s2
    802008a8:	bf09                	j	802007ba <vprintfmt+0x224>
    802008aa:	85a6                	mv	a1,s1
    802008ac:	02d00513          	li	a0,45
    802008b0:	e03e                	sd	a5,0(sp)
    802008b2:	9902                	jalr	s2
    802008b4:	6782                	ld	a5,0(sp)
    802008b6:	8a66                	mv	s4,s9
    802008b8:	40800633          	neg	a2,s0
    802008bc:	46a9                	li	a3,10
    802008be:	b53d                	j	802006ec <vprintfmt+0x156>
    802008c0:	03b05163          	blez	s11,802008e2 <vprintfmt+0x34c>
    802008c4:	02d00693          	li	a3,45
    802008c8:	f6d79de3          	bne	a5,a3,80200842 <vprintfmt+0x2ac>
    802008cc:	00000417          	auipc	s0,0x0
    802008d0:	65440413          	addi	s0,s0,1620 # 80200f20 <etext+0x58c>
    802008d4:	02800793          	li	a5,40
    802008d8:	02800513          	li	a0,40
    802008dc:	00140a13          	addi	s4,s0,1
    802008e0:	bd6d                	j	8020079a <vprintfmt+0x204>
    802008e2:	00000a17          	auipc	s4,0x0
    802008e6:	63fa0a13          	addi	s4,s4,1599 # 80200f21 <etext+0x58d>
    802008ea:	02800513          	li	a0,40
    802008ee:	02800793          	li	a5,40
    802008f2:	05e00413          	li	s0,94
    802008f6:	b565                	j	8020079e <vprintfmt+0x208>

00000000802008f8 <printfmt>:
    802008f8:	715d                	addi	sp,sp,-80
    802008fa:	02810313          	addi	t1,sp,40
    802008fe:	f436                	sd	a3,40(sp)
    80200900:	869a                	mv	a3,t1
    80200902:	ec06                	sd	ra,24(sp)
    80200904:	f83a                	sd	a4,48(sp)
    80200906:	fc3e                	sd	a5,56(sp)
    80200908:	e0c2                	sd	a6,64(sp)
    8020090a:	e4c6                	sd	a7,72(sp)
    8020090c:	e41a                	sd	t1,8(sp)
    8020090e:	c89ff0ef          	jal	ra,80200596 <vprintfmt>
    80200912:	60e2                	ld	ra,24(sp)
    80200914:	6161                	addi	sp,sp,80
    80200916:	8082                	ret

0000000080200918 <sbi_console_putchar>:
    80200918:	4781                	li	a5,0
    8020091a:	00003717          	auipc	a4,0x3
    8020091e:	6e673703          	ld	a4,1766(a4) # 80204000 <SBI_CONSOLE_PUTCHAR>
    80200922:	88ba                	mv	a7,a4
    80200924:	852a                	mv	a0,a0
    80200926:	85be                	mv	a1,a5
    80200928:	863e                	mv	a2,a5
    8020092a:	00000073          	ecall
    8020092e:	87aa                	mv	a5,a0
    80200930:	8082                	ret

0000000080200932 <sbi_set_timer>:
    80200932:	4781                	li	a5,0
    80200934:	00003717          	auipc	a4,0x3
    80200938:	6e473703          	ld	a4,1764(a4) # 80204018 <SBI_SET_TIMER>
    8020093c:	88ba                	mv	a7,a4
    8020093e:	852a                	mv	a0,a0
    80200940:	85be                	mv	a1,a5
    80200942:	863e                	mv	a2,a5
    80200944:	00000073          	ecall
    80200948:	87aa                	mv	a5,a0
    8020094a:	8082                	ret

000000008020094c <sbi_shutdown>:
    8020094c:	4781                	li	a5,0
    8020094e:	00003717          	auipc	a4,0x3
    80200952:	6ba73703          	ld	a4,1722(a4) # 80204008 <SBI_SHUTDOWN>
    80200956:	88ba                	mv	a7,a4
    80200958:	853e                	mv	a0,a5
    8020095a:	85be                	mv	a1,a5
    8020095c:	863e                	mv	a2,a5
    8020095e:	00000073          	ecall
    80200962:	87aa                	mv	a5,a0
    80200964:	8082                	ret

0000000080200966 <strnlen>:
    80200966:	4781                	li	a5,0
    80200968:	e589                	bnez	a1,80200972 <strnlen+0xc>
    8020096a:	a811                	j	8020097e <strnlen+0x18>
    8020096c:	0785                	addi	a5,a5,1
    8020096e:	00f58863          	beq	a1,a5,8020097e <strnlen+0x18>
    80200972:	00f50733          	add	a4,a0,a5
    80200976:	00074703          	lbu	a4,0(a4)
    8020097a:	fb6d                	bnez	a4,8020096c <strnlen+0x6>
    8020097c:	85be                	mv	a1,a5
    8020097e:	852e                	mv	a0,a1
    80200980:	8082                	ret

0000000080200982 <memset>:
    80200982:	ca01                	beqz	a2,80200992 <memset+0x10>
    80200984:	962a                	add	a2,a2,a0
    80200986:	87aa                	mv	a5,a0
    80200988:	0785                	addi	a5,a5,1
    8020098a:	feb78fa3          	sb	a1,-1(a5)
    8020098e:	fec79de3          	bne	a5,a2,80200988 <memset+0x6>
    80200992:	8082                	ret

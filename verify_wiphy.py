#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Verify that aic8800_fdrv.ko was built against backports-6.18.26 headers.
# If the driver used backports cfg80211.h (struct wiphy with multi-radio
# n_radios@+0x520 / radios@+0x528), then wiphy_priv(wiphy) = wiphy +
# sizeof(backports wiphy) which is > 0x520. If it used the kernel 6.12.94
# headers (no multi-radio), wiphy_priv = wiphy + 0x520.
#
# We inspect rwnx_cfg80211_init and look for the A64 `add xN, x0, #imm`
# instruction that computes wiphy_priv (rn = x0, the wiphy_new_nm return).
# imm > 0x520 => backports headers were used (correct). imm == 0x520 =>
# kernel headers were used (ABI mismatch -> wiphy_register would fail).
import sys
import struct

def main():
    if len(sys.argv) < 2:
        print('usage: verify_wiphy.py <aic8800_fdrv.ko>')
        return 2
    fn = sys.argv[1]
    print('checking', fn)
    try:
        from elftools.elf.elffile import ELFFile
    except ImportError:
        print('pyelftools not available, skipping')
        return 1
    try:
        with open(fn, 'rb') as f:
            elf = ELFFile(f)
            symtab = elf.get_section_by_name('.symtab')
            text = elf.get_section_by_name('.text')
            if symtab is None or text is None:
                print('  no .symtab/.text, skipping')
                return 1
            val = size = None
            for s in symtab.iter_symbols():
                if s.name == 'rwnx_cfg80211_init':
                    val, size = s['st_value'], s['st_size']
                    break
            if val is None:
                print('  rwnx_cfg80211_init not found, skipping')
                return 1
            f.seek(text['sh_offset'] + val)
            code = f.read(min(size, 128))
            found = False
            for off in range(0, len(code) - 4, 4):
                insn = struct.unpack('<I', code[off:off+4])[0]
                if (insn & 0xFF000000) == 0x91000000:  # ADD immediate
                    rd = insn & 0x1F
                    rn = (insn >> 5) & 0x1F
                    imm = (insn >> 10) & 0xFFF
                    if rn == 0:
                        print('  off 0x%x: add x%d, x0, #0x%x' % (off, rd, imm))
                        if imm > 0x520:
                            print('  OK: wiphy_priv offset > 0x520 -> backports headers used')
                            found = True
                        elif imm == 0x520:
                            print('  FAIL: wiphy_priv offset == 0x520 -> kernel headers used!')
            if not found:
                print('  WARNING: no add xN, x0, #imm>0x520 found; review disassembly')
                return 2
            return 0
    except Exception as e:
        print('  verify failed:', e)
        return 1

if __name__ == '__main__':
    sys.exit(main())

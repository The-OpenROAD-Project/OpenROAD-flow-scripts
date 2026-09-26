#!/usr/bin/env python3

from factory_base import FactoryBase
from single_port_ram import SinglePortRAM
from dual_port_ram import DualPortRAM
from single_port_regfile import SinglePortRegFile
from dual_port_regfile import DualPortRegFile


class MemoryFactory(FactoryBase):
    """MemoryFactory "implementation" - done to avoid circular imports"""

    pass


# Register known memory types
MemoryFactory.register("RAM", "SP", SinglePortRAM)
MemoryFactory.register("RAM", "DP", DualPortRAM)
MemoryFactory.register("RF", "SP", SinglePortRegFile)
MemoryFactory.register("RF", "DP", DualPortRegFile)

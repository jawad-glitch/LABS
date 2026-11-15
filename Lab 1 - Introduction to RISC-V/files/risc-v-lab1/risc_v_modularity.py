#!/usr/bin/env python3

class RISCVModularity:
    def __init__(self, base_isa):
        self.base_isa = base_isa
        self.extensions = []

    def add_extension(self, name, description):
        self.extensions.append((name, description))

    def show_configuration(self):
        print(f"Base ISA: {self.base_isa}")
        print("Extensions:")
        for name, description in self.extensions:
            print(f"  {name}: {description}")

    def generate_isa_string(self):
        names = "".join(name for name, _ in self.extensions)
        return f"{self.base_isa}{names}"


def main():
    configurations = []

    embedded = RISCVModularity("RV32I")
    embedded.add_extension("M", "Integer multiplication and division")
    embedded.add_extension("C", "Compressed instructions")
    configurations.append(("Embedded example", embedded))

    general = RISCVModularity("RV64I")
    general.add_extension("M", "Integer multiplication and division")
    general.add_extension("A", "Atomic instructions")
    general.add_extension("F", "Single-precision floating point")
    general.add_extension("D", "Double-precision floating point")
    general.add_extension("C", "Compressed instructions")
    configurations.append(("General-purpose example", general))

    hpc = RISCVModularity("RV64I")
    hpc.add_extension("M", "Integer multiplication and division")
    hpc.add_extension("A", "Atomic instructions")
    hpc.add_extension("F", "Single-precision floating point")
    hpc.add_extension("D", "Double-precision floating point")
    hpc.add_extension("V", "Vector extension")
    configurations.append(("HPC-oriented example", hpc))

    print("RISC-V Modularity Demonstration")
    print("=" * 40)

    for title, config in configurations:
        print(f"\n{title}")
        config.show_configuration()
        print(f"Illustrative ISA string: {config.generate_isa_string()}")
        print("-" * 40)


if __name__ == "__main__":
    main()

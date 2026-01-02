# Project Name - Xilinx AC701 Support

## About this Fork
I forked this repository to add dedicated support for the **Xilinx AC701** evaluation board.

* **Status:** Bitstream generation (`.bit`) is currently functional and verified.

---

## To-Do List
I am working on the following features to fully support the AC701 workflow:

1.  **MCS File Generation:** Implement automated generation of `.mcs` files.
2.  **Flash Programming:** Enable support for programming the onboard Flash memory.
3.  **MMI Updates:** Automate the `.mmi` (Memory Map Info) file update process.
4.  **Windows Support:** Ensure the entire build process works seamlessly on Windows.

---

## Quick Start

The build process currently requires a **MinGW64** terminal. Follow these steps to generate the bitstream:

1.  **Navigate to the synthesis directory:**
    ```bash
    cd fpga/xilinx_ac701_board/synthesis/xilinx
    ```

2.  **Generate the bitstream:**
    Execute the generation script:
    ```bash
    ./0_create_bitstream.sh
    ```

3.  **Update MMI files (Manual Step):**
    Manually update the `.mmi` files based on the data in:
    `work/openMSP430_fpga_bram_report.csv`

4.  **Initialize memory:**
    Run the memory initialization script:
    ```bash
    ./1_initialize_pmem.sh
    ```




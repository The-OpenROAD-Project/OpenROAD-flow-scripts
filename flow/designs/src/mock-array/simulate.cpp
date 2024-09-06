#include "VMockArray.h"
#include "verilated.h"
#include <verilated_vcd_c.h>

/**
 * Returns the VCD output path.
 *
 * If RESULTS_DIR is set, the VCD file will be written there. If not, it will be written to the 
 * current directory.
 **/
static std::string getVCDFilePath() {

    std::string results_dir = getenv("RESULTS_DIR");
    std::string vcd_file_name = "MockArrayTestbench.vcd";
    if (results_dir.empty()) {
        results_dir = ".";
    }
    std::string vcd_path = results_dir + "/" + vcd_file_name;
    return vcd_path;
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    VMockArray * top = new VMockArray;
    
    Verilated::traceEverOn(true);
    auto *vcd = new VerilatedVcdC;

    top->reset = 1;
    top->clock = 0;

    QData *inputs[] = {
    &top->io_ins_down_0,
    &top->io_ins_down_1,
    &top->io_ins_down_2,
    &top->io_ins_down_3,
    &top->io_ins_down_4,
    &top->io_ins_down_5,
    &top->io_ins_down_6,
    &top->io_ins_down_7,
    &top->io_ins_left_0,
    &top->io_ins_left_1,
    &top->io_ins_left_2,
    &top->io_ins_left_3,
    &top->io_ins_left_4,
    &top->io_ins_left_5,
    &top->io_ins_left_6,
    &top->io_ins_left_7,
    &top->io_ins_right_0,
    &top->io_ins_right_1,
    &top->io_ins_right_2,
    &top->io_ins_right_3,
    &top->io_ins_right_4,
    &top->io_ins_right_5,
    &top->io_ins_right_6,
    &top->io_ins_right_7,
    &top->io_ins_up_0,
    &top->io_ins_up_1,
    &top->io_ins_up_2,
    &top->io_ins_up_3,
    &top->io_ins_up_4,
    &top->io_ins_up_5,
    &top->io_ins_up_6,
    &top->io_ins_up_7
    };

    top->trace(vcd, 99); // Trace all levels of hierarchy
    vcd->open(getVCDFilePath().c_str());

    int tick = 0;
    for (int j = 0; j < sizeof(inputs)/sizeof(*inputs); j++) {
        for (int i = 0; i < 5; i++) {
            // if (Verilated::gotFinish()) {
            //     goto done;
            // }
            *inputs[j] = tick ^ ((tick/2)%2 ? 0 : 0xffffffffffffffffUL);
            if (tick == 9) {
                top->reset = 0;
            }

            for (int k = 0; k < 2; k++) {
                top->eval();
                vcd->dump(tick++);
                top->clock = !top->clock;
            }
        }
    }
    done:
    vcd->flush();
    vcd->close();

    top->final();
    delete top;
    return 0;
}

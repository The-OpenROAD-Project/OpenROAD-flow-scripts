/* This file contain switch for the following
 *    WITHFAKERAM - skip behavior model definition for memory usage,
 *                  instead, instantiate appropriate fakeram from 
 *                  the platform data
 *    TESTHARNESS - MegaBoom netilst does contain testing mechanism
 *                  This is higher up module that instantiate MegaBoom.
 *                  This switch change the top level of the entire design.
 *                  Please change the ORFS script accordingly.
*/

// use fakeram_* from ASAP7 platform data
`define WITHFAKERAM

// do not enabl test harness, keep top level as MegaBoom
// `define TESTHARNESS

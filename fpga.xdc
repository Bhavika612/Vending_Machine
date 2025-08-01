## Zybo Z7-20 Constraints for Vending Machine

## Clock signal

set_property -dict { PACKAGE_PIN K17   IOSTANDARD LVCMOS33 } [get_ports { sysclk }]; #IO_L12P_T1_MRCC_35 Sch=sysclk

create_clock -add -name sys_clk_pin -period 8.00 -waveform {0 4} [get_ports { sysclk }];
 
## Switches - Input Mapping

## SW[1:0] = coin_value: 00=1 unit, 01=2 units, 10=5 units, 11=10 units

## SW[3:2] = selection: 00=chips(10), 01=drink(15), 10=chocolate(20), 11=none

set_property -dict { PACKAGE_PIN G15   IOSTANDARD LVCMOS33 } [get_ports { sw[0] }]; #IO_L19N_T3_VREF_35 Sch=sw[0]

set_property -dict { PACKAGE_PIN P15   IOSTANDARD LVCMOS33 } [get_ports { sw[1] }]; #IO_L24P_T3_34 Sch=sw[1]

set_property -dict { PACKAGE_PIN W13   IOSTANDARD LVCMOS33 } [get_ports { sw[2] }]; #IO_L4N_T0_34 Sch=sw[2]

set_property -dict { PACKAGE_PIN T16   IOSTANDARD LVCMOS33 } [get_ports { sw[3] }]; #IO_L9P_T1_DQS_34 Sch=sw[3]
 
## Buttons - Control Mapping

## BTN[0] = coin_insert (insert coin with value set by SW[1:0])

## BTN[1] = cancel (cancel transaction and return money)

## BTN[2] = reset (system reset)

## BTN[3] = unused

set_property -dict { PACKAGE_PIN K18   IOSTANDARD LVCMOS33 } [get_ports { btn[0] }]; #IO_L12N_T1_MRCC_35 Sch=btn[0]

set_property -dict { PACKAGE_PIN P16   IOSTANDARD LVCMOS33 } [get_ports { btn[1] }]; #IO_L24N_T3_34 Sch=btn[1]

set_property -dict { PACKAGE_PIN K19   IOSTANDARD LVCMOS33 } [get_ports { btn[2] }]; #IO_L10P_T1_AD11P_35 Sch=btn[2]

set_property -dict { PACKAGE_PIN Y16   IOSTANDARD LVCMOS33 } [get_ports { btn[3] }]; #IO_L7P_T1_34 Sch=btn[3]
 
## LEDs - State Indication

## LED[0] = IDLE state

## LED[1] = COLLECTING coins state  

## LED[2] = WAIT_SELECTION state

## LED[3] = DISPENSE state

set_property -dict { PACKAGE_PIN M14   IOSTANDARD LVCMOS33 } [get_ports { led[0] }]; #IO_L23P_T3_35 Sch=led[0]

set_property -dict { PACKAGE_PIN M15   IOSTANDARD LVCMOS33 } [get_ports { led[1] }]; #IO_L23N_T3_35 Sch=led[1]

set_property -dict { PACKAGE_PIN G14   IOSTANDARD LVCMOS33 } [get_ports { led[2] }]; #IO_0_35 Sch=led[2]

set_property -dict { PACKAGE_PIN D18   IOSTANDARD LVCMOS33 } [get_ports { led[3] }]; #IO_L3N_T0_DQS_AD1N_35 Sch=led[3]
 
## RGB LED 5 - Product Dispensed Indication

## Red = Chips dispensed

## Green = Soft drink dispensed  

## Blue = Chocolate dispensed

set_property -dict { PACKAGE_PIN Y11   IOSTANDARD LVCMOS33 } [get_ports { led5_r }]; #IO_L18N_T2_13 Sch=led5_r

set_property -dict { PACKAGE_PIN T5    IOSTANDARD LVCMOS33 } [get_ports { led5_g }]; #IO_L19P_T3_13 Sch=led5_g

set_property -dict { PACKAGE_PIN Y12   IOSTANDARD LVCMOS33 } [get_ports { led5_b }]; #IO_L20P_T3_13 Sch=led5_b
 
## RGB LED 6 - Balance/Status Indication

## Red = Insufficient balance for selected item

## Green = Sufficient balance / Transaction successful

## Blue = Change being returned / Waiting for selection

set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports { led6_r }]; #IO_L18P_T2_34 Sch=led6_r

set_property -dict { PACKAGE_PIN F17   IOSTANDARD LVCMOS33 } [get_ports { led6_g }]; #IO_L6N_T0_VREF_35 Sch=led6_g

set_property -dict { PACKAGE_PIN M17   IOSTANDARD LVCMOS33 } [get_ports { led6_b }]; #IO_L8P_T1_AD10P_35 Sch=led6_b
 
// Input Mapping:

// SW[1:0] - coin_value (00=1, 01=2, 10=5, 11=10)

// SW[3:2] - selection (00=chips, 01=drink, 10=chocolate, 11=none)

// BTN[0] - coin_insert

// BTN[1] - cancel

// BTN[2] - reset

// BTN[3] - unused
 
// Output Mapping:

// LED[0] - IDLE state indicator

// LED[1] - COLLECTING coins indicator  

// LED[2] - WAIT_SELECTION indicator

// LED[3] - DISPENSE indicator

// RGB LED 5 - Product dispensed (R=chips, G=drink, B=chocolate)

// RGB LED 6 - Change/Status (G=sufficient balance, R=insufficient, B=change returned)

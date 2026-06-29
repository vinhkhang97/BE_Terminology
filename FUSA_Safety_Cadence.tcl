Functional Safety (FuSa) is a report that evaluates the safety of a system or design by analyzing potential faults and failures. 
It categorizes these faults into specific types, such as Unobserved Undetected, Unobserved Detected, Dangerous Detected, and Dangerous Undetected. 
The FuSa report includes metrics that help in assessing how safe the system is and serves as a tool for further analysis, such as FMEDA (Failure Modes, Effects, and Diagnostic Analysis) and ASIL (Automotive Safety Integrity Level) rating. 
This report is crucial for ensuring that designs meet the required safety standards.
There are 3 type in FUSA:
  + DCLS: (Dual Core Clock Step):  A type of safety mechanism, Usually consists of two or three modules:
  for example:
     o A safety-critical master module
     o A redundant/clone module performing the same task as the master
     o A comparator module to ensure that the other two modules are in sync and that an error has not occurred
  For the safety mechanism to be effective, there must be physical separation of the DCLS modules or groups. This is to prevent a common fault impacting more than one of the modules, which would break the safety mechanism.
  For this RAK, it is assumed that the DCLS logic was already inserted into the RTL, either manually or with a tool such as Stratus.
  + TMR: (Triple Modular Redundancy): A type of safety mechanism, The value stored on at least two of the three flops will be propagated downstream,
  For safety-critical parent flops, two clone flops and voting logic will be added,
  If an error occurs on a single flop, the correct value will still be propagated.
  For the safety mechanism to be effective, there must be physical separation of the three flops. This is to prevent a common fault impacting more than one of the flops, which would break the safety mechanism.
  For this RAK the original parent flops are in the RTL. Genus will add the clone flops and voting logic.
  + Bus protection: the net from master module is not larger than 30um with checker.

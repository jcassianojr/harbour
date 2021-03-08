
   /* TRY / CATCH / FINALLY / END */
   #xcommand TRY => BEGIN SEQUENCE WITH __BreakBlock()
   #xcommand CATCH [<!oErr!>] => RECOVER [USING <oErr>] <-oErr->
   #xcommand FINALLY => ALWAYS


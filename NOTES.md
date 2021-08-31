# Vagrant Usage

After installation on the host machine, run the following commands.

```
cd $HOME/git-repos/openlst-401
vagrant up
vagrant reload
vagrant ssh
```

Using the VM, run the following commands.

Check that the CC1110 is recognized.

```
cc-tool
#  Programmer: CC Debugger
#  Target: CC1110
#  No actions specified
```

If not, press the "Reset" button on the CC Debugger so that the light turns
green.

Compile the bootloader. Use the provided Python tool the flash the bootloader.
Check that the bootloader flash was successful using the radio terminal.

```
cd project/
make openlst_437_bootloader
flash_bootloader --keys \
 FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF \
 FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF --hwid 0001 openlst_437_bootloader.hex
radio_terminal
#< lst ascii "OpenLST BL 3f5e025"
#< lst ascii "OpenLST BL 3f5e025"
#< lst ascii "OpenLST BL 3f5e025"
```

Compile the user application. Sign the application. Use the provided Python tool
to load the user application over UART via the bootloader.

```
make openlst_437_radio
sign_radio --signing-key FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF \
 openlst_437_radio.hex openlst_437_radio.sig
bootload_radio --signature-file openlst_437_radio.sig \
 -i 0001 openlst_437_radio.hex
```

Check that the application flash was successful using the radio terminal. To do
this check, run the radio terminal. Then, press the "Reset" button on the CC
Debugger. The bootloader should send a single message, followed by a single
message from the user application.

```
radio_terminal
#< lst ascii "OpenLST BL 3f5e025"
#< lst ascii "OpenLST 3f5e025"
```

When finished using the VM, exit the VM.

```
exit
```

After exiting the VM, halt Vagrant.

```
vagrant halt
```

Inside the VM, if changes have been made, be sure to clean.

```
cd project/
make clean
```

See below for useful test commands.

```
lst_relay ascii "abcdefghijklmnopqrstuvwxyz"
lst_relay ascii "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
lst_relay ascii "zyxwvutsrqponmlkjihgfedcba"
```

Received results (success!):

```
< unknown_sys 1111226162636465666768696a6b6c6d6e6f707172737475767778797a22
< unknown_sys 1111224142434445464748494a4b4c4d4e4f505152535455565758595a22
< unknown_sys 1111227a797877767574737271706f6e6d6c6b6a69686766656463626122
```


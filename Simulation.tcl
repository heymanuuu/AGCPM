set ns [new Simulator]

proc finish {} {
    global ns nf
    $ns flush-trace
    close $nf   
    #exec nam ./nam/starlink2_1.nam 
}

# Create trace files
set tracefile [open ./tr/starlink2_1.tr w]
$ns trace-all $tracefile
set nf [open ./nam/starlink2_1.nam w]
$ns namtrace-all $nf

array set nodes {}

proc createSatelliteNodes {filename ns} {
    global nodes
    set node_num 0
    set node_count 0
    set nodeFile [open $filename r]
    set data [read $nodeFile]
    close $nodeFile
    set data [string trim $data]
    set lines [split $data "\n"]

    foreach line $lines {
        set line [string trim $line]
        set satellite_names [split $line " "]
       
        foreach satellite_name $satellite_names {
            if {$satellite_name ne ""} {
                set node [$ns node]
                set nodes($satellite_name) $node
                puts "Created node for satellite: $satellite_name"
                incr node_num
                incr node_count
            }
        }
    }
    return $node_count
}

proc createLinksFromDelayFile {filename ns} {
    global nodes
    set links_cnt 0
    # Open and read the delay file
    set file [open $filename r]
    set delay_data [split [read $file] "\n"]
    close $file

    # Iterate through each line in the delay data
    foreach line $delay_data {
        # Skip empty lines
        if {[string trim $line] eq ""} {
            continue
        }
        # Parse each line to get satellite names and delay
        set parts [split $line]
        if {[llength $parts] != 3} {
            puts "Error: Invalid line format: $line"
            continue
        }

        set satellite1 [lindex $parts 0]
        set satellite2 [lindex $parts 1]
        set delay [lindex $parts 2]
        
        # Create bidirectional links between nodes
        $ns duplex-link $nodes($satellite1) $nodes($satellite2) 200Mb ${delay}ms DropTail
        #puts ${delay}ms
        # Set the link cost (delay) using the 'cost' command
        $ns cost $nodes($satellite1) $nodes($satellite2) $delay
        $ns cost $nodes($satellite2) $nodes($satellite1) $delay
        # Output for verification
        #puts "Created bidirectional link between $satellite1 and $satellite2 with delay $delay ms"
        incr links_cnt
    }
        #puts "num of links : $links_cnt"
}

# create satellite nodes
createSatelliteNodes "./sat/starlinkNode1.txt" $ns
#puts "Total nodes created: $nodeCount"

set SenderPlace "SenderPlace"
set ReceiverPlace "ReceiverPlace"
set node [$ns node]
set nodes($SenderPlace) $node
set node [$ns node]
set nodes($ReceiverPlace) $node

# Assuming nodes array is already populated from createSatelliteNodes function
createLinksFromDelayFile "./linkInfo/starlinkDelay1.txt" $ns

Agent/TCP set dupacks_ 1
Agent/TCP set cwnd_ 50
Agent/TCP set ssthresh_ 50
set tcp_sender [new Agent/TCP]
set tcp_receiver [new Agent/TCPSink]

$tcp_sender set window_ 100
$tcp_sender set windowInit_ 100  
$tcp_sender set packetSize_ 800  

$tcp_receiver set window_ 100  
$tcp_receiver set windowInit_ 100


$ns attach-agent $nodes($SenderPlace) $tcp_sender
$ns attach-agent $nodes($ReceiverPlace) $tcp_receiver

$ns connect $tcp_sender $tcp_receiver

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $tcp_sender
$cbr set packetSize_ 800
$cbr set rate_ 5M
$cbr set random_ 1

$ns at 1.0 "$cbr start"
$ns at 4000.0 "$cbr stop"

$ns at 5000 "finish"
$ns run

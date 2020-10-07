#!/usr/bin/ruby
$stdout.sync = true

puts "Starting parent: #{Process.pid}"
Signal.trap("TERM") do
  puts "Parent #{Process.pid} got a SIGTERM. Exiting in 10 seconds."
  sleep 10
  exit 0
end

children = []
0.upto(5) do |w|
  children << Process.fork do
    Signal.trap("TERM") do
      puts "Child #{Process.pid} got a SIGTERM. Ignoring."
    end
    puts "Starting child: #{Process.pid}"
    sleep w + 60
    exit 0
  end
end

system 'ps xf'

children.each do |child|
  pid, status = Process.waitpid2(child)
  puts "Child #{pid} exited with status #{status}"
end

sleep 30*3600
